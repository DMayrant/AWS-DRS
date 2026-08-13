resource "aws_security_group" "drs_replication" {
  provider = aws.dr

  name        = "drs-replication-sg"
  description = "Security group for AWS DRS replication servers"
  vpc_id      = aws_vpc.dr.id

  tags = {
    Name        = "drs-replication-sg"
    Environment = "disaster-recovery"
  }
}

############################
# Replication Sever TCP 1500
###########################

resource "aws_vpc_security_group_ingress_rule" "drs_replication" {
  provider = aws.dr

  security_group_id = aws_security_group.drs_replication.id

  cidr_ipv4   = "10.177.0.0/16"
  from_port   = 1500
  to_port     = 1500
  ip_protocol = "tcp"

  description = "DRS replication traffic from source network"
}
################
# Outbound HTTPS
################
resource "aws_vpc_security_group_egress_rule" "drs_https" {
  provider = aws.dr

  security_group_id = aws_security_group.drs_replication.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  description = "HTTPS to AWS DRS service"
}