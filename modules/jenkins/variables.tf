variable "cluster_name" {
  description = "Name of Kubernetes cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL of the OIDC provider"
  type        = string
}

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive = true
}

variable "github_user" {
  description = "GitHub username"
  type        = string
  sensitive = true
}

variable "github_repo_url" {
  description = "GitHub repository name"
  type        = string
}
