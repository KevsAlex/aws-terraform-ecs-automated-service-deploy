output "compilation-policies" {

  value = [
  for compilation in var.compilations: {
    policies = [
      lookup(
      {for key,value in aws_iam_policy.CodeBuildBasePolicy:  key => value},
      compilation.name,
      "what?")

    ][0]
    ecrAccess = data.aws_iam_policy.ec2fullaccess
    name = compilation.name
    vpc_policie = [
      lookup(
      {for key, value in aws_iam_policy.POLICIE_VPC:  key => value},
      compilation.name,
      "what?")

    ][0]
   }
  ]
}



output "compilation-roles" {
  value = aws_iam_role.compilation-roles
}

output "pipeline-roles" {
  value = aws_iam_role.pipeline-roles
}

output "pipeline-policies" {
  value = aws_iam_policy.POLICIE_PIPELINE
}

