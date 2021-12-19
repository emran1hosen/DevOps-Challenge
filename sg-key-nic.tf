resource "aws_security_group" "jump_server_sg" {
  name        = "bs_sg"
  description = "bs_sg_des"
  vpc_id      = aws_vpc.main.id

ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }

egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_security_group" "web_server_sg" {
  name        = "sg_web"
  description = "sg_web_des"
  vpc_id      = aws_vpc.main.id

ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]

 }

ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}


locals {
  key_name = "key1"
}


resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "key1"
  public_key = tls_private_key.example.public_key_openssh
}


resource "aws_network_interface" "NIC1" {
  subnet_id   = aws_subnet.private_subnet_01.id
  security_groups = [aws_security_group.web_server_sg.id]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_network_interface" "NIC2" {
  subnet_id   = aws_subnet.public_subnet_01.id
  security_groups = [aws_security_group.jump_server_sg.id]

  tags = {
    Name = "primary_network_interface"
  }
}