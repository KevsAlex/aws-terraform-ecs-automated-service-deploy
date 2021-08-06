resource "aws_ecr_repository" "repositorios" {

  for_each = {
  for vm in var.services:  vm.name => vm
  }
  name = each.key
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
     encryption_type = "AES256"
  }
  image_scanning_configuration {
    scan_on_push = false
  }
}

