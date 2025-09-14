terraform {
  backend "s3" {
    bucket         = "goit-devops-terraform-state-bucket"
    key            = "lesson-9/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "goit-devops-terraform-locks"
    encrypt        = true
  }
}
