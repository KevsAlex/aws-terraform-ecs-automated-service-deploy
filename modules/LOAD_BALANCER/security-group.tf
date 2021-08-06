
resource "aws_security_group_rule" "service-port" {
  for_each = {
    for listener in var.services:  listener.name => listener
  }
  type              = "ingress"
  to_port           = each.value["port"]
  protocol          = "tcp"
  from_port         = each.value["port"]
  security_group_id = var.security-groups[0]
  cidr_blocks = ["0.0.0.0/0"]
  description = each.key
}