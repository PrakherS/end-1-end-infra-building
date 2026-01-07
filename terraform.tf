terraform {
  required_version = ">=1.8.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                   = "eu-west-1"
  shared_credentials_files = ["C:\\Users\\prakh\\.aws\\credentials"]
  #   access_key = "my-access-key"
  #   secret_key = "my-secret-key"
}
