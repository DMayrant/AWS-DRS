#############
# DRS VPC
#############

resource "aws_vpc" "drs" {
  cidr_block = "10.177.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "disaster-recovery-vpc"
  }
}
####################
# Internet Gateway
####################

resource "aws_internet_gateway" "drs" {
  vpc_id = aws_vpc.drs.id

  tags = {
    Name = "drs-igw"
  }
}

#############################
# Public Subnet for NAT
#############################

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.drs.id
  cidr_block              = "10.177.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "drs-public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.drs.id
  cidr_block        = "10.177.5.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "drs-public-subnet-2"
  }
}

##############################
# Public Route Table
# Public Subnet -> Internet Gateway
##############################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.drs.id

  tags = {
    Name = "drs-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.drs.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

##############################
# Elastic IP for NAT Gateway
##############################

resource "aws_eip" "nat" {
  domain = "vpc"

  depends_on = [
    aws_internet_gateway.drs
  ]

  tags = {
    Name = "drs-nat-eip"
  }
}

################
# NAT Gateway
################

resource "aws_nat_gateway" "drs" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id

  depends_on = [
    aws_internet_gateway.drs
  ]

  tags = {
    Name = "drs-nat-gateway"
  }
}

##############################
# Private Route Table
##############################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.drs.id

  tags = {
    Name = "drs-private-rt"
  }
}

################
# Private Subnet
#################

resource "aws_subnet" "drs_staging" {
  vpc_id            = aws_vpc.drs.id
  cidr_block        = "10.177.50.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "drs-staging-subnet"
  }
}

##############################
# Private Subnet -> NAT Gateway
##############################

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.drs.id
}

############################################################
# Associate Private Route Table with DRS Staging Subnet
############################################################

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.drs_staging.id
  route_table_id = aws_route_table.private.id
}