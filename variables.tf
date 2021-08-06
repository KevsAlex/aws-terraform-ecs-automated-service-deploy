locals {
  servicios = module.ENV.servicios
  vpc = module.ENV.vpc
  security-groups = module.ENV.security-groups
  subnets = module.ENV.subnets
  AWS_ACCOUNT_ID = module.ENV.AWS_ACCOUNT_ID
  load-balancer = module.ENV.load-balancer
  config-server = module.ENV.config-server
  code-build-branch = module.ENV.code-build-branch
  cluster-name = module.ENV.cluster-name
  codestar-id = module.ENV.codestar-id
  pipeline-log = module.ENV.pipeline-log
  GIT_HUB_ACCOUNT = module.ENV.GIT_HUB_ACCOUNT
  GIT_PROVIDER = module.ENV.GIT_PROVIDER
}

variable "region" {
  default = "us-east-1"
}


