provider "aws" {
  region = "eu-north-1"
}

module "s3_backend" {
  source      = "./modules/s3-backend/"
  bucket_name = "goit-devops-terraform-state-bucket"
  table_name  = "goit-devops-terraform-locks"
}

module "vpc" {
  source             = "./modules/vpc/"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  vpc_name           = "lesson-7-vpc"
}

module "ecr" {
  source      = "./modules/ecr/"
  ecr_name    = "lesson-7-ecr"
  scan_on_push = true
}

module "eks" {
  source          = "./modules/eks"          
  cluster_name    = "eks-cluster-lesson-7"            
  subnet_ids      = module.vpc.private_subnets     
  instance_type   = "t3.micro"                    
  desired_size    = 1
  max_size        = 2
  min_size        = 1
}