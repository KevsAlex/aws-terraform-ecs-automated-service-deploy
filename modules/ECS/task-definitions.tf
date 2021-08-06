
resource "aws_ecs_task_definition" task-definitions {
  for_each = {for target in local.target-port:  target["name"] => target  }
  family = each.key
  task_role_arn = "arn:aws:iam::${var.AWS_ACCOUNT_ID}:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name = each.key
      image = "${var.AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${each.key}:latest"
      cpu = 10
      memory = 512
      essential = true
      portMappings = [
        {
          protocol = "tcp"
          containerPort = tonumber(each.value["port"]["port"])
          hostPort = tonumber(each.value["port"]["port"])
        }
      ]
      logConfiguration: {
        logDriver: "awslogs",
        secretOptions: null,
        options: {
          awslogs-group: "/ecs/${each.key}",
          awslogs-region: "us-east-1",
          awslogs-stream-prefix: "ecs"
        }
      }

      environment: [
        {
          name: "CONFIG_SERVER_URL_PROFILE",
          value: each.value["port"]["task-environment"]
        },
        {
          name: "CONFIG_SERVER_URL",
          value: var.config-server
        },
        {
          name: "CONT_NAME",
          value: each.key
        }

      ]

    }
  ])
  requires_compatibilities = [
    "FARGATE"
  ]
  cpu = "512"
  execution_role_arn = "arn:aws:iam::${var.AWS_ACCOUNT_ID}:role/ecsTaskExecutionRole"//var.taskExecutionRole
  memory = "1024"
  network_mode = "awsvpc"
  tags = {}

  depends_on = [aws_cloudwatch_log_group.log-groups]
}