Simple Fullstack Application – Terraform Infrastructure

#Overview

This directory contains Terraform Infrastructure as Code (IaC) to deploy a production-ready backend application on AWS using ECS Fargate, backed by RDS PostgreSQL, and exposed to the public internet via an Application Load Balancer (ALB).

Architecture Summary
High-level architecture:

VPC with public and private subnets across multiple AZs
Internet Gateway for public subnets
NAT Gateway for outbound internet access from private subnets
Application Load Balancer (ALB) in public subnets
ECS Fargate service running backend containers in private subnets
RDS PostgreSQL (Multi-AZ) in private subnets
AWS Secrets Manager for database credentials
CloudWatch Logs for ECS container logging

Traffic flow:
Internet
   ↓
Application Load Balancer (Public Subnet)
   ↓
ECS Fargate Service (Private Subnet)
   ↓
RDS PostgreSQL (Private Subnet)

Terraform File Breakdown
```
| File                | Purpose                                           |
| ------------------- | ------------------------------------------------- |
| `vpc.tf`            | Creates the VPC                                   |
| `subnets.tf`        | Public and private subnets                        |
| `igw.tf`            | Internet Gateway                                  |
| `natgw.tf`          | NAT Gateway for private subnets                   |
| `route_table.tf`    | Routing configuration                             |
| `security_group.tf` | Security groups for ALB, ECS, and RDS             |
| `alb.tf`            | Application Load Balancer, listener, target group |
| `ecs_cluster.tf`    | ECS cluster and IAM roles                         |
| `ecs_TD.tf`         | ECS Task Definition (Fargate)                     |
| `ecs_service.tf`    | ECS Service with ALB integration                  |
| `rds.tf`            | RDS PostgreSQL (Multi-AZ, private)                |
| `secrets.tf`        | AWS Secrets Manager secrets                       |
| `variables.tf`      | Input variables                                   |
| `terraform.tfvars`  | Variable values                                   |
| `main.tf`           | Provider configuration                            |
```

Application Details:
Backend Application
Runs inside ECS Fargate

Exposes:
GET /healthcheck
GET /message

<img width="1917" height="264" alt="image" src="https://github.com/user-attachments/assets/29dd7fa6-0bf9-41bc-aaa5-b7b725bcf0ac" />


Prerequisites-
Before running Terraform, ensure you have:

AWS account
IAM user/role with permissions for:
VPC, ECS, ALB, RDS, IAM, Secrets Manager

AWS CLI configured:
aws configure

Terraform installed:
terraform --version

Docker image for backend already built and pushed to ECR
<img width="1873" height="366" alt="image" src="https://github.com/user-attachments/assets/d860a925-a938-4040-a118-7c54d33409f3" />


How to Deploy

1️⃣ Initialize Terraform
terraform init

2️⃣ Review the Plan
terraform plan

3️⃣ Apply Infrastructure
terraform apply
Confirm with yes.

4️⃣ Verify Deployment

Get ALB DNS name:
aws elbv2 describe-load-balancers

Test backend health:
curl http://<ALB_DNS_NAME>/healthcheck


Expected response:
{"status":"ok","db":"connected"}


Cost Optimization Considerations

Fargate avoids EC2 instance management
Small instance sizes for RDS (can scale later)
CloudWatch log retention limited to reduce costs
NAT Gateway used only for private subnet outbound access

Monitoring & Logging
ECS container logs → CloudWatch Logs

ALB health checks monitor backend health
ECS service restarts unhealthy tasks automatically

Assumptions
Docker image is already available in ECR
AWS region is predefined in terraform.tfvars
No custom domain (ALB DNS used directly)
HTTPS can be enabled later using ACM

Trade-offs
```
Decision	            Trade-off
ECS Fargate          	Higher cost than EC2, less ops overhead
ALB only	            No CloudFront (simpler, lower cost)
Secrets Manager      	Slight cost, strong security
No Terraform modules	Simpler for assessment clarity
```

How to Destroy Infrastructure
terraform destroy

⚠️ This will delete all resources, including RDS.
```
terraform destroy
```
