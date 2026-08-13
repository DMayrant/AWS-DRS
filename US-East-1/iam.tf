### DRS Replication Server Role

resource "aws_iam_role" "drs_replication_server" {
  name = "AWSElasticDisasterRecoveryReplicationServerRole"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "drs_replication_server" {
  role = aws_iam_role.drs_replication_server.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticDisasterRecoveryReplicationServerPolicy"
}


### DRS Agent Role

resource "aws_iam_role" "drs_agent" {
  name = "AWSElasticDisasterRecoveryAgentRole"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "drs.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "drs_agent" {
  role = aws_iam_role.drs_agent.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticDisasterRecoveryAgentPolicy"
}


### DRS Failback Role

resource "aws_iam_role" "drs_failback" {
  name = "AWSElasticDisasterRecoveryFailbackRole"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "drs.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "drs_failback" {
  role = aws_iam_role.drs_failback.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticDisasterRecoveryFailbackPolicy"
}


### DRS Conversion Server Role

resource "aws_iam_role" "drs_conversion_server" {
  name = "AWSElasticDisasterRecoveryConversionServerRole"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "drs_conversion_server" {
  role = aws_iam_role.drs_conversion_server.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticDisasterRecoveryConversionServerPolicy"
}


### DRS Recovery Instance Role

resource "aws_iam_role" "drs_recovery_instance" {
  name = "AWSElasticDisasterRecoveryRecoveryInstanceRole"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "drs_recovery_instance" {
  role = aws_iam_role.drs_recovery_instance.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticDisasterRecoveryRecoveryInstancePolicy"
}


### DRS Recovery Instance With Launch Actions Role

resource "aws_iam_role" "drs_recovery_launch_actions" {
  name = "AWSElasticDisasterRecoveryRecoveryInstanceWithLaunchActionsRole"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "drs_recovery_launch_actions" {
  role = aws_iam_role.drs_recovery_launch_actions.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticDisasterRecoveryRecoveryInstancePolicy"
}

resource "aws_iam_role_policy_attachment" "drs_recovery_launch_actions_ssm" {
  role = aws_iam_role.drs_recovery_launch_actions.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


### SSM EC2 IAM Role

resource "aws_iam_role" "ssm" {
  name = "drs-nginx-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}


### SSM Policy Attachment

resource "aws_iam_role_policy_attachment" "ssm" {
  role = aws_iam_role.ssm.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


### EC2 Instance Profile

resource "aws_iam_instance_profile" "ssm" {
  name = "drs-nginx-ssm-profile"
  role = aws_iam_role.ssm.name
}


### DRS Agent Installation Policy

resource "aws_iam_user_policy_attachment" "drs_agent_installation" {
  user = "dmay-admin"

  policy_arn = "arn:aws:iam::aws:policy/AWSElasticDisasterRecoveryAgentInstallationPolicy"
}

### DRS Agent IAM Policy Simulation

### DRS Agent IAM Policy Simulation

data "aws_iam_principal_policy_simulation" "drs_agent_permissions" {
  policy_source_arn = "arn:aws:iam::739786453678:user/dmay-admin"

  action_names = [
    "drs:GetAgentInstallationAssetsForDrs",
    "drs:SendAgentMetricsForDrs",
    "drs:SendAgentLogsForDrs"
  ]

  depends_on = [
    aws_iam_user_policy_attachment.drs_agent_installation
  ]
}