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
  region                   = "eu-central-1"
  shared_credentials_files = ["/mnt/c/Users/ssuva/.aws/credentials"]
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "ssh_key_file" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "private-key.pem"
}

resource "aws_key_pair" "ssh_key_pair" {
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
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
    cidr_block = "0.0.0.0/0"
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

resource "aws_security_group" "allow_ssh_http_https" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-in_all-out"
  }
}

resource "aws_instance" "master" {
  ami                         = var.ubuntu_ami
  instance_type               = var.ec2_master_instance_type
  subnet_id                   = aws_subnet.public.id
  security_groups             = [aws_security_group.allow_ssh_http_https.id]
  key_name                    = aws_key_pair.ssh_key_pair.key_name
  associate_public_ip_address = true

  tags = {
    Name = "K8S-Master"
  }
}

output "master_ip" {
  value = aws_instance.master.public_ip
}

resource "aws_instance" "worker" {
  count                       = 2
  ami                         = var.ubuntu_ami
  instance_type               = var.ec2_worker_instance_type
  subnet_id                   = aws_subnet.public.id
  security_groups             = [aws_security_group.allow_ssh_http_https.id]
  key_name                    = aws_key_pair.ssh_key_pair.key_name
  associate_public_ip_address = true

  tags = {
    Name = "K8S-Worker${count.index + 1}"
  }
}

output "worker_ips" {
  value = aws_instance.worker[*].public_ip
}
