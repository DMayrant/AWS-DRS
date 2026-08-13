###################################
# AZ US-East-1 (primary region)
###################################
data "aws_availability_zones" "primary" {
  state = "available"
}

###################################
# AZ AP-southeast-7 (DR Region)
###################################
data "aws_availability_zones" "dr" {
  provider = aws.dr
  state    = "available"
}