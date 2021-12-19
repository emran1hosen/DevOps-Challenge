data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jumpbox" {

  ami = data.aws_ami.ubuntu.id
  subnet_id = aws_subnet.public_subnet_01.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  availability_zone = "ap-southeast-1a"
  key_name = aws_key_pair.generated_key.key_name

}

resource "aws_instance" "ubuntu" {

  ami = data.aws_ami.ubuntu.id
  subnet_id = aws_subnet.private_subnet_01.id
  instance_type = "t2.micro"
  associate_public_ip_address = false
  availability_zone = "ap-southeast-1a"
  key_name = aws_key_pair.generated_key.key_name
  user_data = file("./env_readiness.sh")

}

resource "aws_network_interface_sg_attachment" "aws_net_int_sg_attc" {
  security_group_id    = aws_security_group.web_server_sg.id
  network_interface_id = aws_instance.ubuntu.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "aws_net_int_sg_attc_02" {
  security_group_id    = aws_security_group.jump_server_sg.id
  network_interface_id = aws_instance.jumpbox.primary_network_interface_id
}