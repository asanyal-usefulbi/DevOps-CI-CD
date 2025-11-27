terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Generate a random suffix for unique bucket names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Demo S3 bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "demo-terraform-bucket-${random_string.suffix.result}"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Optional: Enable versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.demo_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
