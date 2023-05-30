resource "aws_instance" "web" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = "tfkey"
  security_groups = [aws_security_group.TF_SG.name]
  tags = {
    Name = "TerraformGraf"
  }
}

resource "aws_key_pair" "tfkey" {
  key_name   = "tfkey"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tfkey" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = "tfkey"
  file_permission = "0400"
}

resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_eip_association" "eip-association" {
  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.eip.id
}

resource "aws_security_group" "TF_SG" {
  name        = "SG for Terraform"
  description = "security group for Terraform"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF_SG"
  }
}

resource "null_resource" "docker_install" {
  connection {
    host        = aws_eip.eip.public_ip
    type        = "ssh"
    user        = "ec2-user"
    agent       = false
    private_key = tls_private_key.rsa.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo usermod -aG docker ec2-user",
      "sudo systemctl enable docker",
      "sudo docker run -d -p 3000:${var.grafana_port} --name grafana grafana/grafana"
    ]
  }

  depends_on = [aws_instance.web, aws_eip.eip, tls_private_key.rsa]
}
