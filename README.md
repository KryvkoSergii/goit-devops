# GoIT DevOps. IaC (Terraform), Kubernetes (EKS), Helm

## Purpose:
Automate cloud infrastructure deployment for django projects to AWS EKS using Terraform and Helm Charts.

### General structure Terraform
The code automates the creation of the basic AWS infrastructure for a DevOps project using a modular approach.

### S3 Backend
* Creates an S3 bucket to store Terraform state.
* Creates a DynamoDB table for state locking.
* Configures Terraform to use this backend (backend.tf file).
### VPC (Virtual Private Cloud)
* Creates a VPC with a specified CIDR block.
* Creates public and private subnets in three availability zones.
* Creates an Internet Gateway for public subnets.
* Creates a NAT Gateway for private subnets (via Elastic IP).
* Creates two route tables:
    * Public: routes traffic through the Internet Gateway.
    * Private: routes traffic through the NAT Gateway.
* Associates the corresponding subnets with the route tables.

### ECR (Elastic Container Registry)
* Creates an ECR repository to store Docker images.
* You can enable automatic image scanning when loading.

### EKS (Elastic Kubernetes Service)
* Sets up networking and IAM roles required for EKS operation.
* Provisions an EKS cluster for container orchestration.
* Configures worker nodes and node groups for scalable workloads.

### Outputs
Displays the identifiers of the created resources: VPC, subnets, Internet Gateway, ECR repository, S3 bucket, DynamoDB table.

## Helm Charts
* Deploys django [app](307987835663.dkr.ecr.eu-north-1.amazonaws.com/lesson-7-ecr:0.0.1) to EKS
* Adds HPA to django app

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- [AWSCLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed
- Properly configured AWS provider credentials
- [kubectl]
- Properly configuret kubectl
- [helm](https://helm.sh/)

## CLI Commands

### Configure profile

```sh
aws configure
```

With profile
```sh
aws configure --profile <name>
```

### ECR

Get data about repository 
```sh
aws ecr describe-repositories --repository-names <repo> --region <region>
```

Login to ECR
```sh 
docker login <arrount-id>.dkr.ecr.<region>.amazonaws.com --username AWS --password $(aws ecr get-login-password --region <region>)
```

Docker tag
```sh
docker tag <repo>:<version> <arrount-id>.dkr.ecr.<region>.amazonaws.com/<repo>:<version>
```

Docker push
```sh
docker push <arrount-id>.dkr.ecr.<region>.amazonaws.com/<repo>:<version>
```

### Kubectl
Update config
```sh
aws eks update-kubeconfig --region <region> --name <claster-name> --profile <profile>
```
To deploy database into AWS EKS
```sh
kubectl apply -f .\db\postgres-secret
kubectl apply -f .\db\postgres-deploy.yaml
```
!May require additional steps

### Helm
To instll django-app navidate .\charts\django-app and run
```sh
helm install django-app .
```
To update
```sh
helm upgrade django-app .
```

## Common Terraform Commands

### 1. `terraform init`
Initializes a Terraform working directory. Downloads required providers and sets up the backend.

```sh
terraform init
```

### 2. `terraform plan`
Creates an execution plan, showing what actions Terraform will perform.

```sh
terraform plan
```

### 3. `terraform apply`
Applies the changes required to reach the desired state of the configuration.

```sh
terraform apply
```

### 4. `terraform destroy`
Destroys the infrastructure managed by Terraform.

```sh
terraform destroy
```

## Useful Links

- [Terraform Documentation](https://www.terraform.io/docs)
- [Terraform CLI Commands](https://developer.hashicorp.com/terraform/cli/commands)
