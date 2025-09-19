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

#-------------DB-----------------
output "postgres_endpoint" {
  description = "DB instance endpoint"
  value       = module.rds.db_instance_endpoint
}
