resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/codebuild/${var.codebuild_pipeline_name}"
  retention_in_days = 14
}