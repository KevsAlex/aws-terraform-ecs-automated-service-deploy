/**
Crea lass políticas necesariass para el proyecto de compilacion
**/

resource "aws_iam_policy" "POLICIE_PIPELINE" {
  for_each = {
  for compilation in var.compilations:  compilation.name => compilation
  }

  tags        = {}
  tags_all    = {}
  name        = "AWSCodePipelineServiceRole-${var.AWS_DEFAULT_REGION}-${each.key}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodePipeline"

  policy = file("${path.module}/pipeline-policie.json")
}

data aws_iam_policy ec2fullaccess{
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_policy" "POLICIE_VPC" {
  for_each = {
  for compilation in var.compilations:  compilation.name => compilation
  }

  tags        = {}
  tags_all    = {}
  name        = "CodeBuildVpcPolicy-${each.key}-${var.AWS_DEFAULT_REGION}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateNetworkInterfacePermission",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [

          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages",
        ]
        Resource  = [
          "arn:aws:ec2:us-east-1:us-east-1:network-interface/*",
        ]
        Effect   = "Allow"
        Condition = {
          StringEquals = {

            "ec2:Subnet" = [
              "arn:aws:ec2:${var.region}:${var.AWS_ACCOUNT_ID}:subnet/${var.subnets[0]}",
              "arn:aws:ec2:${var.region}:${var.AWS_ACCOUNT_ID}:subnet/${var.subnets[1]}"
            ],
            "ec2:AuthorizedService": "codebuild.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "CodeBuildBasePolicy" {
  for_each = {
  for compilation in var.compilations:  compilation.name => compilation
  }

  tags        = {}
  tags_all    = {}
  name        = "CodeBuildBasePolicy-${each.key}-${var.AWS_DEFAULT_REGION}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:logs:us-east-1:${var.AWS_ACCOUNT_ID}:log-group:/aws/codebuild/${each.key}",
          "arn:aws:logs:us-east-1:${var.AWS_ACCOUNT_ID}:log-group:/aws/codebuild/${each.key}:*"
        ]
      },
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::codepipeline-${var.AWS_DEFAULT_REGION}-*",
        ]
      },
      {
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:codebuild:us-east-1:683410843871:report-group/${each.key}-*"
        ]
      }
    ]
  })
}