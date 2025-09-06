# GoIT DevOps. IaC (Terraform)

## Purpose:
Automate cloud infrastructure deployment for DevOps projects on AWS using Terraform.

### General structure
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
Public: routes traffic through the Internet Gateway.
Private: routes traffic through the NAT Gateway.
* Associates the corresponding subnets with the route tables.

### ECR (Elastic Container Registry)
* Creates an ECR repository to store Docker images.
* You can enable automatic image scanning when loading.

### Outputs
Displays the identifiers of the created resources: VPC, subnets, Internet Gateway, ECR repository, S3 bucket, DynamoDB table.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- [AWSCLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed
- Properly configured AWS provider credentials

## AWS CLI Commands

### Configure profile

```sh
aws configure
```

With profile
```sh
aws configure --profile <name>
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
