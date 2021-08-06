
resource "aws_codebuild_project" "code-compilations" {
  for_each = aws_iam_role.compilation-roles
  name = each.key
  service_role = each.value["arn"]
  source_version = "refs/heads/${var.code-build-branch}"
  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    modes = []
    type = "NO_CACHE"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    privileged_mode = true
    image = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type = "LINUX_CONTAINER"

    environment_variable {
      name = "AWS_DEFAULT_REGION"
      type = "PLAINTEXT"
      value = var.AWS_DEFAULT_REGION
    }
    environment_variable {
      name = "AWS_ACCOUNT_ID"
      type = "PLAINTEXT"
      value = var.AWS_ACCOUNT_ID
    }

    environment_variable {
      name = "IMAGE_REPO_NAME"
      type = "PLAINTEXT"
      value = each.key
    }

    environment_variable {
      name = "IMAGE_TAG"
      type = "PLAINTEXT"
      value = "latest"
    }

  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status = "DISABLED"
    }
  }


  source {
    buildspec = local.BUIL_SPECT
    git_clone_depth = 1
    insecure_ssl = false
    location = "${var.GIT_PROVIDER}${var.GIT_HUB_ACCOUNT}/${each.key}.git"
    report_build_status = false
    type = "GITHUB"

    git_submodules_config {
      fetch_submodules = false
    }
  }

  vpc_config {
    security_group_ids = var.security-groups
    subnets = var.subnets
    vpc_id = var.vpc
  }

  tags ={}
}


