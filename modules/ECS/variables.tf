#MY Locals
locals {

  names = {for target in var.services:  target.name => target  }

  target-port = [
  for key, value in var.target-groups: {
    name = key
    target = value
    port = lookup(local.names, key, "what?")
  }
  ]

  task-target = [
  for key, value in var.target-groups: {
    name = key
    target = value
    port = lookup(local.names, key, "what?")
    task = lookup(aws_ecs_task_definition.task-definitions, key, "what?")
  }
  ]

  load-balancer-name = "microservices-dev"
}

variable target-groups {
  description = "Target group associated to load balancer"
  type = any
}

variable services {
  description = "Service name and port in which it will run"
  type = list(map(string))

  default = [
    {
      name = "spring-service-example",
      port = 8127
    },
    {
      name = "spring-service-example",
      port = 8128
    }

  ]
}


variable "cluster" {
  description = "Cluster name"
  type = string
}

variable "vpc" {
  description = "Name of the vpc"
  type = string
}

variable security-groups {
  description = "Security groups"
  type = list(string)
}

variable AWS_ACCOUNT_ID{
  description = "AWS account ID"
  type = string
}

variable config-server{
  description = "In case a config server its been used , set the url here"
  type = string
}

variable subnets {
  description = "Subnets assotiated with ECS cluster"
  type = list(string)
}

variable "region" {
  description = "The region ex . us-east-1"
  type = string

}



