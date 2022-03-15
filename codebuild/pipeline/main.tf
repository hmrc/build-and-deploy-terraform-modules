resource "aws_codebuild_project" "codebuild_pipeline" {
  name          = var.codebuild_pipeline_name
  service_role  = aws_iam_role.codebuild_execution_role.arn
  build_timeout = "60"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = var.codebuild_compute_type
    image                       = var.codebuild_image
    type                        = var.codebuild_container_type
    image_pull_credentials_type = var.codebuild_image_pull_credentials_type
  }

  logs_config {
    cloudwatch_logs {}
  }

  source {
    type            = var.codebuild_source_type
    location        = var.codebuild_source_location
    git_clone_depth = 1
    buildspec = var.codebuild_source_buildspec
  }
  source_version = var.codebuild_github_source_branch
  
  vpc_config {
    vpc_id = var.codebuild_vpc_id
    subnets = var.codebuild_subnet_ids
    security_group_ids = [var.codebuild_security_group_id]
  }

  tags = {
    Environment = "Test"
  }
}

resource "aws_codebuild_source_credential" "hmrc_github" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = data.aws_ssm_parameter.github-ro-token.value
}
