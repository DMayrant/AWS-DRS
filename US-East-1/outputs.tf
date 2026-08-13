output "source_vpc_id" {
  value = aws_vpc.drs.id
}

output "source_vpc_cidr" {
  value = aws_vpc.drs.cidr_block
}

output "source_private_route_table_id" {
  value = aws_route_table.private.id
}

output "drs_agent_permissions_allowed" {
  description = "Whether dmay-admin is allowed to perform the required DRS agent operations"
  value       = data.aws_iam_principal_policy_simulation.drs_agent_permissions.all_allowed
}