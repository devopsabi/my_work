terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47.0"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  region = "us-east-1"
}
