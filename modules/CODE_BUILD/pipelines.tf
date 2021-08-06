data "aws_codestarconnections_connection" "izziGit" {

  arn = "arn:aws:codestar-connections:${var.region}:${var.AWS_ACCOUNT_ID}:connection/${var.codestar-id}"

}

resource "aws_codepipeline" "izziapp-adp-zequenze" {
  for_each = aws_iam_role.pipeline-roles
  name = each.key
  role_arn = each.value.arn

  artifact_store {
    location = "codepipeline-${var.AWS_DEFAULT_REGION}-${var.pipeline-log}"
    type = "S3"
  }

  stage {
    name = local.SOURCE

    action {

      name = local.SOURCE

      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = data.aws_codestarconnections_connection.izziGit.arn
        FullRepositoryId = "${var.GIT_HUB_ACCOUNT}/${each.key}"
        BranchName       = var.code-build-branch
      }
    }
  }

  stage {
    name = local.BUILD

    action {
      name = local.BUILD
      namespace = "BuildVariables"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = [
        "source_output"]
      output_artifacts = [
        "BuildArtifact"]
      version = "1"

      configuration = {
        ProjectName = each.key
        EnvironmentVariables = jsonencode([
          {
            name  = "AWS_ACCOUNT_ID"
            type  = "PLAINTEXT"
            value = var.AWS_ACCOUNT_ID
          },
          {
            name  = "IMAGE_REPO_NAME"
            type  = "PLAINTEXT"
            value = each.key
          },
          {
            name  = "IMAGE_TAG"
            type  = "PLAINTEXT"
            value = "latest"
          },
          {
            name: "CONT_NAME",
            type  = "PLAINTEXT"
            value: each.key
          }
        ])
      }
    }
  }

  stage {
    name = local.DEPLOY

    action {
      name = local.DEPLOY
      namespace = "DeployVariables"
      category = "Deploy"
      owner = "AWS"
      provider = "ECS"
      input_artifacts = [
        "BuildArtifact"]
      version = "1"

      configuration = {

        ClusterName = var.cluster-name
        ServiceName = each.key

      }
    }
  }
}

