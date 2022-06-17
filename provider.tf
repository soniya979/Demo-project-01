terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    #  version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider

provider "aws" {
  region = "eu-west-2"
  #shared_config_files      = ["/home/ec2-user/.aws/config"]
  #shared_credentials_files = ["/home/ec2-user/.aws/credentials"]
  #profile                  = "default"
}
