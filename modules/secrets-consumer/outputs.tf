output "cluster_secret_store_name" { value = var.css_name }
output "eso_sa_namespace" { value = var.eso_ns }
output "eso_sa_name" { value = var.eso_sa_name }
output "eso_role_arn" { value = aws_iam_role.eso_irsa.arn }