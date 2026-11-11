provider "aws" {
  region = "eu-north-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
  description = "Default ec2 security group"
  vpc_id      = data.aws_vpc.default.id
  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic_ssh" {
  security_group_id = aws_security_group.ec2_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_internet" {
  security_group_id = aws_security_group.ec2_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "ec2-bucket-3j2k3"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "public_read_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      aws_s3_bucket.bucket.arn
    ]
  }
}

resource "aws_s3_bucket_policy" "public_read_document" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.public_read_document.json
}

resource "aws_key_pair" "host_key" {
  key_name   = "NixOS"
  public_key = var.host-public-key
}

resource "aws_instance" "ec2_instance" {
  ami             = var.amazon-ami
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.ec2_security_group.name]
  key_name        = aws_key_pair.host_key.key_name
}
