provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "bidd-up-and-running-state"
    key            = "stage/vpc/terraform.tfstate"
    region         = "ap-southeast-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

resource "aws_vpc" "stage_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Stage VPC"
  }
}

resource "aws_subnet" "stage_public_subnet" {
  vpc_id     = aws_vpc.stage_vpc.id
  map_public_ip_on_launch = true
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Stage Public Subnet"
  }
}

resource "aws_internet_gateway" "stage_gw" {
  vpc_id = aws_vpc.stage_vpc.id

  tags = {
    Name = "Stage Internet Gateway"
  }
}

resource "aws_route_table" "stage_public_subnet_route_table" {
  vpc_id = aws_vpc.stage_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.stage_gw.id
  }

  tags = {
    Name = "Stage Public Subnet Route Table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.stage_public_subnet.id
  route_table_id = aws_route_table.stage_public_subnet_route_table.id
}