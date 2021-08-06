
output "repositories-created" {
  value = aws_ecr_repository.repositorios
}

output "image-created" {
  value = [
  for listener in var.services: {
    listener = listener.name
    port = listener.port
  }
  ]
}
