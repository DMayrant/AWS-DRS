########################
# ALB SECURITY GROUP
########################

resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.drs.id

  tags = {
    Name        = "alb-sg"
    Environment = "production"
  }
}

########################
# Internet -> ALB
# HTTP 80
########################

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTP from Internet"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}
########################
# Internet -> ALB
# HTTPS 443
########################

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTPS from Internet"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

########################
# ALB EGRESS
########################

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb.id

  description = "Allow outbound traffic from ALB"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

################################################
# DRS SOURCE / APPLICATION SERVER SECURITY GROUP
################################################

resource "aws_security_group" "drs_source" {
  name        = "drs-source-sg"
  description = "Security group for DRS source application servers"
  vpc_id      = aws_vpc.drs.id

  tags = {
    Name        = "drs-source-sg"
    Environment = "production"
  }
}


################################################
# ALB -> SOURCE SERVERS
# HTTP 80
#
# IMPORTANT:
# Only the ALB security group can reach NGINX on port 80.
################################################

resource "aws_vpc_security_group_ingress_rule" "drs_source_from_alb" {
  security_group_id            = aws_security_group.drs_source.id
  description                  = "Allow HTTP from ALB"
  referenced_security_group_id = aws_security_group.alb.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}


########################
# SOURCE SERVER -> HTTPS
# SSM / AWS APIs
########################

resource "aws_vpc_security_group_egress_rule" "drs_source_https" {
  security_group_id = aws_security_group.drs_source.id

  description = "HTTPS for SSM and AWS services"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}


############################################################################
# SOURCE SERVER -> DRS REPLICATION NETWORK
# TCP 1500
# 10.177.0.0/16 is the main VPV CIDR containing your DRS replication resources.
##############################################################################

resource "aws_vpc_security_group_egress_rule" "drs_source_replication" {
  security_group_id = aws_security_group.drs_source.id

  description = "DRS replication traffic"

  cidr_ipv4   = "10.177.0.0/16"
  from_port   = 1500
  to_port     = 1500
  ip_protocol = "tcp"
}


################################################
# DRS REPLICATION SERVER SECURITY GROUP
################################################

resource "aws_security_group" "drs_replication" {
  name        = "drs-replication-sg"
  description = "Security group for AWS DRS replication servers"
  vpc_id      = aws_vpc.drs.id

  tags = {
    Name        = "drs-replication-sg"
    Environment = "dr"
  }
}


################################################
# SOURCE SERVER -> DRS REPLICATION SERVER
# TCP 1500
################################################

resource "aws_vpc_security_group_ingress_rule" "drs_replication" {
  security_group_id = aws_security_group.drs_replication.id

  description = "DRS replication traffic from source servers"

  referenced_security_group_id = aws_security_group.drs_source.id

  from_port   = 1500
  to_port     = 1500
  ip_protocol = "tcp"
}


##############################
# DRS REPLICATION SERVER -> HTTPS
# AWS DRS APIs / AWS SERVICES
##############################

resource "aws_vpc_security_group_egress_rule" "drs_https" {
  security_group_id = aws_security_group.drs_replication.id

  description = "HTTPS access to AWS services"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

#####################################
# SSM VPC ENDPOINT SECURITY GROUP
###################################

resource "aws_security_group" "ssm_endpoints" {
  name        = "ssm-endpoints-sg"
  description = "Security group for SSM VPC endpoints"
  vpc_id      = aws_vpc.drs.id

  tags = {
    Name        = "ssm-endpoints-sg"
    Environment = "production"
  }
}


################################################
# SOURCE SERVERS -> SSM INTERFACE ENDPOINTS
# TCP 443
################################################

resource "aws_vpc_security_group_ingress_rule" "ssm_https" {
  security_group_id = aws_security_group.ssm_endpoints.id

  description = "HTTPS from DRS source servers"

  referenced_security_group_id = aws_security_group.drs_source.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}