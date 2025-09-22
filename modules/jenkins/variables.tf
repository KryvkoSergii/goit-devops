variable "namespace" {
  type = string
  default = "jenkins"
}

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

variable "tags" {
  type    = map(string)
  default = {}
}

variable "cluster_secret_store_name" {
  type = string
}