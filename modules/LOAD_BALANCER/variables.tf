locals {
  target-groups = aws_lb_target_group.target-groups

  names = [
  for key, value in var.services : [
    value.name
  ]
  ]

  targets = [
  for listener in var.services: {
    listener = listener.name
    arn = try(lookup(aws_lb_target_group.target-groups, listener.name, "what?").arn, "")
    port = listener.port
  }
  ]
}

variable vpc-lb {
  description = "La vpc donde está el target group"
  type = string
}

variable security-groups {
  description = "El security group asociado al balanceador"
  type = list(string)
}

variable services {
  description = "El nombre y puerto de los listeners"
  type = list(map(string))

  default = [
    {
      name = "izziapp-adp-zequenze",
      port = 8127
    },
    {
      name = "izziapp-equipos",
      port = 8128
    }

  ]
}

variable load-balancer {
  type = string
}




