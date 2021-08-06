locals {

  SOURCE = "Source"
  BUILD = "Build"
  DEPLOY = "Deploy"

  BUIL_SPECT = "buildspec.yml"

  compilation-policies = [
  for compilation in var.compilations: {
    policies = [
      lookup(
      {for key, value in aws_iam_policy.CodeBuildBasePolicy:  key => value},
      compilation.name,
      "what?")

    ][0]
    ecrAccess = data.aws_iam_policy.ec2fullaccess
    vpc_policie = [
      lookup(
      {for key, value in aws_iam_policy.POLICIE_VPC:  key => value},
      compilation.name,
      "what?")

    ][0]
    name = compilation.name
  }
  ]


}

variable "AWS_ACCOUNT_ID" {
  description = "AWS_ACCOUNT_ID"
  type = string
}

variable "AWS_DEFAULT_REGION" {
  description = "AWS_ACCOUNT_ID"
  type = string
}

variable "vpc" {
  description = "your ECS cluster vpc"
  type = string
}

variable "security-groups" {
  description = "your ECS cluster security groups"
  type = list(string)

}

variable "subnets" {
  description = "Name of the vpc"
  type = list(string)
}

variable compilations {
  description = "El nombre del servicio"
  type = list(map(string))

  default = [
    {
      name = "izziapp-adp-zequenze",
      language = "KOTLIN"
    },
    {
      name = "izziapp-equipos",
      language = "KOTLIN"
    }

  ]
}

variable code-build-branch{
  description = "Github branch to deploy"
  type = string
}

variable cluster-name{
  description = "ECS cluster name"
  type = string
}

variable codestar-id {
  description = "codestar arn"
  type = string
}


variable pipeline-log {
  description = ""
  type = string
}

variable GIT_PROVIDER {
  description = "GIT PROVIDER like https://github.com"
  type = string
}

variable "region" {
  description = "The region in the format us-east-1"
  type = string
}

variable "GIT_HUB_ACCOUNT" {
  description = "Your github account"
  type = string
}



