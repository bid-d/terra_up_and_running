provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "bidd-up-and-running-state"
    key            = "mgmt/jenkins/terraform.tfstate"
    region         = "ap-southeast-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

resource "aws_instance" "jenkins_rhel" {
  ami           = var.ami_type
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_security.id]
  key_name = var.key_pair
  # user_data = file("templates/install_jenkins.sh")
  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_security_group" "ec2_security" {
  name = "ec2_security_jenkins_traffic"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
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
}