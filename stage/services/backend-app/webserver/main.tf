provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "bidd-up-and-running-state"
    key            = "stage/backend/webserver/terraform.tfstate"
    region         = "ap-southeast-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

data "aws_subnet" "stage" {
  filter {
    name = "tag:Name"
    values = ["Stage Public Subnet"]
  }
}

data "aws_vpc" "stage" {
  filter {
    name = "tag:Name"
    values = ["Stage VPC"]
  }
}

resource "aws_instance" "webserver_rhel" {
  ami           = var.ami_type
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.stage_vpc_sg.id]
  subnet_id = data.aws_subnet.stage.id
  key_name = var.key_pair
  tags = {
    Name = "Webserver Server"
  }
}

resource "aws_instance" "ansible_rhel" {
  ami           = var.ami_type
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.stage_vpc_sg.id]
  subnet_id = data.aws_subnet.stage.id
  key_name = var.key_pair
  tags = {
    Name = "Ansible Server"
  }
}

resource "aws_instance" "webserver1_ubuntu" {
  ami           = var.ami_type_ubuntu
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.stage_vpc_sg.id]
  subnet_id = data.aws_subnet.stage.id
  key_name = var.key_pair
  tags = {
    Name = "Ubuntu1 Server"
  }
}

resource "aws_instance" "webserver2_ubuntu" {
  ami           = var.ami_type_ubuntu
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.stage_vpc_sg.id]
  subnet_id = data.aws_subnet.stage.id
  key_name = var.key_pair
  tags = {
    Name = "Ubuntu2 Server"
  }
}

resource "aws_instance" "webserver3_ubuntu" {
  ami           = var.ami_type_ubuntu
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.stage_vpc_sg.id]
  subnet_id = data.aws_subnet.stage.id
  key_name = var.key_pair
  tags = {
    Name = "Ubuntu3 Server"
  }
}

resource "aws_security_group" "stage_vpc_sg" {
  name = "Stage VPC Security Group"
  vpc_id = data.aws_vpc.stage.id
  
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Stage VPC Security Group"
  }
}