variable "amazon-ami" {
  description = "Amazon Linux AMI"
  type        = string
  default     = "ami-006a8d994e496f594"
}

variable "host-public-key" {
  description = "NixOS host public key"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPgiryHNJDDTdYGZBb0P14e2iqNdG0/gXd9ow+5SE6fW timothee.ren@proton.me"
}
