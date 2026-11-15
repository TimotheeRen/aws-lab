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
  user_data            = <<-EOF
    #!/bin/bash
    touch ~/test.txt
    sudo dnf install -y amazon-cloudwatch-agent
    sudo cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<'JSON'
    {
      "opentelemetry": {
        "collect": {
          "otlp": {
            "grpc_endpoint": "127.0.0.1:4317",
            "http_endpoint": "127.0.0.1:4318"
          }
        }
      }
    }
    JSON

    sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
      -a fetch-config \
      -m ec2 \
      -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
      -s
  EOF
}
