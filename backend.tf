 terraform {
   backend "s3" {
    bucket         = "hcl-awsdevops-project"
    key            = "statefiles/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
   }
 }