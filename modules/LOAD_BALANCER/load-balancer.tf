
data "aws_lb" "microservices-lb" {
  name = var.load-balancer
}

resource "aws_lb_listener" "listeners" {
  for_each = {for target in local.targets:  target["listener"] => target  }
  load_balancer_arn = data.aws_lb.microservices-lb.arn
  port = each.value["port"]

  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = each.value["arn"]
  }

  depends_on = [aws_lb_target_group.target-groups]
}