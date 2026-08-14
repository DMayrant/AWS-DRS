###################################
# AP-Southeast-7 Staging Subnet
###################################

resource "aws_subnet" "drs_staging" {
  provider = aws.dr

  vpc_id                  = aws_vpc.dr.id
  cidr_block              = "10.200.50.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "drs-staging-subnet"
    Environment = "disaster-recovery"
    Region      = "ap-southeast-1"
    Purpose     = "DRS-Staging"
  }
}

###################################
# AP-Southeast-7 Recovery Subnet
###################################

resource "aws_subnet" "drs_recovery" {
  provider = aws.dr

  vpc_id                  = aws_vpc.dr.id
  cidr_block              = "10.200.40.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name        = "drs-recovery-subnet"
    Environment = "disaster-recovery"
    Region      = "ap-southeast-1"
    Purpose     = "DRS-Recovery"
  }
}