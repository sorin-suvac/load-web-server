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

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content = tls_private_key.ssh_key.private_key_pem
  filename = "private-key.pem"
}

resource "aws_key_pair" "ssh_key_pair" {
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_security_group" "ssh_group" {
  name = "allow_ssh"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "master" {
  ami           = var.ubuntu_ami
  instance_type = var.ec2_master_instance_type
  key_name = aws_key_pair.ssh_key_pair.key_name

  tags = {
    Name = "K8S-Master"
  }
  vpc_security_group_ids = [aws_security_group.ssh_group.id]
}

output "master_ip" {
  value = aws_instance.master.public_ip
}

resource "aws_instance" "worker1" {
  ami           = var.ubuntu_ami
  instance_type = var.ec2_worker_instance_type
  key_name = aws_key_pair.ssh_key_pair.key_name

  tags = {
    Name = "K8S-Worker1"
  }
  vpc_security_group_ids = [aws_security_group.ssh_group.id]
}

output "worker1_ip" {
  value = aws_instance.worker1.public_ip
}

resource "aws_instance" "worker2" {
  ami           = var.ubuntu_ami
  instance_type = var.ec2_worker_instance_type
  key_name = aws_key_pair.ssh_key_pair.key_name

  tags = {
    Name = "K8S-Worker2"
  }
  vpc_security_group_ids = [aws_security_group.ssh_group.id]
}

output "worker2_ip" {
  value = aws_instance.worker2.public_ip
}
