### DR Infrastructure

output "dr_vpc_id" {
  value = aws_vpc.dr.id
}

output "dr_vpc_cidr" {
  value = aws_vpc.dr.cidr_block
}

output "drs_staging_subnet_id" {
  value = aws_subnet.drs_staging.id
}

output "drs_recovery_subnet_id" {
  value = aws_subnet.drs_recovery.id
}

output "dr_private_route_table_id" {
  value = aws_route_table.dr_private.id
}

### VPC Peering

output "vpc_peering_connection_id" {
  value = aws_vpc_peering_connection.source_to_dr.id
}

### DRS

output "drs_replication_template_id" {
  value = aws_drs_replication_configuration_template.drs.id
}