# Public Configuration Info
output "whitelist_ip" {
  value = aws_eip.nat-ip-address.public_ip
}

# Sensitive Info - Only Passed Through Backend
output "vpc" {
  value = aws_vpc.jd-vpc
  sensitive = true
}

output "igw" {
  value = aws_internet_gateway.jd-igw
  sensitive = true
}

output "api_lambda_exec" {
  value = aws_iam_role.api_lambda_exec
  sensitive = true
}

output "public_subnet_id" {
  value = aws_subnet.jd-public.id
  sensitive = true
}

output "private_subnet_id" {
  value = aws_subnet.jd-private.id
  sensitive = true
}

output "vpc_security_group_id" {
  value = aws_security_group.jd-default-vpc-sg.id
  sensitive = true
}

output "jump_host_ip" {
  # value = var.stage == "stage" ? aws_instance.jump_host[0].public_ip : "setup in stage pipeline only"
  value = aws_instance.jump_host.public_ip
  sensitive = false
}