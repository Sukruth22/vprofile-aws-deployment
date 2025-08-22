# Vprofile on AWS (Lift & Shift)

A hands‑on project to migrate the **Vprofile** multi‑tier Java web app from Linux VMs to **AWS managed services** using **EC2, RDS, S3, and CloudWatch**. This repo is part of a progressive DevOps portfolio (Linux → AWS → CI/CD → Ansible → Kubernetes → GitOps).

## Objectives
- Provision a secure Linux server on **EC2** and deploy the Vprofile app (Tomcat + Apache).
- Externalize database to **Amazon RDS (MySQL)**.
- Store artifacts/logs in **Amazon S3**.
- Add basic monitoring/alarms with **CloudWatch**.
- Document commands, architecture, and cleanup to keep costs low.

## Tech Stack
**AWS:** EC2, RDS (MySQL), S3, IAM, VPC, Security Groups, CloudWatch  
**Linux:** Ubuntu Server 22.04 LTS  
**App:** Java, Tomcat, Apache HTTPD, MySQL client  
**CI (later):** Jenkins/GitHub Actions (placeholder)

## Architecture
```
User → Route53 (optional) → SG(ALB/EC2) → EC2 (Apache + Tomcat) → RDS (MySQL)
                               ↘ S3 (artifacts/logs)
                               ↘ CloudWatch (metrics/alarms)
```
> Add a diagram: `/assets/architecture.png` (draw.io / Excalidraw)

## Prerequisites
- AWS Account (free tier eligible)
- IAM user with programmatic access (AdministratorAccess for learning, or least-privilege in real setups)
- SSH key pair
- Basic familiarity with Linux CLI and security groups

## Quick Start (High Level)
1. **Create EC2** (Ubuntu 22.04, t2.micro/t3.micro), open inbound: 22, 80, 8080 (optional), and allow EC2 → RDS.
2. **Create RDS MySQL** (free tier), obtain endpoint/port/user/pass.
3. **Install app stack** on EC2: Apache, Tomcat, Java, MySQL client. Deploy WAR.
4. **Connect app to RDS** (update datasource properties / env vars).
5. **S3 bucket** for artifacts/logs (optional but recommended).
6. **CloudWatch** basic alarms on CPU + status checks.
7. **Verify** app works via public DNS/IP. Take screenshots.

## Security Notes
- Use least‑privilege IAM roles (EC2 instance profile for S3 if used).
- Restrict SG to your IP for SSH (22). Keep DB (3306) private, only allow from EC2 SG.
- Don’t commit secrets; use `notes/.env.example` to document variables.

## Setup – Commands (save what you run in `notes/commands.md`)
### EC2 Bootstrap (Ubuntu 22.04)
```bash
sudo apt update && sudo apt -y upgrade
sudo apt -y install openjdk-11-jdk tomcat9 tomcat9-admin apache2 mysql-client unzip
sudo systemctl enable --now tomcat9 apache2
```

### Deploy App (example)
```bash
sudo cp vprofile.war /var/lib/tomcat9/webapps/
```

### Connect to RDS
Add to your app config:
```
DB_HOST=<rds-endpoint>
DB_PORT=3306
DB_USER=<user>
DB_PASS=<pass>
```
Test:
```bash
mysql -h <rds-endpoint> -u <user> -p -e "SHOW DATABASES;"
```

## Repo Structure
```
.
├── README.md
├── LICENSE
├── .gitignore
├── assets/
│   └── architecture.png (placeholder)
├── notes/
│   ├── commands.md
│   └── screenshots/
├── scripts/
│   └── install.sh (optional bootstrap)
└── terraform/ (later day)
```

## Screenshots (to add)
- EC2 instance details (public DNS, SG)
- RDS DB details (endpoint, SG rules)
- S3 bucket
- CloudWatch alarms
- App home page in browser

## Cleanup
- Terminate EC2
- Delete RDS + snapshots
- Empty & delete S3
- Remove CloudWatch alarms, SNS topics

## Learning Outcomes
- Linux server management on cloud
- Lift‑and‑shift patterns vs managed services
- Basic AWS monitoring & security hygiene
- Foundation for CI/CD, Ansible, Kubernetes, GitOps
