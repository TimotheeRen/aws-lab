provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "app_server" {
  ami           = var.amazon-ami
  instance_type = "t3.micro"
}
