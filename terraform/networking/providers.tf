terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.0"
    }
  }

  required_version = "~> 1.0"

  # PATTERN B: Variables passed in as TF_VAR env variables
  backend "s3" {
    bucket = "${var.tf_state_bucket}"
    key = "${var.tf_state_key}"
    region = "${var.aws_region}"
    profile = "${var.aws_profile}"
  }

}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}