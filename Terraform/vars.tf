variable "ubuntu_ami" {
  description = "EC2 AMI Ubuntu 24.4"
  type = string
  default = "ami-0e872aee57663ae2d"
}

variable "ec2_master_instance_type" {
  description = "EC2 Instance type of master nodes"
  type = string
  default = "t2.micro"
}

variable "ec2_worker_instance_type" {
  description = "EC2 Instance type of worker nodes"
  type = string
  default = "t2.micro"
}
