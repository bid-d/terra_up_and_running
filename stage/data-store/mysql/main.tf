provider "aws" {
  region = "ap-southeast-1"
}
resource "aws_db_instance" "bidd_db_mysql" {
  identifier_prefix   = "bidd-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "bidd_database"
  username            = "bidd"
  password            = "bidd123123"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "bidd-up-and-running-state"
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "ap-southeast-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}