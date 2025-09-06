terraform {
  backend "s3" {
    bucket         = "goit-devops-lesson-5-terraform-state-bucket"
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "goit-devops-lesson-5-terraform-locks"
    encrypt        = true
  }
}
