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