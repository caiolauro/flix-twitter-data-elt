provider "aws" {
  region = var.region
}

terraform {
  required_version = "> 0.13.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.59.0"
    }
  }
  backend "s3" {
    bucket  = "flixbus"
    key     = "terraform/aws/roles/snowflake_access_role/terraform.tfstate"
    region  = "sa-east-1"
    encrypt = true

  }
}



