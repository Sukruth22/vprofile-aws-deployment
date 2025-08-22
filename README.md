Vprofile on AWS (Lift & Shift)

A hands-on project to migrate the Vprofile multi-tier Java web app from on-prem Linux VMs to AWS managed services using EC2, RDS, S3, and CloudWatch.

This repo is part of a progressive DevOps portfolio (Linux → AWS → CI/CD → Ansible → Kubernetes → GitOps).

Objectives

✅ Provision a secure Linux server on EC2 and deploy the Vprofile app (Tomcat + Apache).

✅ Externalize database to Amazon RDS (MySQL).

✅ Store artifacts/logs in Amazon S3.

✅ Add basic monitoring/alarms with CloudWatch.

✅ Document commands, architecture, and cleanup to keep costs low.

Tech Stack

AWS: EC2, RDS (MySQL), S3, IAM, VPC, Security Groups, CloudWatch

Linux: Ubuntu Server 22.04 LTS

App: Java (OpenJDK 8), Tomcat 9, Apache HTTPD, MySQL client

CI/CD (later): Jenkins / GitHub Actions

Architecture
User → Route53 (optional) → SG (ALB/EC2) → EC2 (Apache + Tomcat + App) → RDS (MySQL)
                                   ↘ S3 (artifacts/logs)
                                   ↘ CloudWatch (metrics/alarms)


📌 Diagram: assets/architecture.png

Prerequisites

AWS Account (free tier eligible)

IAM user with programmatic access (AdministratorAccess for learning, or least-privilege in real setups)

SSH key pair

Basic familiarity with Linux CLI & security groups

Setup (Step-by-Step)
1. Launch EC2

Ubuntu 22.04 LTS, t2.micro (free tier)

Inbound rules: 22 (SSH), 80 (HTTP), 8080 (Tomcat)

Attach IAM role if S3/CloudWatch integration is needed

2. Install Java + Tomcat (manual install)
sudo apt update && sudo apt -y upgrade
sudo apt -y install openjdk-8-jdk mysql-client unzip

# Install Tomcat manually
cd /opt
sudo wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.tar.gz
sudo tar -xvzf apache-tomcat-9.0.96.tar.gz
sudo mv apache-tomcat-9.0.96 tomcat
sudo chmod +x /opt/tomcat/bin/*.sh

3. Configure Tomcat env (setenv.sh)

/opt/tomcat/bin/setenv.sh

export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
export DB_HOST="<db-endpoint>"
export DB_PORT="3306"
export DB_NAME="vprofile"
export DB_USER="vprofile_app"
export DB_PASS="StrongPass#123"


Start Tomcat:

/opt/tomcat/bin/startup.sh

4. Deploy WAR
sudo cp vprofile.war /opt/tomcat/webapps/
# or rename to ROOT.war for direct context

5. Connect to DB

Local MySQL (initial setup) OR

Amazon RDS (production-like)

Test:

mysql -h <db-endpoint> -u <user> -p -e "SHOW DATABASES;"

6. Verify

App → http://<EC2-PUBLIC-IP>:8080/vprofile/

Logs → /opt/tomcat/logs/catalina.out

Security Notes

Restrict SSH (22) to your IP only

DB (3306) only accessible from EC2 security group

Don’t commit secrets — use scripts/setenv.sh.example

Use IAM roles for EC2 → S3/CloudWatch access

Repo Structure
.
├── README.md
├── LICENSE
├── .gitignore
├── assets/
│   └── architecture.png
├── notes/
│   ├── commands.md          # All AWS/EC2/Tomcat/MySQL commands
│   ├── troubleshooting.md   # Fixes (Java8, Tomcat, setenv.sh)
│   └── screenshots/
├── scripts/
│   ├── setenv.sh.example    # Example env vars
│   ├── tomcat.service       # Systemd unit file
│   └── nginx-tomcat.conf    # Optional reverse proxy
└── terraform/               # IaC (future)

Screenshots (to add)

✅ EC2 instance details (public DNS, SG rules)

✅ Tomcat home & /vprofile page

✅ MySQL SHOW TABLES

✅ RDS DB details (endpoint, SG rules)

✅ CloudWatch alarms

✅ S3 bucket (if enabled)

Cleanup

Terminate EC2

Delete RDS + snapshots

Empty & delete S3

Remove CloudWatch alarms / SNS topics

Learning Outcomes

Hands-on lift-and-shift migration (VM → AWS)

Tomcat + Java app hosting on cloud Linux

Externalizing state to managed RDS

Basic monitoring & security hygiene

Foundation for CI/CD, Ansible, Kubernetes, GitOps

✅ Next step in portfolio: Automate with Jenkins CI/CD (build WAR → deploy to Tomcat on EC2).

Do you want me to also tighten this down to a 1-page PDF version with diagrams & screenshots (like a recruiter handout), or just keep the repo README format?

You said:
yes keep github repo readme format. gimme the full stuff
ChatGPT said:

Got it 👍 — here’s the final full README.md in GitHub-friendly format. You can just copy-paste this into your repo.

# Vprofile on AWS (Lift & Shift)

A hands-on project to migrate the **Vprofile multi-tier Java web app** from on-prem Linux VMs to **AWS managed services** using EC2, RDS, S3, and CloudWatch.  

This repo is part of a progressive DevOps portfolio (**Linux → AWS → CI/CD → Ansible → Kubernetes → GitOps**).

---

## Objectives
- ✅ Provision a secure Linux server on **EC2** and deploy the Vprofile app (**Tomcat + Apache**).  
- ✅ Externalize database to **Amazon RDS (MySQL)**.  
- ✅ Store artifacts/logs in **Amazon S3**.  
- ✅ Add basic monitoring/alarms with **CloudWatch**.  
- ✅ Document commands, architecture, and cleanup to keep costs low.  

---

## Tech Stack
- **AWS**: EC2, RDS (MySQL), S3, IAM, VPC, Security Groups, CloudWatch  
- **Linux**: Ubuntu Server 22.04 LTS  
- **App**: Java (OpenJDK 8), Tomcat 9, Apache HTTPD, MySQL client  
- **CI/CD (later)**: Jenkins / GitHub Actions  

---

## Architecture


User → Route53 (optional) → SG (ALB/EC2) → EC2 (Apache + Tomcat + App) → RDS (MySQL)
↘ S3 (artifacts/logs)
↘ CloudWatch (metrics/alarms)


📌 Diagram: [`assets/architecture.png`](assets/architecture.png)

---

## Prerequisites
- AWS Account (free tier eligible)  
- IAM user with programmatic access (**AdministratorAccess for learning**, or least-privilege in real setups)  
- SSH key pair  
- Basic familiarity with Linux CLI & security groups  

---

## Setup (Step-by-Step)

### 1. Launch EC2
- Ubuntu 22.04 LTS, `t2.micro` (free tier)  
- Inbound rules: `22 (SSH)`, `80 (HTTP)`, `8080 (Tomcat)`  
- Attach IAM role if S3/CloudWatch integration is needed  

### 2. Install Java + Tomcat (manual install)
```bash
sudo apt update && sudo apt -y upgrade
sudo apt -y install openjdk-8-jdk mysql-client unzip

# Install Tomcat manually
cd /opt
sudo wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.tar.gz
sudo tar -xvzf apache-tomcat-9.0.96.tar.gz
sudo mv apache-tomcat-9.0.96 tomcat
sudo chmod +x /opt/tomcat/bin/*.sh

3. Configure Tomcat env (setenv.sh)

Create /opt/tomcat/bin/setenv.sh:

export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
export DB_HOST="<db-endpoint>"
export DB_PORT="3306"
export DB_NAME="vprofile"
export DB_USER="vprofile_app"
export DB_PASS="StrongPass#123"


Start Tomcat:

/opt/tomcat/bin/startup.sh

4. Deploy WAR
sudo cp vprofile.war /opt/tomcat/webapps/
# or rename to ROOT.war for direct context

5. Connect to DB

Local MySQL (initial setup) OR

Amazon RDS (production-like)

Test:

mysql -h <db-endpoint> -u <user> -p -e "SHOW DATABASES;"

6. Verify

App → http://<EC2-PUBLIC-IP>:8080/vprofile/

Logs → /opt/tomcat/logs/catalina.out

Security Notes

Restrict SSH (22) to your IP only

DB (3306) only accessible from EC2 security group

Don’t commit secrets — use scripts/setenv.sh.example

Use IAM roles for EC2 → S3/CloudWatch access

Repo Structure
.
├── README.md
├── LICENSE
├── .gitignore
├── assets/
│   └── architecture.png
├── notes/
│   ├── commands.md          # All AWS/EC2/Tomcat/MySQL commands
│   ├── troubleshooting.md   # Fixes (Java8, Tomcat, setenv.sh)
│   └── screenshots/
├── scripts/
│   ├── setenv.sh.example    # Example env vars
│   ├── tomcat.service       # Systemd unit file
│   └── nginx-tomcat.conf    # Optional reverse proxy
└── terraform/               # IaC (future)

Screenshots (to add)

✅ EC2 instance details (public DNS, SG rules)

✅ Tomcat home & /vprofile page

✅ MySQL SHOW TABLES

✅ RDS DB details (endpoint, SG rules)

✅ CloudWatch alarms

✅ S3 bucket (if enabled)

Cleanup

Terminate EC2

Delete RDS + snapshots

Empty & delete S3

Remove CloudWatch alarms / SNS topics

Learning Outcomes

Hands-on lift-and-shift migration (VM → AWS)

Tomcat + Java app hosting on cloud Linux

Externalizing state to managed RDS

Basic monitoring & security hygiene

Foundation for CI/CD, Ansible, Kubernetes, GitOps
