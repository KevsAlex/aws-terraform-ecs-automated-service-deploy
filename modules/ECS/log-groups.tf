
resource "aws_cloudwatch_log_group" log-groups {
  for_each = {for target in local.target-port:  target["name"] => target  }
  name = "/ecs/${each.key}"
  retention_in_days = 0
  tags = {

  }
}