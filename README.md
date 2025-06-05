# Terraform AWS Multi-Environment Web Application Infrastructure

This project provisions a scalable and secure infrastructure for a web application on AWS using Terraform. It supports multiple isolated environments — **development**, **staging**, and **production** — with reusable Terraform modules and GitHub Actions CI/CD pipelines for automation.

---

## 📌 Project Objectives

- Use **Terraform** to manage AWS infrastructure as code (IaC)
- Isolate infrastructure per environment (dev, staging, prod)
- Create reusable and modular Terraform components
- Store remote state securely in **S3**, with state locking using **DynamoDB**
- Automate validation and deployment using **GitHub Actions**

---

## 🧱 Architecture Overview

### Core AWS Components

- **VPC**, Subnets, Route Tables, IGW, NAT Gateway
- **EC2** for compute resources
- **Application Load Balancer (ALB)** for routing
- **DynamoDb** for database
- **S3** for state and static files
- **IAM** roles and policies
- **Secrets Manager** for sensitive data

---

