resource "aws_drs_replication_configuration_template" "drs" {
  associate_default_security_group = false
  bandwidth_throttling             = 0
  create_public_ip                 = false
  data_plane_routing               = "PRIVATE_IP"
  default_large_staging_disk_type  = "GP3"
  ebs_encryption                   = "DEFAULT"

  replication_server_instance_type = "t3.large"

  replication_servers_security_groups_ids = [
    aws_security_group.drs_source.id
  ]

  staging_area_subnet_id = aws_subnet.drs_staging.id

  staging_area_tags = {
    Name        = "aws-drs-staging"
    Environment = "disaster-recovery"
  }

  use_dedicated_replication_server = false

  pit_policy {
    enabled            = true
    interval           = 10
    retention_duration = 60
    rule_id            = 1
    units              = "MINUTE"
  }

  pit_policy {
    enabled            = true
    interval           = 1
    retention_duration = 24
    rule_id            = 2
    units              = "HOUR"
  }

  pit_policy {
    enabled            = true
    interval           = 1
    retention_duration = 7
    rule_id            = 3
    units              = "DAY"
  }

  depends_on = [
    aws_iam_role_policy_attachment.drs_replication_server
  ]

  tags = {
    Name        = "drs-replication-template"
    Environment = "disaster-recovery"
  }
}