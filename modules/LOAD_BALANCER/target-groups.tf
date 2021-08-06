
resource "aws_lb_target_group" "target-groups" {
  for_each = {
    for listener in var.services:  listener.name => listener
  }
  name = "${each.key}-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc-lb
  target_type = "ip"
  protocol_version                   = "HTTP1"
  tags              = {}
  tags_all          = {}
  load_balancing_algorithm_type = "round_robin"

  health_check {
    enabled = true
    healthy_threshold = 5
    unhealthy_threshold = 2
    path = "/healthCheck"
  }
}