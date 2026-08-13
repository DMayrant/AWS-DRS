resource "aws_vpc" "dr" {
  provider = aws.dr

  cidr_block           = "10.200.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "drs-dr-vpc"
    Environment = "disaster-recovery"
  }
}

### DR PRIVATE ROUTE TABLE
### ap-southeast-7

resource "aws_route_table" "dr_private" {
  provider = aws.dr

  vpc_id = aws_vpc.dr.id

  tags = {
    Name        = "drs-dr-private-rt"
    Environment = "disaster-recovery"
  }
}


### DRS STAGING SUBNET ASSOCIATION

resource "aws_route_table_association" "drs_staging" {
  provider = aws.dr

  subnet_id      = aws_subnet.drs_staging.id
  route_table_id = aws_route_table.dr_private.id
}


### DRS RECOVERY SUBNET ASSOCIATION

resource "aws_route_table_association" "drs_recovery" {
  provider = aws.dr

  subnet_id      = aws_subnet.drs_recovery.id
  route_table_id = aws_route_table.dr_private.id
}