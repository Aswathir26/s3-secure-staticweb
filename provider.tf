terraform {
 required_version = "1.0.11"

  required_providers {
   aws = {
   source = "hashicorp/aws"
   version = "~> 3.0"
  }
  azurerm = {
   source  = "hashicorp/azurerm"
   version = "=2.91.0"
  }
 }

 # backend "s3" {
 #   bucket = "bucket-staticweb"
 #   key = "staticweb/terraform.tfstate"
 #   region = "eu-west-1"
 # }
}

provider "aws" {
region = "us-east-1"
}
provider "azurerm" {
features {} 
}