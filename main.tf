terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "My-Test-VPC"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "my-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "my-private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "my_ig" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "My-Internet-Gateway"
  }
}

# Route Table
resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_ig.id
  }

  tags = {
    Name = "My-Route-Table"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_sub" {
  route_table_id = aws_route_table.my_rt.id
  subnet_id      = aws_subnet.public_subnet.id
}

resource "aws_instance" "mywebserver" {

  ami = "ami-0ecb62995f68bb549"
  instance_type = "t3.nano"
  subnet_id= aws_subnet.public_subnet.id
  tags = {
    Name= "MyWebServer"
  }
}
