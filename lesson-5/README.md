# lesson-5 — AWS Infrastructure with Terraform

This project provisions an AWS infrastructure using **Terraform**, including:  
 S3 & DynamoDB backend for state management  
 VPC with public & private subnets  
 ECR repository for Docker images  

---

##  Project Structure

lesson-5/
│
├── main.tf # Main file to include all modules
├── backend.tf # Remote backend configuration (S3 + DynamoDB)
├── outputs.tf # Outputs from all modules
│
├── modules/
│ │
│ ├── s3-backend/ # Backend module
│ │ ├── s3.tf
│ │ ├── dynamodb.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ │
│ ├── vpc/ # VPC module
│ │ ├── vpc.tf
│ │ ├── routes.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ │
│ └── ecr/ # ECR module
│ ├── ecr.tf
│ ├── variables.tf
│ └── outputs.tf



---

## 📦 Modules

### 1 S3 + DynamoDB (`modules/s3-backend`)
- Creates an **S3 bucket** to store the `terraform.tfstate`.
- Enables **versioning** on the bucket.
- Creates a **DynamoDB table** to handle state locking.
- Outputs:
  - S3 bucket name.
  - DynamoDB table name.

---

### 2 VPC (`modules/vpc`)
- Creates a **VPC** with a specified CIDR block.
- Creates **3 public** and **3 private subnets**.
- Creates an **Internet Gateway** for public subnets.
- Creates a **NAT Gateway** for private subnets.
- Configures route tables:
  - Public subnets → IGW.
  - Private subnets → NAT Gateway.
- Outputs:
  - VPC ID.
  - Subnet IDs.
  - IGW & NAT IDs.

---

### 3 ECR (`modules/ecr`)
- Creates an **ECR repository**.
- Enables **image scanning on push**.
- Sets an **access policy** for the repository.
- Outputs:
  - ECR repository URL.

---

##  Getting Started

###  Prerequisites
- [AWS CLI](https://aws.amazon.com/cli/) — configured with credentials and default region.
- [Terraform](https://developer.hashicorp.com/terraform/install) — installed locally.

---

###  Steps

## Navigate to the project directory:
bash
cd lesson-5

## Initialize Terraform
terraform init

## Review the plan
terraform plan

## Apply the changes

terraform apply


## To destroy all resources
terraform destroy