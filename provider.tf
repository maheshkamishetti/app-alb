terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0" 
    }
  }

  backend "s3" {
    bucket         = "dazn.live.rem"
    key            = "app-alb"
    region         = "us-east-1"
    dynamodb_table = "dazn.live.rem.locking"
  }
}

provider "aws" {
  region = "us-east-1"
}