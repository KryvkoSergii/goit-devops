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
  vpc_name           = "lesson-9"
}

module "ecr" {
  source       = "./modules/ecr/"
  ecr_name     = "django-app"
  scan_on_push = true
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = "eks-cluster-lesson-9"
  subnet_ids    = module.vpc.private_subnets
  instance_type = "t3.medium"
  desired_size  = 1
  max_size      = 3
  min_size      = 1
}

module "rds" {
  source             = "./modules/rds/"
  postgres_username  = "django_user"
  postgres_password  = "pass9764gd"
  postgres_db_name   = "django_db"
  subnets            = module.vpc.private_subnets
  availability_zone  = "eu-north-1a"
  vpc_id             = module.vpc.vpc_id
  allowed_cidr_block = "0.0.0.0/0"
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
}

# module "argo_cd" {
#   source        = "./modules/argo-cd/"
#   namespace     = "argocd"
#   name          = "argo-cd"
#   chart_version = "5.46.4"
# }
