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

<pre>  <b>lesson-8-9/</b> ├── <b>main.tf</b> # Main entry point for Terraform modules ├── <b>backend.tf</b> # S3 + DynamoDB backend config ├── <b>outputs.tf</b> # General resource outputs ├── <b>modules/</b> # Terraform modules │ │ ├── <b>s3-backend/</b> # Remote state backend module │ │ ├── s3.tf # S3 bucket definition │ │ ├── dynamodb.tf # DynamoDB table for locking │ │ ├── variables.tf # Input variables │ │ └── outputs.tf # Outputs │ │ ├── <b>vpc/</b> # Virtual Private Cloud module │ │ ├── vpc.tf # VPC, subnets, IGW │ │ ├── routes.tf # Route tables │ │ ├── variables.tf │ │ └── outputs.tf │ │ ├── <b>ecr/</b> # Elastic Container Registry module │ │ ├── ecr.tf # ECR repository │ │ ├── variables.tf │ │ └── outputs.tf │ │ ├── <b>eks/</b> # Elastic Kubernetes Service module │ │ ├── eks.tf # EKS cluster definition │ │ ├── aws_ebs_csi_driver.tf # EBS CSI Driver plugin │ │ ├── variables.tf │ │ └── outputs.tf │ │ ├── <b>jenkins/</b> # Jenkins Helm deployment │ │ ├── jenkins.tf # Helm release for Jenkins │ │ ├── variables.tf │ │ ├── providers.tf │ │ ├── values.yaml # Helm chart values for Jenkins │ │ └── outputs.tf │ │ └── <b>argo_cd/</b> # Argo CD Helm deployment │ ├── argo.tf # Helm release for Argo CD │ ├── variables.tf │ ├── providers.tf │ ├── values.yaml # Helm chart values for Argo CD │ ├── outputs.tf │ └── <b>charts/</b> # Argo CD custom Helm chart │ ├── Chart.yaml │ ├── values.yaml # List of applications & repositories │ └── templates/ │ ├── application.yaml │ └── repository.yaml ├── <b>charts/</b> # Application Helm charts │ │ └── <b>django-app/</b> # Django app Helm chart │ ├── templates/ │ │ ├── deployment.yaml │ │ ├── service.yaml │ │ ├── configmap.yaml │ │ ├── hpa.yaml │ │ ├── postgres-deployment.yaml │ │ ├── postgres-service.yaml │ │ └── postgress-pvc.yaml │ ├── Chart.yaml │ └── values.yaml </pre>




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
