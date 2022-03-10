data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ssm_parameter" "github-ro-token" {
  name = var.github-ro-token
}
