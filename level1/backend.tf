terraform {
  backend "s3" {
    bucket         = "saftronbucket"
    key            = "level1.tfstate"
    region         = "us-east-1"
    dynamodb_table = "state-lock"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
