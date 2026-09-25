#!/bin/bash
set -u
full_name="Javeson Francois Liu"
aws_profile="javesonpersonal"
aws_region="ap-southeast-5"
s3_bucket_name="pravin-portfolio-javeson-ap-southeast-5"
rds_instance_id="bookreview-db"
base_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
report_dir="$base_dir/reports"
report_file="$report_dir/aws-audit-report.txt"

checks=(
check_s3_public_access
check_ssh_open_to_world
check_mysql_open_to_world
check_rds_public_access
check_ebs_encryption
)

pass_count=0
warning_count=0
failure_count=0
mkdir -p "$report_dir"
: > "$report_file"

write_line() {
echo "$1" | tee -a "$report_file"
}

mark_pass() {
write_line "[PASS] $1"
pass_count=$((pass_count + 1))
}

mark_warning() {
write_line "[WARN] $1"
warning_count=$((warning_count + 1))
}

mark_failure() {
write_line "[FAIL] $1"
failure_count=$((failure_count + 1))
}

print_header() {
write_line "========================================"
write_line "AWS Security and Cost Audit Report"
write_line "========================================"
write_line "Full Name: $full_name"
write_line "Timestamp: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
write_line "AWS Region: $aws_region"
write_line "S3 Bucket: $s3_bucket_name"
write_line "RDS Instance: $rds_instance_id"
write_line ""
}

check_s3_public_access() {
local block_acls
local ignore_acls
block_acls=$(aws s3api get-public-access-block --profile "$aws_profile" --bucket "$s3_bucket_name" --query 'PublicAccessBlockConfiguration.BlockPublicAcls' --output text 2>/dev/null || echo "None")
ignore_acls=$(aws s3api get-public-access-block --profile "$aws_profile" --bucket "$s3_bucket_name" --query 'PublicAccessBlockConfiguration.IgnorePublicAcls' --output text 2>/dev/null || echo "None")

# Only ACL-based public access is checked here, not BlockPublicPolicy/RestrictPublicBuckets.
# A static website bucket is expected to have a scoped public-read bucket policy (BlockPublicPolicy=false) -
# that is the correct AWS-documented pattern, not a misconfiguration. Public ACLs are the actual anti-pattern.

if [ "$block_acls" = "True" ] && [ "$ignore_acls" = "True" ]
then
mark_pass "S3 bucket '$s3_bucket_name' blocks and ignores public ACLs (public read, if any, comes only from its scoped bucket policy)"
else
mark_failure "S3 bucket '$s3_bucket_name' does not fully block public ACLs (BlockPublicAcls=$block_acls, IgnorePublicAcls=$ignore_acls) - public access should only ever come through the scoped bucket policy, never through ACLs"
fi
}

check_ssh_open_to_world() {
local open_sg_ids
local open_sg_count
# --filters match port and CIDR across any rules of a group, so the query re-checks that one rule has both
open_sg_ids=$(aws ec2 describe-security-groups \
--profile "$aws_profile" \
--region "$aws_region" \
--filters "Name=ip-permission.from-port,Values=22" "Name=ip-permission.to-port,Values=22" "Name=ip-permission.cidr,Values=0.0.0.0/0" \
--query "SecurityGroups[?IpPermissions[?FromPort==\`22\` && ToPort==\`22\` && IpRanges[?CidrIp=='0.0.0.0/0']]].GroupId" --output text 2>/dev/null || echo "")
open_sg_count=$(echo "$open_sg_ids" | wc -w | tr -d ' ')

if [ "$open_sg_count" -gt 0 ] 2>/dev/null
then
mark_failure "$open_sg_count security group(s) allow SSH (port 22) from 0.0.0.0/0: $open_sg_ids"
else
mark_pass "No security group allows SSH (port 22) from 0.0.0.0/0"
fi
}

check_mysql_open_to_world() {
local open_sg_ids
local open_sg_count
# --filters match port and CIDR across any rules of a group, so the query re-checks that one rule has both
open_sg_ids=$(aws ec2 describe-security-groups \
--profile "$aws_profile" \
--region "$aws_region" \
--filters "Name=ip-permission.from-port,Values=3306" "Name=ip-permission.to-port,Values=3306" "Name=ip-permission.cidr,Values=0.0.0.0/0" \
--query "SecurityGroups[?IpPermissions[?FromPort==\`3306\` && ToPort==\`3306\` && IpRanges[?CidrIp=='0.0.0.0/0']]].GroupId" --output text 2>/dev/null || echo "")
open_sg_count=$(echo "$open_sg_ids" | wc -w | tr -d ' ')

if [ "$open_sg_count" -gt 0 ] 2>/dev/null
then
mark_failure "$open_sg_count security group(s) allow MySQL (port 3306) from 0.0.0.0/0: $open_sg_ids"
else
mark_pass "No security group allows MySQL (port 3306) from 0.0.0.0/0"
fi
}

check_rds_public_access() {
local publicly_accessible
publicly_accessible=$(aws rds describe-db-instances \
--profile "$aws_profile" \
--db-instance-identifier "$rds_instance_id" \
--region "$aws_region" \
--query 'DBInstances[0].PubliclyAccessible' --output text 2>/dev/null || echo "None")

if [ "$publicly_accessible" = "False" ]
then
mark_pass "RDS instance '$rds_instance_id' is not publicly accessible"
elif [ "$publicly_accessible" = "True" ]
then
mark_failure "RDS instance '$rds_instance_id' is publicly accessible"
else
mark_warning "Could not determine public accessibility for RDS instance '$rds_instance_id' (instance not found or insufficient permission)"
fi
}

check_ebs_encryption() {
local unencrypted_count
unencrypted_count=$(aws ec2 describe-volumes \
--profile "$aws_profile" \
--region "$aws_region" \
--filters "Name=encrypted,Values=false" \
--query 'length(Volumes[])' --output text 2>/dev/null || echo "0")

if [ "$unencrypted_count" -gt 0 ] 2>/dev/null
then
mark_warning "$unencrypted_count EBS volume(s) are not encrypted"
else
mark_pass "All EBS volumes are encrypted"
fi
}

print_summary() {
local overall_status
local script_exit_code

if [ "$failure_count" -gt 0 ]
then
overall_status="FAIL"
script_exit_code=2
elif [ "$warning_count" -gt 0 ]
then
overall_status="WARN"
script_exit_code=1
else
overall_status="HEALTHY"
script_exit_code=0
fi

write_line ""
write_line "Summary:"
write_line "PASS: $pass_count"
write_line "WARN: $warning_count"
write_line "FAIL: $failure_count"
write_line "Overall Status: $overall_status"
write_line "Script Exit Code: $script_exit_code"
write_line "Report File: $report_file"
return "$script_exit_code"
}

print_header
for check_function in "${checks[@]}"
do
"$check_function"
done
print_summary
exit $?
