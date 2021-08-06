resource "aws_iam_role" "compilation-roles" {
  for_each = {for target in local.compilation-policies:  target["name"] => target}
  name = "codebuild-${each.key}-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }


    ]
  })
  managed_policy_arns = [
    each.value["policies"]["arn"],
    each.value["ecrAccess"]["arn"],
    each.value["vpc_policie"]["arn"]
  ]
  path = "/service-role/"

  tags = {

  }
}


resource "aws_iam_role" "pipeline-roles" {
  for_each = aws_iam_policy.POLICIE_PIPELINE

  name = "AWSCodePipelineServiceRole-${var.AWS_DEFAULT_REGION}-${each.key}"
  path = "/service-role/"
  managed_policy_arns = [
    each.value["arn"]
  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"

        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
  tags = {

  }
}