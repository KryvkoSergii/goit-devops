locals {
  tags = {
    Environment = "db-module"
    Project     = "goit-devops"
  }
}

provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source             = "./modules/vpc/"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  vpc_name           = "${local.tags.Environment}-vpc"
  tags               = local.tags
}

module "ecr" {
  source       = "./modules/ecr/"
  ecr_name     = "django-app"
  scan_on_push = true
  tags         = local.tags
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = "eks-cluster-${local.tags.Environment}"
  subnet_ids    = module.vpc.private_subnets
  instance_type = "t3.medium"
  desired_size  = 1
  max_size      = 3
  min_size      = 1
  tags          = local.tags
}

module "rds" {
  source = "./modules/rds"

  name                  = "${local.tags.Environment}-db"
  use_aurora            = false
  aurora_instance_count = 2

  # --- RDS-only ---
  engine                     = "postgres"
  engine_version             = "17.2"
  parameter_group_family_rds = "postgres17"

  # Common
  instance_class          = "db.t3.medium"
  allocated_storage       = 20
  db_name                 = "myapp"
  username                = "postgres"
  password                = "admin123AWS23"
  subnet_private_ids      = module.vpc.private_subnets
  subnet_public_ids       = module.vpc.public_subnets
  publicly_accessible     = true
  vpc_id                  = module.vpc.vpc_id
  multi_az                = true
  backup_retention_period = 7
  parameters = {
    max_connections            = "200"
    log_min_duration_statement = "500"
  }

  tags = local.tags
}

data "aws_eks_cluster" "eks" {
  name = module.eks.eks_cluster_name

  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_name

  depends_on = [module.eks]
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  alias = "eks"
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

module "jenkins" {
  source            = "./modules/jenkins/"
  cluster_name      = module.eks.eks_cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
  github_pat        = var.github_pat
  github_user       = var.github_user
  github_repo_url   = var.github_repo_url

  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }

  depends_on = [module.eks]

  tags = local.tags
}

module "argo_cd" {
  source        = "./modules/argo-cd/"
  namespace     = "argocd"
  name          = "argo-cd"
  chart_version = "5.46.4"
  github_pat    = var.github_pat
  github_user   = var.github_user

  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }
}
