output vpc {
  value = local.vpc[var.environment]
}

output subnets {
  value = local.subnets[var.environment]
}

output servicios {
  value = local.servicios[var.environment]
}

output AWS_ACCOUNT_ID {
  value = local.AWS_ACCOUNT_ID[var.environment]
}

output security-groups {
  value = local.security-groups[var.environment]
}

output load-balancer {
  value = local.load-balancer[var.environment]
}


output config-server {
  value = local.config-server[var.environment]
}

output code-build-branch {
  value = local.code-build-branch[var.environment]
}

output cluster-name {
  value = local.cluster-name[var.environment]
}

output GIT_HUB_ACCOUNT {
  value = local.GIT_HUB_ACCOUNT[var.environment]
}

output GIT_PROVIDER {
  value = local.GIT_PROVIDER[var.environment]
}

output codestar-id {
  value = local.codestar-id[var.environment]
}

output pipeline-log {
  value = local.pipeline-log[var.environment]
}