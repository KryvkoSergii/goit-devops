variable "tags" {
  type    = map(string)
  default = {}
}

variable "cluster_name" {
  description = "Name of Kubernetes cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC ARN"
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC URL"
  type        = string
}

variable "secret_arns" { type = list(string) }

variable "eso_ns" {
  type    = string
  default = "external-secrets"
}

variable "eso_sa_name" {
  type    = string
  default = "external-secrets"
}

variable "css_name" {
  description = "ClusterSecretStore name"
  type        = string
  default     = "aws-secrets"
}

variable "aws_region" {
  description = "aws region"
  type = string
}