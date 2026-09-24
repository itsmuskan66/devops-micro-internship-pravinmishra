# Assignment 4 — Deploy EpicBook on Ubuntu VM + MySQL RDS with Secure Cloud Network

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will deploy the EpicBook web application in AWS using a secure two-tier architecture: an Ubuntu EC2 instance with Nginx in a public subnet, and a private MySQL RDS database with restricted security-group access. The completed deployment must prove that the frontend, backend, and private database communicate successfully end to end.

---

# Task 1 — Create VPC + Public/Private Subnets + Routing

## Goal

Create `epicbook-vpc` (10.0.0.0/16) with a public subnet (10.0.1.0/24) and a private subnet (10.0.2.0/24), attach an Internet Gateway, and route only the public subnet to it.

### Evidence

#### Screenshot 1 — VPC details showing CIDR 10.0.0.0/16

![VPC epicbook-vpc details with IPv4 CIDR 10.0.0.0/16 and resource map](screenshots/a4-ss1.png)

---

#### Screenshot 2 — Subnets list showing both subnets and their CIDRs

![Subnets list with epicbook public 10.0.1.0/24 and private 10.0.2.0/24, 10.0.3.0/24](screenshots/a4-ss2.png)

---

#### Screenshot 3 — Route table showing 0.0.0.0/0 → IGW and association with the public subnet

![epicbook-public-rt routes 0.0.0.0/0 to IGW, associated with epicbook-public-subnet](screenshots/a4-ss3.png)

---

# Task 2 — Create Security Groups (EC2 + RDS) with Least Privilege

## Goal

Create `epicbook-ec2-sg` (SSH from your IP, HTTP/HTTPS public) and `epicbook-rds-sg` (MySQL 3306 only from `epicbook-ec2-sg`).

### Evidence

#### Screenshot 4 — EC2 security-group inbound rules showing ports and sources

![epicbook-ec2-sg inbound rules: SSH 22 from my IP, HTTP 80 and HTTPS 443](screenshots/a4-ss4.png)

---

#### Screenshot 5 — RDS security-group inbound rule showing MySQL 3306 allowed from the EC2 security group

![epicbook-rds-sg inbound rule: MySQL 3306 from epicbook-ec2-sg](screenshots/a4-ss5.png)

---

# Task 3 — Launch Ubuntu EC2 in Public Subnet

## Goal

Launch an Ubuntu 20.04 instance in the public subnet with `epicbook-ec2-sg` attached, and connect to it over SSH.

### Evidence

#### Screenshot 6 — EC2 instance summary showing the public IPv4 address, subnet, and security group

![epicbook-ec2 instance summary with public IPv4, public subnet and VPC](screenshots/a4-ss6.png)

![epicbook-ec2 Security tab showing epicbook-ec2-sg attached with its inbound rules](screenshots/a4-ss6b.png)

---

#### Screenshot 7 — Terminal showing a successful SSH login with the `ubuntu@...` prompt

![Successful SSH login to epicbook-ec2 showing ubuntu@ip-10-0-1-208 prompt](screenshots/a4-ss7.png)

---

# Task 4 — Install Required Software on EC2

## Goal

Install Node.js, npm, Nginx, and the MySQL client on the instance, and confirm Nginx is running.

### Evidence

#### Screenshot 8 — Output of `node -v` and `npm -v`

![node -v v22.23.3 and npm -v 10.9.9](screenshots/a4-ss8.png)

---

#### Screenshot 9 — Output of `systemctl status nginx`

![systemctl status nginx active (running)](screenshots/a4-ss9.png)

---

#### Screenshot 10 — Output of `mysql --version`

![mysql --version 8.0.42 client](screenshots/a4-ss10.png)

---

# Task 5 — Create RDS MySQL in Private Subnet (No Public Access)

## Goal

Create a private MySQL RDS instance in `epicbook-vpc` using a DB Subnet Group over the private subnet, with `epicbook-rds-sg` attached and public access disabled.

### Evidence

#### Screenshot 11 — RDS instance summary showing Publicly accessible: No

![epicbook-db endpoint view: Publicly accessible No, epicbook-vpc, epicbook-db-subnet-group, epicbook-rds-sg](screenshots/a4-ss11.png)

---

#### Screenshot 12 — Connectivity & security section showing the VPC and attached security group

![epicbook-db security group rules: epicbook-rds-sg inbound from epicbook-ec2-sg](screenshots/a4-ss12.png)

---

# Task 6 — Initialize Database (SQL Dump Import)

## Goal

Connect to RDS from EC2, create the `epicbook` database, and import the provided SQL dump.

### Evidence

#### Screenshot 13 — Terminal showing successful `SHOW TABLES;` output with tables listed

![SQL dump imported into private RDS; SHOW TABLES lists Author, Book, Cart](screenshots/a4-ss13.png)

---

# Task 7 — Deploy EpicBook Backend and Configure Environment Variables

## Goal

Clone the EpicBook repository, install backend dependencies, configure `.env` with the RDS endpoint and credentials, and start the backend on port 3000.

### Evidence

#### Screenshot 14 — Terminal showing the repository cloned and the `ls` output

![theepicbook cloned on epicbook-ec2 with ls output](screenshots/a4-ss14.png)

---

#### Screenshot 15 — Terminal showing the backend running, or `ss -tulpn` showing the port open

![epicbook systemd service active (running), node listening on port 3000](screenshots/a4-ss15.png)

---

#### Screenshot 16 — `curl` output proving the backend responds; a 200, 301, or 404 response is acceptable if the service responds

![curl -I http://localhost:3000 returns HTTP/1.1 200 OK from Express](screenshots/a4-ss16.png)

---

# Task 8 — Serve Frontend Using Nginx + Reverse Proxy to Backend

## Goal

Copy the frontend files to the Nginx web root and configure Nginx to reverse-proxy `/api/` to the Node backend.

### Evidence

#### Screenshot 17 — `nginx -t` success output

![sudo nginx -t syntax is ok and test is successful](screenshots/a4-ss17.png)

---

#### Screenshot 18 — Nginx configuration snippet showing the `/api/` reverse proxy

![Nginx epicbook site config with /api/ reverse proxy to 127.0.0.1:3000](screenshots/a4-ss18.png)

---

# Task 9 — End-to-End Testing (Frontend ↔ Backend ↔ RDS)

## Goal

Verify the frontend loads publicly, the backend responds through Nginx, and EC2 can query the private RDS database.

### Evidence

#### Screenshot 19 — Browser showing the EpicBook application loaded with the public IP visible

![EpicBook home page in Chrome with 56.68.45.182 in the address bar, books loaded from RDS](screenshots/a4-ss19.png)

---

#### Screenshot 20 — Terminal showing a successful API call through the public endpoint, such as `curl http://<EC2_PUBLIC_IP>/api/...`

![curl -i http://56.68.45.182/api/cart through Nginx returns 200 JSON from Express](screenshots/a4-ss20.png)

---

#### Screenshot 21 — Terminal showing the successful database connectivity test using `SELECT 1;` or similar

![SELECT 1 and book count 54 from private RDS, run on epicbook-ec2](screenshots/a4-ss21.png)

---

# Deployment Notes

**Live URL:** http://56.68.45.182 (region `ap-southeast-5`, Asia Pacific Malaysia)

| Layer | Resource | Detail |
|---|---|---|
| Network | `epicbook-vpc` | `10.0.0.0/16`, DNS hostnames enabled |
| Public subnet | `epicbook-public-subnet` | `10.0.1.0/24` (5a), auto-assign public IPv4, `epicbook-public-rt`: `0.0.0.0/0 → epicbook-igw` |
| Private subnets | `epicbook-private-subnet`, `epicbook-private-subnet-2` | `10.0.2.0/24` (5a), `10.0.3.0/24` (5b), `epicbook-private-rt`: local route only |
| Compute | `epicbook-ec2` | Ubuntu 20.04 LTS, `t4g.micro`, IMDSv2 required, IAM role `epicbook-ec2-role` |
| Database | `epicbook-db` | RDS MySQL 8.4.9, `db.t4g.micro`, encrypted gp3, Publicly accessible: No, `epicbook-db-subnet-group` |
| Firewall | `epicbook-ec2-sg` | 22 from my IP `/32`, 80 and 443 from `0.0.0.0/0` |
| Firewall | `epicbook-rds-sg` | 3306 only from `epicbook-ec2-sg` (security-group reference, no CIDR) |

## Request Path

Browser → `:80` Nginx on EC2 → static files from `/var/www/html` (copied from `public/`) or proxy to Node on `127.0.0.1:3000` → Sequelize → RDS MySQL `:3306` in the private subnets. Port 3000 is not open in the security group, so Nginx is the only public entry point.

## Decisions and Deviations from the Brief

- **Second private subnet (`10.0.3.0/24`, AZ 5b):** an RDS DB subnet group must cover at least two Availability Zones, so one private subnet alone is rejected. It also has no Internet Gateway route.
- **MySQL 8.4 instead of 8.0:** RDS MySQL 8.0 left standard support on 31 Jul 2026, so a new 8.0 instance would bill RDS Extended Support. 8.4 is the current LTS.
- **Database name `bookstore`:** the repository SQL files hard-code `USE bookstore;` and `bookstore.`-qualified table names, and the brief allows "the database name required by the repository".
- **Node.js 22 LTS from NodeSource:** Ubuntu 20.04 apt ships Node 10 / npm 6, which cannot read the repo's `package-lock.json` (lockfileVersion 3 needs npm 7+).
- **`t4g.micro` (Graviton, arm64):** `t3.micro` had no capacity in `ap-southeast-5a` at launch time (`InsufficientInstanceCapacity`). The same Ubuntu 20.04 release was used in its arm64 build.
- **Environment variables:** the app reads `JAWSDB_URL` when `NODE_ENV=production` and defaults to port 8080, so it ignores `DB_HOST`/`DB_USER`. `.env` holds `NODE_ENV`, `PORT=3000`, `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_NAME` and the Parameter Store name, and the start script builds `JAWSDB_URL` at launch.
- **Nginx config:** EpicBook is server-rendered (Express + Handlebars), so there is no `index.html`. `location /` serves static files and falls back to Node, and `/api/` uses `proxy_pass` **without** a trailing slash so `/api/cart` is not rewritten to `/cart`.
- **Backend as a systemd service (`epicbook.service`):** survives logout and reboots, `Restart=on-failure`.

## Secret Handling

- The RDS master password lives only in SSM Parameter Store as a SecureString (`/epicbook/db/master-password`, `aws/ssm` KMS key).
- `epicbook-ec2-role` allows `ssm:GetParameter` on that one parameter ARN only, plus `kms:Decrypt` via the SSM service.
- The password is never written to disk: `.env` has no secrets, the start script fetches it into memory at launch, and the MySQL client reads it through `MYSQL_PWD` in the session.
- `.env` is `chmod 600` and listed in `.git/info/exclude` (the repo's `.gitignore` does not cover it).

## Known Limitation

- `npm install` reports 45 advisories from the course repository's pinned dependencies (Sequelize 6.3, express-handlebars 5). `npm audit fix --force` was not run because it pulls breaking major versions.

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not expose PEM contents, passwords, `.env` values, or other secrets

---

# Completion Checklist

- [x] Task 1: VPC, public/private subnets, IGW, and public routing created (Screenshots 1–3)
- [x] Task 2: Least-privilege EC2 and RDS security groups created (Screenshots 4–5)
- [x] Task 3: Ubuntu EC2 launched in the public subnet with SSH verified (Screenshots 6–7)
- [x] Task 4: Node.js, npm, Nginx, and MySQL client installed (Screenshots 8–10)
- [x] Task 5: Private MySQL RDS created with no public access (Screenshots 11–12)
- [x] Task 6: Database initialized from the SQL dump (Screenshot 13)
- [x] Task 7: Backend deployed and responding on port 3000 (Screenshots 14–16)
- [x] Task 8: Nginx serving the frontend and reverse-proxying to the backend (Screenshots 17–18)
- [x] Task 9: Frontend, backend, and RDS verified end to end (Screenshots 19–21)
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