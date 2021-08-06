module "ENV" {
  source = "./environment"
  environment = "prod"
}

/**
Creates the ECR repository given a list of services
*/
module "ECR" {
  source = "./modules/ECR"
  services = local.servicios
}

/*
Creates target groups and listeners
*/
module "LB_MODULE" {
  source = "./modules/LOAD_BALANCER"
  services = local.servicios
  vpc-lb = local.vpc
  load-balancer = local.load-balancer
  security-groups = local.security-groups
}

/*
Creates task defiinition and service in a ecs cluster
*/
module "ECS_MODULE" {

  source = "./modules/ECS"
  security-groups = local.security-groups
  subnets = local.subnets
  vpc = local.vpc
  target-groups = module.LB_MODULE.target-groups
  services = local.servicios
  cluster = local.cluster-name
  AWS_ACCOUNT_ID = local.AWS_ACCOUNT_ID
  config-server = local.config-server
  region = var.region
}

/*
Creates codebuild proyect and codepipeline proyect
*/

module "CODE_BUILD" {

  source = "./modules/CODE_BUILD"
  AWS_ACCOUNT_ID = local.AWS_ACCOUNT_ID
  AWS_DEFAULT_REGION = var.region
  security-groups = local.security-groups
  subnets = local.subnets
  vpc = local.vpc
  compilations = local.servicios
  code-build-branch = local.code-build-branch
  cluster-name = local.cluster-name
  codestar-id = local.codestar-id
  pipeline-log = local.pipeline-log
  GIT_HUB_ACCOUNT = local.GIT_HUB_ACCOUNT
  GIT_PROVIDER = local.GIT_PROVIDER
  region = var.region


}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.47.0"
    }
  }

  backend "s3" {

    key = "terraform.tfstate"

  }

}


provider "aws" {
  profile = "default"
  region = var.region
}




