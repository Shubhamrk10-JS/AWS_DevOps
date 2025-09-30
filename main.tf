terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.12.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}
resource "aws_vpc" "My-VPC" {
  cidr_block       = "20.20.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "My-VPC"
  }
}

resource "aws_subnet" "Public_Subnet" {
  vpc_id     = aws_vpc.My-VPC.id
  cidr_block = "20.20.1.0/24"

  tags = {
    Name = "Public_Subnet"
  }
}

resource "aws_subnet" "Private_Subnet" {
  vpc_id     = aws_vpc.My-VPC.id
  cidr_block = "20.20.2.0/24"

  tags = {
    Name = "Private_Subnet"
  }
}

resource "aws_internet_gateway" "My-IGW" {
  vpc_id = aws_vpc.My-VPC.id

  tags = {
    Name = "My-IGW"
  }
}

resource "aws_route_table" "MRT" {
  vpc_id = aws_vpc.My-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.My-IGW.id
  }
 
 

  tags = {
    Name = "MRT"
  }
}

resource "aws_eip" "EIP" {
    domain   = "vpc"

}

resource "aws_nat_gateway" "gw-NAT" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.Public_Subnet.id

  tags = {
    Name = "gw-NAT"
  }

}

resource "aws_route_table" "CRT" {
  vpc_id = aws_vpc.My-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw-NAT.id
  }
 
  tags = {
    Name = "CRT"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.Public_Subnet.id
  route_table_id = aws_route_table.MRT.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.Private_Subnet.id
  route_table_id = aws_route_table.CRT.id
}
