variable "postgres_username" {
  description = "The username for the PostgreSQL database"
  type        = string  
}

variable "postgres_password" {
  description = "The password for the PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "postgres_db_name" {
  description = "The name of the PostgreSQL database"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "availability_zone" {
  description = "The availability zone for the RDS instance"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the RDS instance will be deployed"
  type        = string
}

variable "allowed_cidr_block" {
  description = "CIDR block allowed to access the RDS instance"
  type        = string
}