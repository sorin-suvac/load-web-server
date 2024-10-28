terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
  shared_credentials_files = ["/mnt/c/Users/ssuva/.aws/credentials"]
}

resource "aws_instance" "master" {
  ami           = var.ubuntu_ami
  instance_type = var.ec2_master_instance_type

  tags = {
    Name = "K8S-Master"
  }
}

resource "aws_instance" "worker1" {
  ami           = var.ubuntu_ami
  instance_type = var.ec2_worker_instance_type

  tags = {
    Name = "K8S-Worker1"
  }
}

resource "aws_instance" "worker2" {
  ami           = var.ubuntu_ami
  instance_type = var.ec2_worker_instance_type

  tags = {
    Name = "K8S-Worker2"
  }
}
