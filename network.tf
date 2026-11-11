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

