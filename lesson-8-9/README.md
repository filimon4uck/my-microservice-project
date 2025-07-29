# lesson-8-9 — AWS Infrastructure with Terraform

This project provisions an AWS infrastructure using **Terraform**, including:  
 S3 & DynamoDB backend for state management  
 VPC with public & private subnets  
 ECR repository for Docker images
 EKS Kubernetes cluster  
 Jenkins
 Argo_cd

---

##  Project Structure

```
lesson-8-9/
├── main.tf                 # Main entry point for Terraform modules
├── backend.tf              # S3 + DynamoDB backend config
├── outputs.tf              # General resource outputs
├── modules/
│   ├── s3-backend/
│   │   ├── s3.tf
│   │   ├── dynamodb.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── vpc/
│   │   ├── vpc.tf
│   │   ├── routes.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ecr/
│   │   ├── ecr.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── eks/
│   │   ├── eks.tf
│   │   ├── aws_ebs_csi_driver.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── jenkins/
│   │   ├── jenkins.tf
│   │   ├── variables.tf
│   │   ├── providers.tf
│   │   ├── values.yaml
│   │   └── outputs.tf
│   └── argo_cd/
│       ├── argo.tf
│       ├── variables.tf
│       ├── providers.tf
│       ├── values.yaml
│       ├── outputs.tf
│       └── charts/
│           ├── Chart.yaml
│           ├── values.yaml
│           └── templates/
│               ├── application.yaml
│               └── repository.yaml
│           └── charts/
│               └── django-app/
│                   ├── Chart.yaml
│                   ├── values.yaml
│                   └── templates/
│                       ├── deployment.yaml
│                       ├── service.yaml
│                       ├── configmap.yaml
│                       ├── hpa.yaml
│                       ├── postgres-deployment.yaml
│                       ├── postgres-service.yaml
│                       └── postgress-pvc.yaml
```

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

### 4. EKS (modules/eks)
- Creates an EKS cluster.
- Installs the EBS CSI driver.
- **Outputs**: kubeconfig, endpoint, cluster name.

### 5. `jenkins`
- Installs Jenkins via Helm.
- Configures Kubernetes agents (Kaniko, Git).
- Jenkins pipeline:
  - Builds Docker image from Dockerfile
  - Pushes image to ECR
  - Updates image tag in another repo’s `values.yaml`
  - Commits & pushes changes to `main`
---
### 6. `argo_cd`
- Installs Argo CD via Helm.
- Helm chart includes:
  - `Application` resource
  - `Repository` config
- Argo CD auto-syncs Kubernetes state based on Git updates.


##  Getting Started

###  Prerequisites
- [AWS CLI](https://aws.amazon.com/cli/) — configured with credentials and default region.
- [Terraform](https://developer.hashicorp.com/terraform/install) — installed locally.
- kubectl — for Kubernetes cluster management.
- Helm — package manager for Kubernetes.
---

###  Steps

## Navigate to the project directory:
bash
cd lesson-8-9

## Initialize Terraform
terraform init

## Review the plan
terraform plan

## Apply the changes

terraform apply


## To destroy all resources
terraform destroy

# To deploy app

## Navigate to the Helm chart directory
cd charts/django-app

## Preview the installation (dry-run)
helm install django-app . --dry-run --debug

## Install the application
helm install django-app .

## Upgrade the application (when chart changes)
helm upgrade django-app .

## Uninstall the application
helm uninstall django-app
