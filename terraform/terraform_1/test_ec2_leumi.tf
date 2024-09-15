provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "test_ec2" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  key_name      = "infinity_key_web"

  security_groups = [aws_security_group.allow_http_from_proxy.name]

  tags = {
    Name = "test-ec2"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install apache2 -y
              systemctl start apache2
              systemctl enable apache2
              EOF
}

resource "aws_security_group" "allow_http_from_proxy" {
  name        = "allow_http_from_proxy"
  description = "Allow HTTP from specific proxy"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["91.231.246.50/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_eip" "test_eip" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id = aws_instance.test_ec2.id
  allocation_id = aws_eip.test_eip.id
}

