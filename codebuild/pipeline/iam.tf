resource "aws_iam_role" "codebuild_execution_role" {
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

resource "aws_iam_role_policy" "codebuild_execution_policy" {
  name   = var.codebuild_pipeline_name
  role   = aws_iam_role.codebuild_execution_role.id
  policy = data.aws_iam_policy_document.codebuild_execution_policy_document.json
}


data "aws_iam_policy_document" "codebuild_execution_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.main.arn}:*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeDhcpOptions",
    ]

    resources = [
      "*",
    ] 
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterfacePermission"
    ]

    resources = [
      "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:network-interface/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:Subnet"

      values = [
        "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:subnet/${var.codebuild_subnet_ids[0]}",
        "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:subnet/${var.codebuild_subnet_ids[1]}",
        "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:subnet/${var.codebuild_subnet_ids[2]}"
      ]
    }
  }
}