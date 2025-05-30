terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.30.0"
    }
  }
  backend "s3" {
  
    bucket         	   = "hcl-hackathon-terraform-state"
    key                = "key/terraform.tfstate"
    region         	   = "us-east-1"
    encrypt        	   = true
  }
  required_version = ">= 1.9.8"
}