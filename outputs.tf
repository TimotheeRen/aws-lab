output "instance_dns" {
  description = "Instance public DNS"
  value       = aws_instance.ec2_instance.public_dns
}

output "instance_ip" {
  description = "Instance public IPv4"
  value       = aws_instance.ec2_instance.public_ip
}
