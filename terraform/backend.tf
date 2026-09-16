# Remote state backend (S3)
#
# HOW TO ENABLE:
#   1. Run `terraform init` and `terraform apply` WITHOUT this backend block first.
#   2. Create an S3 bucket and (optionally) a DynamoDB table for state locking.
#   3. Uncomment the block below, fill in your bucket/table names.
#   4. Run `terraform init -migrate-state` — Terraform will copy local state to S3.
#
# terraform {
#   backend "s3" {
#     bucket         = "<your-tf-state-bucket-name>"
#     key            = "portfolio-site/terraform.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "<your-tf-lock-table-name>"  # optional but recommended
#   }
# }
