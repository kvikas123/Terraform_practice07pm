terraform {
  backend "s3" {
    bucket = "vikkytests3bucket"
    key = "terraform.tfstate"
    region = "us-east-1"

    
  }
}