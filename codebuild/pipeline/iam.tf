resource "aws_iam_role" "codebuild_execution" {
  name = var.codebuild_pipeline_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "logging" {
  name   = "logging"
  role   = aws_iam_role.codebuild_execution.id
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "ssm:GetParameters" 
          ]
          Effect   = "Allow"
          Resource = "${aws_cloudwatch_log_group.main.arn}:*"
        },
      ]
    }
  )
}
