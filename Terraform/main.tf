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
  profile                  = "default"
  region                   = var.aws_region
  shared_credentials_files = [var.aws_credentials]
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "ssh_key_file" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = var.ssh_key_file
  file_permission = "400"
}

resource "aws_key_pair" "ssh_key_pair" {
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_vpc

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_vpc_public_subnet
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.cidr_all_networks
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "route_table_association" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_security_group" "main_security_group" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_all_networks] # Allow SSH
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_all_networks] # Allow HTTPS
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_vpc] # Allow kubeadm join
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_all_networks]
  }

  tags = {
    Name = "main-security-group"
  }
}
