variable "aws_credentials" {
  description = "AWS Credentials path"
  type        = string
  default     = "credentials"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-central-1"
}

variable "ubuntu_ami" {
  description = "EC2 AMI Ubuntu 24.4"
  type        = string
  default     = "ami-0e872aee57663ae2d"
}

variable "ubuntu_user" {
  description = "EC2 AMI Ubuntu username"
  type        = string
  default     = "ubuntu"
}

variable "ec2_master_instance_type" {
  description = "EC2 Instance type of master nodes"
  type        = string
  default     = "t2.micro"
}

variable "ec2_worker_instance_type" {
  description = "EC2 Instance type of worker nodes"
  type        = string
  default     = "t2.micro"
}

variable "ssh_key_file" {
  description = "SSH key file name"
  type        = string
  default     = "private-key.pem"
}

variable "cidr_vpc" {
  description = "CIDR - VPC network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cidr_vpc_public_subnet" {
  description = "CIDR - VPC public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "cidr_all_networks" {
  description = "CIDR - All networks"
  type        = string
  default     = "0.0.0.0/0"
}
