resource "aws_key_pair" "host_key" {
  key_name   = "NixOS"
  public_key = var.host-public-key
}

resource "aws_instance" "ec2_instance" {
  ami                  = var.amazon-ami
  instance_type        = "t3.micro"
  security_groups      = [aws_security_group.ec2_security_group.name]
  key_name             = aws_key_pair.host_key.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
}
