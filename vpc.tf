provider "aws" {
   region  = "ap-southeast-1"
}



resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Project = "devops-test"
    Name = "devops-test-vpc"
 }
}



resource "aws_subnet" "private_subnet_01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
}



resource "aws_subnet" "public_subnet_01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false

}



resource "aws_internet_gateway" "devops-igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Project = "devops-test"
    Name = "internet gateway"
 }
}



resource "aws_route_table" "public_subnet_01_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops-igw.id
  }

}



resource "aws_route_table_association" "internet_for_public_subnet_01" {
  route_table_id = aws_route_table.public_subnet_01_rt.id
  subnet_id      = aws_subnet.public_subnet_01.id
}


  resource "aws_eip" "eip_natgw01" {
  count = "1"
}



resource "aws_nat_gateway" "natgateway_1" {
  count         = "1"
  allocation_id = aws_eip.eip_natgw01[count.index].id
  subnet_id     = aws_subnet.public_subnet_01.id
}



resource "aws_route_table" "private_subnet_01_rt" {
  count  = "1"
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_1[count.index].id
  }
}


resource "aws_route_table_association" "pri_sub1_to_natgw1" {
  count          = "1"
  route_table_id = aws_route_table.private_subnet_01_rt[count.index].id
  subnet_id      = aws_subnet.private_subnet_01.id
}
