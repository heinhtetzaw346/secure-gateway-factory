terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.23.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

provider "aws" {
  region = var.region
  access_key = var.access_key != "" && var.access_key != null ? var.access_key : null
  secret_key = var.secret_key != "" && var.secret_key != null ? var.secret_key : null
}

provider "random" {}
