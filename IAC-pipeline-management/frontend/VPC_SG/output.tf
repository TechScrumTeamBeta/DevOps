
output "vpc_id" {
  value = data.aws_vpc.selected.id
}

output "subnet_ids" {
  value = var.subnet_ids
}

output "security_group_id" {
  value = data.aws_security_group.selected.id
}
