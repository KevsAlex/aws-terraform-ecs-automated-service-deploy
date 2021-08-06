
output "test-variable" {

  value = [
  for key, value in var.target-groups: {
    name = key
    target = value
    port = lookup(local.names, key, "nofFound")
    task = lookup(aws_ecs_task_definition.task-definitions, key, "notFound")
  }
  ]
}
