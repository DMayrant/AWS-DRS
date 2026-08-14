resource "aws_wafv2_web_acl" "alb_waf" {
  name        = "alb-web-acl"
  description = "WAF protecting Application Load Balancer"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  ########################################
  # Rule 1: AWS Managed OWASP Protection
  ########################################
  rule {
    name     = "AWSManagedCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  ########################################
  # Rule 2: SQL Injection Protection
  ########################################
  rule {
    name     = "AWSManagedSQLiRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLiProtection"
      sampled_requests_enabled   = true
    }
  }

  ########################################
  # Rule 3: Rate Limiting (DDoS-lite)
  ########################################
  rule {
    name     = "RateLimitRule"
    priority = 3

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit"
      sampled_requests_enabled   = true
    }
  }

  ########################################
  # Logging + Metrics
  ########################################
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ALBWebACL"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "ALB-WAF"
  }
}

resource "aws_wafv2_web_acl_association" "alb_waf_association" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.alb_waf.arn
}

