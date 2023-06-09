# --------------------------
# terraform configuration
# --------------------------
terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
  # (keyで設定した)tfstateファイルの保存先を変更する
  # backend "s3" {
  #   bucket  = "tastylog-tfstate-bucket-knaatp0990"
  #   key     = "tastylog-dev.tfstate"
  #   region  = "ap-northeast-1"
  #   profile = "terraform"
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}
