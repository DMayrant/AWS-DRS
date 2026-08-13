resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.drs.id
  service_name        = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.drs_staging.id]
  security_group_ids  = [aws_security_group.ssm_endpoints.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id              = aws_vpc.drs.id
  service_name        = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.drs_staging.id]
  security_group_ids  = [aws_security_group.ssm_endpoints.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2_messages" {
  vpc_id              = aws_vpc.drs.id
  service_name        = "com.amazonaws.us-east-1.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.drs_staging.id]
  security_group_ids  = [aws_security_group.ssm_endpoints.id]
  private_dns_enabled = true
}