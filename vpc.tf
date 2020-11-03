terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "2.63.0"
  cidr            = "10.0.0.0/16"
  name            = "auto-201-vpc"
  azs             = ["eu-west-2a"]
  private_subnets = ["10.0.3.0/24"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  # insert the 14 required variables here
}