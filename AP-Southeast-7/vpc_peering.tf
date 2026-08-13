### INTER-REGION VPC PEERING
### Source Region: us-east-1
### DR Region: ap-southeast-7

### VPC Peering Request
### us-east-1 -> ap-southeast-7

resource "aws_vpc_peering_connection" "source_to_dr" {
  provider = aws

  vpc_id = data.terraform_remote_state.primary.outputs.source_vpc_id

  peer_vpc_id = aws_vpc.dr.id
  peer_region = "ap-southeast-7"

  auto_accept = false

  tags = {
    Name        = "drs-us-east-1-to-ap-southeast-7"
    Environment = "disaster-recovery"
  }
}


### Accept VPC Peering Connection
### ap-southeast-7

resource "aws_vpc_peering_connection_accepter" "dr" {
  provider = aws.dr

  vpc_peering_connection_id = aws_vpc_peering_connection.source_to_dr.id
  auto_accept               = true

  tags = {
    Name        = "drs-us-east-1-to-ap-southeast-7"
    Environment = "disaster-recovery"
  }
}


### SOURCE ROUTE
### us-east-1 -> ap-southeast-7

resource "aws_route" "source_to_dr" {
  provider = aws

  route_table_id = data.terraform_remote_state.primary.outputs.source_private_route_table_id

  destination_cidr_block = aws_vpc.dr.cidr_block

  vpc_peering_connection_id = aws_vpc_peering_connection.source_to_dr.id

  depends_on = [
    aws_vpc_peering_connection_accepter.dr
  ]
}


### DR ROUTE
### ap-southeast-7 -> us-east-1

resource "aws_route" "dr_to_source" {
  provider = aws.dr

  route_table_id = aws_route_table.dr_private.id

  destination_cidr_block = data.terraform_remote_state.primary.outputs.source_vpc_cidr

  vpc_peering_connection_id = aws_vpc_peering_connection.source_to_dr.id

  depends_on = [
    aws_vpc_peering_connection_accepter.dr
  ]
}