# Assignment 6 — Capstone Assignment — Deploy Book Review App (Three-Tier Architecture) on AWS

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

This is the most important assignment of the course. You will deploy the Book Review App in a fully production-style three-tier architecture on AWS: a Next.js Web Tier behind Nginx and a public ALB, a private Node.js/Express App Tier behind an internal ALB, and a private Multi-AZ MySQL RDS database with a read replica. You are expected to design, deploy, isolate, debug, and document the result independently.

---

# Task 1 — Architecture Diagram

## Goal

Create an architecture diagram showing the custom VPC (10.0.0.0/16), the six subnets across two Availability Zones (two public Web Tier, two private App Tier, two private Database Tier), the public ALB, Web Tier EC2/Nginx, internal ALB, private App Tier EC2, private Multi-AZ RDS with its read replica, and the permitted traffic flow.

### Evidence

#### Diagram image or link

![Three-tier architecture: Users to Internet Gateway to public ALB, two Web Tier EC2 (Nginx + Next.js) in public subnets 10.0.1.0/24 and 10.0.2.0/24, internal ALB on 3001, two App Tier EC2 (Express :3001) in private subnets 10.0.11.0/24 and 10.0.12.0/24, Multi-AZ RDS MySQL primary with standby and read replica in private DB subnets 10.0.21.0/24 and 10.0.22.0/24](screenshots/a6-ss20.png)

**Permitted traffic flow:** Users → Internet Gateway → public ALB (HTTP 80) → Web Tier EC2 (Nginx 80 → Next.js 3000) → internal ALB (HTTP 3001) → App Tier EC2 (Express 3001) → RDS MySQL primary (3306). The primary replicates synchronously to its Multi-AZ standby and asynchronously to the read replica.

---

# Task 2 — AWS Region & Services Used

## Goal

Record the AWS Region used and list every AWS service used across networking, compute, load balancing, security, and the database.

### Notes

**Region:**

Asia Pacific (Malaysia) `ap-southeast-5`, Availability Zones `ap-southeast-5a` and `ap-southeast-5b`.

---

**Services:**

- **Networking:** Amazon VPC (`bookreview-vpc` 10.0.0.0/16), 6 subnets, Internet Gateway, 3 route tables (public, app-private, db-private), and a temporary NAT Gateway (deleted after the App Tier install, see Summary)
- **Compute:** Amazon EC2 (Ubuntu 24.04 LTS), 2 Web Tier and 2 App Tier instances with IMDSv2 required and encrypted gp3 volumes
- **Load balancing:** Elastic Load Balancing, 1 internet-facing Application Load Balancer and 1 internal Application Load Balancer, with 2 target groups and health checks
- **Security:** Security Groups (5, chained by group reference), AWS IAM (instance role `bookreview-app-role` and its instance profile), AWS Systems Manager Parameter Store (SecureString for the DB password and JWT secret), AWS KMS (default `aws/ssm` and `aws/rds` keys)
- **Database:** Amazon RDS for MySQL 8.4 (`bookreview-db`, Multi-AZ, encrypted, not public) plus a read replica (`bookreview-db-replica`), and a DB subnet group limited to the two DB subnets

---

# Task 3 — Public Entry Point

## Goal

Confirm the Book Review App loads through the public ALB DNS name.

### Evidence

#### Public ALB DNS

Paste your public ALB DNS name here:

`http://br-public-alb-1262272999.ap-southeast-5.elb.amazonaws.com`

Confirmed working: the home page returns 200 and lists the books from RDS. Register, login and review submission all work through this DNS name (see Task 4, App UI proof).

---

# Task 4 — Evidence Screenshots

## Goal

Capture visual proof of every tier and load balancer.

### Evidence

#### Web EC2

![br-web-a in public subnet br-web-public-a, auto-assigned public IPv4, Elastic IP addresses empty](screenshots/a6-ss7.png)

---

#### App EC2

![br-app-a in private subnet br-app-private-a with no public IPv4, IAM role bookreview-app-role](screenshots/a6-ss8.png)

---

#### Public ALB

![br-public-alb scheme Internet-facing across both Web subnets, listener HTTP:80 forwarding to br-web-tg](screenshots/a6-ss9.png)

![br-web-tg: 2 of 2 Web Tier targets healthy on port 80 in ap-southeast-5a and 5b](screenshots/a6-ss10.png)

---

#### Internal ALB

![br-internal-alb scheme Internal across both App subnets, listener HTTP:3001 forwarding to br-app-tg](screenshots/a6-ss11.png)

![br-app-tg: 2 of 2 App Tier targets healthy on port 3001](screenshots/a6-ss12.png)

---

#### RDS + Replica

![RDS databases: bookreview-db role Primary and bookreview-db-replica role Replica, both Available](screenshots/a6-ss13.png)

![bookreview-db configuration: Multi-AZ Yes, secondary zone ap-southeast-5a, MySQL 8.4.9, encrypted](screenshots/a6-ss13b.png)

![bookreview-db connectivity: br-db-subnet-group, br-db-sg, Publicly accessible No](screenshots/a6-ss14.png)

---

#### App UI proof

![Book Review App home page through the public ALB listing books from RDS](screenshots/a6-ss15.png)

![Clean Code book page with reviews loaded through the internal ALB and App Tier](screenshots/a6-ss16.png)

![Logged in as Javeson Francois Liu on the public ALB DNS URL with the Add a Review form](screenshots/a6-ss17.png)

---

#### Additional evidence

**Six subnets across two Availability Zones:**

![Six br- subnets with names and CIDRs](screenshots/a6-ss2.png)

![The same six subnets with their Availability Zones ap-southeast-5a and 5b](screenshots/a6-ss2b.png)

**VPC resource map after the temporary NAT was removed** (only the Internet Gateway remains):

![bookreview-vpc resource map: 6 subnets, 3 custom route tables, bookreview-igw only](screenshots/a6-ss1.png)

**App Tier route table has no internet route:**

![br-app-private-rt routes: only 10.0.0.0/16 local](screenshots/a6-ss3.png)

**Security group chain:**

![Five br- security groups in bookreview-vpc](screenshots/a6-ss4.png)

![br-app-sg inbound: 3001 from br-internal-alb-sg, 22 from br-web-sg](screenshots/a6-ss5.png)

![br-db-sg inbound: 3306 from br-app-sg only](screenshots/a6-ss6.png)

**Database connectivity tested from the private App Tier** (SSH through the Web Tier as a bastion; the password is read from the root-only env file and never printed):

![From br-app-a: primary read_only 0 with 3 books and 3 reviews; replica read_only 1 with 3 replicated reviews](screenshots/a6-ss18.png)

**No Elastic IPs in the final architecture:** the temporary NAT Elastic IP was released. The two addresses still listed are owned by the public ALB (`Service managed: alb`), not allocated by me.

![Elastic IP page: remaining addresses are Service managed alb](screenshots/a6-ss19.png)

---

# Task 5 — Summary

## Goal

Summarize what worked in the final deployment, the issues encountered and how each was fixed, and the tools or sources used to research and debug.

### Notes

**What worked:**

- **Networking:** a three-tier VPC in `ap-southeast-5`. The Web Tier is in 2 public subnets, and the App and DB tiers are in 4 private subnets, spread across 2 AZs. Each tier has its own route table, and only the Web route table has an internet route.
- **Security groups:** five groups chained along the request path: public ALB, web, internal ALB, app, DB. Each accepts traffic only from the group before it, so nothing can skip a tier.
- **Web Tier:** Next.js runs on 127.0.0.1:3000 behind Nginx on port 80. Nginx serves the pages and forwards `/api/` to the internal ALB, so the browser never talks to the App Tier directly.
- **App Tier:** Express runs on port 3001 under systemd as a non-root user. Both targets pass the internal ALB health check.
- **Database:**
  - RDS MySQL 8.4 is Multi-AZ, with the primary in 5b and the standby in 5a, plus a read replica in 5a.
  - It is encrypted, not public, and reachable only from the App Tier security group.
  - From the App Tier, the primary reports `read_only = 0` and the replica reports `read_only = 1`, and the replica holds the same review count.
- **End-to-end test through the public ALB DNS:** the book list, book details, registration, login and posting a review (a JWT-protected write) all worked.
- **Secrets:** the DB password and JWT secret are random values in SSM Parameter Store, read at boot by an IAM role limited to those two parameters. Neither is in code, user data or screenshots.

---

**Issues + fixes:**

1. **t3.micro had no capacity in ap-southeast-5a.** The launch script tries `t3.micro` first and falls back to `t3.small`. The 5a instances run on `t3.small`.
2. **The read replica failed with `InstanceQuotaExceeded`.** The account is on the AWS Free plan, which caps the number of RDS instances. I deleted the EpicBook database from Assignment 4 (already documented) to free a slot, then created the replica.
3. **The app pins Next.js 15.2.3, which has critical public advisories**, including unauthenticated remote code execution.
   - Because the Web Tier is internet-facing, I upgraded to the patched 15.5 line (15.5.26) with React 19.0.8 and ran `npm audit fix`.
   - I test-built locally before deploying.
   - One PostCSS advisory remains. It affects build-time CSS processing only, not request handling.
4. **The frontend builds API URLs two ways.** The home page calls `${NEXT_PUBLIC_API_URL}/api/books`, while the other pages call `${API_URL}/books`.
   - Fix: I set `NEXT_PUBLIC_API_URL=/api` so every browser call is same-origin under `/api/`.
   - An Nginx rewrite collapses `/api/api/` to `/api/`, then forwards to the internal ALB.
   - This avoids hard-coding any IP and avoids exposing the App Tier.
5. **Nginx caches DNS answers at startup, but internal ALB IPs change over time.** I used the VPC resolver (`10.0.0.2`) with a variable in `proxy_pass`, so Nginx re-resolves the internal ALB every 30 seconds.
6. **CORS.** The backend only accepts origins listed in `ALLOWED_ORIGINS`, so I set it to the public ALB origin. A request from a foreign origin is rejected.
7. **The private App Tier needs internet access for `apt` and `npm` installs, but the brief says no Elastic IPs.**
   - I used a temporary NAT Gateway during provisioning.
   - Once both App targets were healthy, I removed the default route, deleted the NAT and released its EIP.
   - The App and DB tiers now have no internet route at all.
8. **The repo ships a sample `backend/.env`.** I deleted it on the server, so settings come only from a root-only `/etc/bookreview/backend.env` loaded by systemd `EnvironmentFile`.
9. **Two App instances starting at once could both seed the empty database.** The second instance starts its API 120 seconds later, so the schema sync and sample seed run once (3 books, not 6).
10. **The brief says the App SG should accept port 3001 from the Web SG.** With an internal ALB in between, the App Tier's real source is the internal ALB. So `br-app-sg` allows 3001 only from `br-internal-alb-sg`, and `br-internal-alb-sg` allows 3001 only from `br-web-sg`. This matches the brief's own solution walkthrough.

---

**Tools/sources used:**

- **AWS documentation:**
  - Elastic Load Balancing: internal vs internet-facing load balancers, target group health checks
  - RDS: Multi-AZ deployments, read replicas
  - VPC: route tables, NAT Gateways, security group referencing
  - SSM Parameter Store SecureString
  - EC2 IMDSv2
- **Next.js and npm security advisories** (via `npm audit`) to choose the patched Next.js line
- **Nginx docs** for `resolver` and `proxy_pass` with variables and `rewrite ... break`
- **AWS CLI** for building and checking the infrastructure: `describe-target-health`, `describe-db-instances`, `describe-addresses`
- **curl** end-to-end tests of every API route through the public ALB
- **The MySQL client** on the App Tier to verify the primary and the replica
- **Claude Code** (AI pair) for scripting, debugging and review; every change was verified live
- **Book Review App source:** github.com/pravinmishraaws/book-review-app

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post sharing the capstone deployment, including the public ALB DNS (or a redacted screenshot), three to five lines on what you built and why it is production-style, and one proof screenshot.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/javeson-francois-liu-999135437_dmibypravinmishra-aws-threetierarchitecture-share-7508938526034653184-m4Es`

---

#### Screenshot of LinkedIn post

![Published LinkedIn post: Week 6 Capstone, production-grade three-tier application on AWS with the public ALB endpoint](screenshots/a6-linkedin-ss1.png)

---

# Submission Instructions

- Add all required screenshots and links in your submission
- Do not expose passwords, RDS credentials, connection strings, private keys, or account IDs

---

# Completion Checklist

- [x] Task 1: Architecture diagram completed
- [x] Task 2: AWS Region and services documented
- [x] Task 3: Public ALB DNS confirmed working
- [x] Task 4: All six evidence screenshots captured (Web Tier, App Tier, both ALBs, RDS + replica, app UI)
- [x] Task 5: Deployment summary completed (what worked, issues/fixes, tools/sources)
- [x] LinkedIn post published and URL submitted
- [x] App Tier and Database Tier confirmed not publicly accessible
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