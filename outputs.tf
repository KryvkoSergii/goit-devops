output "s3_bucket_name" {
  description = "S3 bucket name for Terraform state"
  value       = module.s3_backend.s3_bucket_name
}

output "dynamodb_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  value       = module.s3_backend.dynamodb_table_name
}

output "ECR_repository_url" {
  description = "URL of the created ECR repository"
  value       = module.ecr.repository_url
}

output "oidc_provider_arn" {
  description = "OIDC Provider ARN"
  value       = module.eks.oidc_provider_arn
}

output "oidc_provider_url" {
  description = "OIDC Provider URL"
  value       = module.eks.oidc_provider_url
}

#-------------Jenkins-----------------
output "jenkins_release" {
  value = module.jenkins.jenkins_release_name
}

output "jenkins_namespace" {
  value = module.jenkins.jenkins_namespace
}

#-------------RDS-----------------
output "postgres_endpoint" {
  description = "PostgreSQL RDS instance endpoint"
  value       = module.rds.db_instance_endpoint
}
