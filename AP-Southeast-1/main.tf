########################################
# DR VPC
# ap-southeast-1 - Singapore
########################################

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


########################################
# DR INTERNET GATEWAY
########################################

resource "aws_internet_gateway" "dr" {
  provider = aws.dr

  vpc_id = aws_vpc.dr.id

  tags = {
    Name        = "drs-dr-igw"
    Environment = "disaster-recovery"
  }
}


########################################
# DR PUBLIC SUBNET
# Hosts NAT Gateway
########################################

resource "aws_subnet" "dr_public" {
  provider = aws.dr

  vpc_id                  = aws_vpc.dr.id
  cidr_block              = "10.200.10.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "drs-dr-public-subnet"
    Environment = "disaster-recovery"
  }
}


########################################
# DR PUBLIC ROUTE TABLE
########################################

resource "aws_route_table" "dr_public" {
  provider = aws.dr

  vpc_id = aws_vpc.dr.id

  tags = {
    Name        = "drs-dr-public-rt"
    Environment = "disaster-recovery"
  }
}


########################################
# PUBLIC INTERNET ROUTE
########################################

resource "aws_route" "dr_public_internet" {
  provider = aws.dr

  route_table_id         = aws_route_table.dr_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dr.id
}


########################################
# PUBLIC SUBNET ROUTE TABLE ASSOCIATION
########################################

resource "aws_route_table_association" "dr_public" {
  provider = aws.dr

  subnet_id      = aws_subnet.dr_public.id
  route_table_id = aws_route_table.dr_public.id
}


########################################
# NAT GATEWAY ELASTIC IP
########################################

resource "aws_eip" "dr_nat" {
  provider = aws.dr

  domain = "vpc"

  tags = {
    Name        = "drs-dr-nat-eip"
    Environment = "disaster-recovery"
  }
}


########################################
# NAT GATEWAY
########################################

resource "aws_nat_gateway" "dr" {
  provider = aws.dr

  allocation_id = aws_eip.dr_nat.id
  subnet_id     = aws_subnet.dr_public.id

  depends_on = [
    aws_internet_gateway.dr
  ]

  tags = {
    Name        = "drs-dr-nat"
    Environment = "disaster-recovery"
  }
}


########################################
# DR PRIVATE ROUTE TABLE
########################################

resource "aws_route_table" "dr_private" {
  provider = aws.dr

  vpc_id = aws_vpc.dr.id

  tags = {
    Name        = "drs-dr-private-rt"
    Environment = "disaster-recovery"
  }
}


########################################
# PRIVATE SUBNET INTERNET EGRESS
#
# DRS replication servers need outbound
# connectivity to AWS services over HTTPS.
########################################

resource "aws_route" "dr_private_nat" {
  provider = aws.dr

  route_table_id         = aws_route_table.dr_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.dr.id
}

########################################
# DRS STAGING SUBNET ASSOCIATION
########################################

resource "aws_route_table_association" "drs_staging" {
  provider = aws.dr

  subnet_id      = aws_subnet.drs_staging.id
  route_table_id = aws_route_table.dr_private.id
}


########################################
# DRS RECOVERY SUBNET ASSOCIATION
########################################

resource "aws_route_table_association" "drs_recovery" {
  provider = aws.dr

  subnet_id      = aws_subnet.drs_recovery.id
  route_table_id = aws_route_table.dr_private.id
}