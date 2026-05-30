terraform {
  required_version = ">= 1.6.0"

  cloud {
    organization = "djoo-hashicorp"
    workspaces {
      name = "tf-aws-clm-httpd-target"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.100"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "TFC Managed"        = "true"
      "TF/TFC directories" = "djoo-hashicorp/tf-aws-clm-httpd-target"
    }
  }
}

provider "hcp" {}
