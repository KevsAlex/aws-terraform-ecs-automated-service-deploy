
resource "aws_ecs_service" "ecs-services" {
  for_each = {for target in local.task-target:  target["name"] => target  }
  name = each.key
  cluster = "arn:aws:ecs:${var.region}:${var.AWS_ACCOUNT_ID}:cluster/${var.cluster}"
  task_definition = "${each.key}:${each.value["task"]["revision"]}"
  desired_count = 1
  launch_type = "FARGATE"
  health_check_grace_period_seconds = 300

  deployment_controller {
    type = "ECS"
  }
  deployment_circuit_breaker {
    enable = false
    rollback = false
  }


  load_balancer {
    container_name = each.key

    container_port = each.value["port"]["port"]
    target_group_arn = each.value["target"]["arn"]
  }

  network_configuration {
    security_groups = var.security-groups
    subnets = var.subnets
  }

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }

  depends_on = [aws_ecs_task_definition.task-definitions]

}

