resource "aws_instance" "source" {
  ami           = data.aws_ami.amazon_linux.id
  count         = 5
  instance_type = "t3.large"
  subnet_id     = aws_subnet.drs_staging.id

  iam_instance_profile = aws_iam_instance_profile.ssm.name

  vpc_security_group_ids = [
    aws_security_group.drs_source.id
  ]

  tags = {
    Name        = "drs-source-server-${count.index + 1}"
    Environment = "production"
  }
}
