# Assignment 5 — Deploy a Highly Available Two-Tier Application on AWS (VPC + ALB + ASG + Multi-AZ RDS)

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will design and deploy a highly available two-tier web application on AWS: highly available networking across two Availability Zones, an Application Load Balancer, an Auto Scaling Group for the web tier, and a private Multi-AZ RDS database. You must prove high availability with real failure tests.

---

# Task 1 — Create HA Networking (VPC + 4 Subnets + IGW + NAT + Route Tables)

## Goal

Build a VPC (10.0.0.0/16) with two public and two private subnets across two Availability Zones, an Internet Gateway, a NAT Gateway, and the matching public/private route tables.

### Evidence

#### Screenshot 1 — VPC details showing CIDR 10.0.0.0/16

![ha-vpc details 10.0.0.0/16 with resource map of 4 subnets across ap-southeast-5a and 5b](screenshots/a5-ss1.png)

---

#### Screenshot 2 — Subnets list showing four subnets and their Availability Zones

![Subnets list: ha-public-a 10.0.1.0/24 and ha-private-a 10.0.11.0/24 in ap-southeast-5a, ha-public-b 10.0.2.0/24 and ha-private-b 10.0.12.0/24 in ap-southeast-5b](screenshots/a5-ss2.png)

---

#### Screenshot 3 — Public route table showing the Internet Gateway route and both public-subnet associations

![ha-public-rt routes 0.0.0.0/0 to ha-igw](screenshots/a5-ss3.png)

![ha-public-rt subnet associations ha-public-a and ha-public-b](screenshots/a5-ss3b.png)

---

#### Screenshot 4 — Private route table showing the NAT Gateway route and both private-subnet associations

![ha-private-rt routes 0.0.0.0/0 to NAT gateway](screenshots/a5-ss4.png)

![ha-private-rt subnet associations ha-private-a and ha-private-b](screenshots/a5-ss4b.png)

---

#### Screenshot 5 — NAT Gateway status showing Available and the Elastic IP

![ha-nat Available with Elastic IP 43.217.14.150 in ha-public-a](screenshots/a5-ss5.png)

---

# Task 2 — Create Security Groups (ALB, EC2, RDS) with Least Privilege

## Goal

Create `ha-alb-sg` (HTTP public), `ha-web-sg` (HTTP only from `ha-alb-sg`, SSH from your IP), and `ha-db-sg` (database port only from `ha-web-sg`).

### Evidence

#### Screenshot 6 — ALB Security Group inbound rules

![ha-alb-sg inbound HTTP 80 from 0.0.0.0/0](screenshots/a5-ss6.png)

---

#### Screenshot 7 — EC2 Security Group inbound rules showing the ALB Security Group reference and SSH from your IP

![ha-web-sg inbound HTTP 80 from ha-alb-sg and SSH 22 from my IP](screenshots/a5-ss7.png)

---

#### Screenshot 8 — RDS Security Group inbound rule showing the database port allowed only from the EC2 Security Group

![ha-db-sg inbound MySQL 3306 only from ha-web-sg](screenshots/a5-ss8.png)

---

# Task 3 — Deploy Database Tier (RDS Multi-AZ in Private Subnets)

## Goal

Launch a private, Multi-AZ RDS database (MySQL or PostgreSQL) using the private DB Subnet Group and `ha-db-sg`.

### Evidence

#### Screenshot 9 — RDS summary showing Multi-AZ = Yes and Publicly accessible = No

![ha-app-db configuration: Multi-AZ Yes, secondary zone ap-southeast-5a, MySQL 8.4.9, encrypted](screenshots/a5-ss9.png)

---

#### Screenshot 10 — RDS connectivity section showing the DB Subnet Group and Security Group

![ha-app-db connectivity: Publicly accessible No, ha-vpc, ha-db-subnet-group, ha-db-sg](screenshots/a5-ss10.png)

---

# Task 4 — Build a Launch Template (User Data Installs App + Connects to DB)

## Goal

Create a Launch Template whose user data installs the web-server runtime, deploys the application, configures the database connection, and starts the required services.

### Evidence

#### Screenshot 11 — Launch Template details showing that user data exists, including a visible snippet

![ha-web-lt launch template user data: installs Apache and PHP, reads DB password from SSM, writes app](screenshots/a5-ss11.png)

---

#### Screenshot 12 — A running instance created from the template showing that the application responds on port 80 through a local test or browser using its public IP

![Instance launched from ha-web-lt: curl localhost shows DB write and read OK](screenshots/a5-ss12.png)

---

# Task 5 — Create an Application Load Balancer (ALB) Across 2 Public Subnets

## Goal

Create an internet-facing ALB across both public subnets with an HTTP listener and a healthy instance target group.

### Evidence

#### Screenshot 13 — ALB details showing two public subnets in two Availability Zones

![ha-alb internet-facing across ha-public-a (5a) and ha-public-b (5b)](screenshots/a5-ss13.png)

---

#### Screenshot 14 — Target group showing at least one healthy target

![ha-web-tg with 2 healthy targets](screenshots/a5-ss14.png)

---

# Task 6 — Create Auto Scaling Group (ASG) in 2 Public Subnets

## Goal

Create an Auto Scaling Group from the Launch Template across both public subnets, with desired capacity 2, minimum 2, and maximum 4, registered to the ALB target group.

### Evidence

#### Screenshot 15 — Auto Scaling Group showing desired, minimum, and maximum capacity and the selected subnet Availability Zones

![ha-web-asg desired 2, limits 2-4, subnets in ap-southeast-5a and 5b](screenshots/a5-ss15.png)

---

#### Screenshot 16 — EC2 instances list showing two running instances in different Availability Zones

![ha-web instances running in ap-southeast-5a and ap-southeast-5b](screenshots/a5-ss16.png)

---

# Task 7 — Configure App to Use RDS + Validate Read/Write

## Goal

Confirm the application communicates with the RDS database through the ALB DNS name with at least one read and one write operation.

### Evidence

#### Screenshot 17 — Browser showing the application loaded through the ALB DNS name with the URL visible

![App through ALB DNS with URL visible, served from ap-southeast-5a](screenshots/a5-ss17.png)

---

#### Screenshot 18 — Proof of a database write through a UI message or database query output

![DB write proof: recorded visit #12, visits table read from RDS alternating between 5a and 5b](screenshots/a5-ss18.png)

---

# Task 8 — High Availability Tests (Must Do Both)

## Goal

Test A: terminate one web instance and confirm the Auto Scaling Group replaces it automatically without interrupting the ALB.

Test B: simulate an Availability Zone impact (stop, detach, or reduce desired capacity in one AZ) and confirm the application stays available.

### Evidence

#### Screenshot 19 — EC2 showing the terminated instance and the newly launched instance; timestamps are helpful

![Before: i-04ab8c19a43b75aec in ap-southeast-5a terminated, ASG not yet reacted](screenshots/a5-ss19a.png)

![After: ASG launched replacement i-0cc08b2abc2228498 in ap-southeast-5a](screenshots/a5-ss19.png)

---

#### Screenshot 20 — Target group showing healthy targets after replacement

![ha-web-tg back to 2 healthy targets including replacement i-0cc08b2abc2228498](screenshots/a5-ss20.png)

---

#### Screenshot 21 — Evidence that an instance was removed, detached, placed in Standby, or stopped in one Availability Zone

![Run 1: i-0b02ac15f92bd3762 in ap-southeast-5b placed into Standby without replacement (desired 1)](screenshots/a5-ss21.png)

![Run 2: 5b instance in Standby with replacement; ASG launched i-0653115de2770424f in 5b to restore capacity](screenshots/a5-ss21b.png)

---

#### Screenshot 22 — Browser showing that the ALB DNS endpoint still works during the change

![ALB DNS still serving during the 5b Standby: 8 latest requests all from ap-southeast-5a, visit #601](screenshots/a5-ss22.png)

---

# Task 9 — Architecture and Test-Results Summary

## Goal

Summarize the VPC/subnet layout, the ALB and Auto Scaling Group setup, the private Multi-AZ RDS setup, and the results of both high-availability tests.

### Evidence

#### Screenshot 23 — A simple architecture diagram, which may be hand-drawn, or an AWS console overview showing the components

![Architecture: ha-vpc across ap-southeast-5a/5b, ALB, ASG web tier, Multi-AZ RDS in private subnets](screenshots/a5-ss23.png)

---

### Notes

Summarize the VPC and subnets across the two Availability Zones.

`ha-vpc` (`10.0.0.0/16`, region `ap-southeast-5`) spans two Availability Zones. **Public:** `ha-public-a` `10.0.1.0/24` (5a) and `ha-public-b` `10.0.2.0/24` (5b), both on `ha-public-rt` with `0.0.0.0/0 → ha-igw`, auto-assign public IPv4 on. **Private:** `ha-private-a` `10.0.11.0/24` (5a) and `ha-private-b` `10.0.12.0/24` (5b), both on `ha-private-rt` with `0.0.0.0/0 → ha-nat`. The NAT Gateway (Elastic IP, in `ha-public-a`) was created and verified Available (SS4/SS5), then deleted after capture to control cost, because no private-subnet workload needs outbound internet (RDS makes no outbound calls and the web tier is public). After deletion the private default route shows as blackhole; the local route is unaffected.

Summarize the ALB and Auto Scaling Group setup.

`ha-alb` is an internet-facing ALB in both public subnets with an HTTP:80 listener forwarding to target group `ha-web-tg` (instance targets, health check `/health.html` every 10 s, 2 healthy / 2 unhealthy thresholds, 30 s deregistration delay). `ha-web-asg` uses launch template `ha-web-lt` (Amazon Linux 2023, `ha-web-sg`, IMDSv2 required, instance role `ha-web-role`) with **min 2 / desired 2 / max 4** across both public subnets and **ELB health checks** (180 s grace). A mixed-instances override lists `t3.micro` then `t3.small`, because `t3.micro` had no capacity in 5a; the 5a instance therefore launched as `t3.small`. User data installs Apache + PHP, reads the DB password from SSM Parameter Store, downloads the RDS CA bundle, and writes a PHP hit-counter app that **writes** one row per request and **reads** back the total and latest rows, showing which instance and AZ served the request. Security-group chain: Internet → `ha-alb-sg` (80 from `0.0.0.0/0`) → `ha-web-sg` (80 only from `ha-alb-sg`, 22 only from my IP `/32`) → `ha-db-sg`.

Summarize the private Multi-AZ RDS setup.

`ha-app-db` is RDS MySQL 8.4.9 on `db.t4g.micro` with **Multi-AZ = Yes** (primary 5b, synchronous standby 5a), **Publicly accessible = No**, gp3 storage encrypted with KMS, in `ha-db-subnet-group` (`ha-private-a` + `ha-private-b`). `ha-db-sg` allows 3306 only from `ha-web-sg` (security-group reference, no CIDR). The app connects over TLS using the RDS global CA bundle. The master password was generated randomly into SSM Parameter Store (SecureString) and is read at boot by the instance role, so it never appears in user data, screenshots, or chat. MySQL 8.4 was chosen because RDS MySQL 8.0 left standard support on 31 Jul 2026 and would bill Extended Support.

Summarize the results of both high-availability tests.

An availability probe requested the ALB URL every 2 s for 25 minutes across both tests: **683 of 687 requests returned 200 (99.4%)**.

**Test A (instance failure):** at 23:12 MYT I terminated `i-04ab8c19a43b75aec` (5a) from the EC2 console. The ASG detected it, drained the target (23:14:00) and launched replacement `i-0cc08b2abc2228498` in the **same AZ** (23:14:02); the target group was back to 2 healthy (SS19, SS20). The instance in 5b kept serving throughout. **Finding:** 4 requests failed in an 18 s window (2 × 502, 2 timeouts) right after the termination, because a console termination bypasses the ASG's graceful deregistration and the ALB needs two failed health checks (10 s apart) before removing the target. In production, terminate or replace through the ASG (or add a lifecycle hook) so the target drains before the instance stops.

**Test B (AZ impact, Approach 2 Standby):** the ASG minimum was temporarily lowered to 1, then `i-0b02ac15f92bd3762` (5b) was placed in **Standby** (removed from the target group). For the whole Standby window **52 consecutive probes returned 200, all served from 5a**, with zero errors (SS21, SS22). A second run placed it in Standby with replacement, and the ASG launched `i-0653115de2770424f` in 5b to restore capacity (SS21b). The whole A05 environment is torn down right after testing to control cost, so capacity was not scaled back up.

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about the high-availability build, including the ALB URL (or a redacted screenshot), three to five lines on what you built and how you tested high availability, and one proof screenshot.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

https://www.linkedin.com/posts/javeson-francois-liu-999135437_dmibypravinmishra-aws-highavailability-share-7508912842021208064-j3p5

---

#### Screenshot of LinkedIn post

![Published LinkedIn post: Multi-AZ HA build and fault-injection results](screenshots/a5-linkedin-ss1.png)

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not expose passwords, connection strings, private keys, or account IDs

---

# Completion Checklist

- [x] Task 1: VPC, four subnets, IGW, NAT Gateway, and route tables created (Screenshots 1–5)
- [x] Task 2: Least-privilege ALB, EC2, and RDS security groups created (Screenshots 6–8)
- [x] Task 3: Private Multi-AZ RDS created (Screenshots 9–10)
- [x] Task 4: Self-configuring Launch Template created and tested (Screenshots 11–12)
- [x] Task 5: ALB created across both public subnets (Screenshots 13–14)
- [x] Task 6: Auto Scaling Group running two instances across two AZs (Screenshots 15–16)
- [x] Task 7: Application verified through the ALB with a database read and write (Screenshots 17–18)
- [x] Task 8: Both high-availability tests completed (Screenshots 19–22)
- [x] Task 9: Architecture and test-results summary completed (Screenshot 23 & Notes)
- [x] LinkedIn post published and URL submitted
- [x] No sensitive data exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*