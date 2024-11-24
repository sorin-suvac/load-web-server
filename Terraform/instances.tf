resource "aws_instance" "master" {
  ami                         = var.ubuntu_ami
  instance_type               = var.ec2_master_instance_type
  subnet_id                   = aws_subnet.public.id
  security_groups             = [aws_security_group.main_security_group.id]
  key_name                    = aws_key_pair.ssh_key_pair.key_name
  associate_public_ip_address = true

  provisioner "file" {
    source      = "../Scripts/install-kubeadm.sh"
    destination = "/tmp/install-kubeadm.sh"

    connection {
      type        = "ssh"
      user        = var.ubuntu_user
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "../Scripts/init-kubeadm.sh"
    destination = "/tmp/init-kubeadm.sh"

    connection {
      type        = "ssh"
      user        = var.ubuntu_user
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-kubeadm.sh",
      "chmod +x /tmp/init-kubeadm.sh"
    ]

    connection {
      type        = "ssh"
      user        = var.ubuntu_user
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = self.public_ip
    }
  }

  tags = {
    Name = "k8s-master"
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
  security_groups             = [aws_security_group.main_security_group.id]
  key_name                    = aws_key_pair.ssh_key_pair.key_name
  associate_public_ip_address = true

  provisioner "file" {
    source      = "../Scripts/install-kubeadm.sh"
    destination = "/tmp/install-kubeadm.sh"

    connection {
      type        = "ssh"
      user        = var.ubuntu_user
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-kubeadm.sh"
    ]

    connection {
      type        = "ssh"
      user        = var.ubuntu_user
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = self.public_ip
    }
  }

  tags = {
    Name = "k8s-worker-${count.index + 1}"
  }
}

output "worker_ips" {
  value = aws_instance.worker[*].public_ip
}
