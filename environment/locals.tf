locals {
  environments = {
    dev = "dev"
    prod = "prod"
  }

  vpc = {
    dev = "vpc-XXXXX"
    prod = "vpc-XXXX"
  }

  servicios = {
    dev = [
      {
        name = "my-cool-service",
        port = 8127
        task-environment = "dev"
      },
      {
        name = "my-cool-service-2",
        port = 8128
        task-environment = "dev"
      }
    ]

    prod = [
      {
        name = "my-cool-service",
        port = 8127
        task-environment = "prod"
      },
      {
        name = "my-cool-service-2",
        port = 8128
        task-environment = "prod"
      }

    ]
  }

  subnets = {
    dev = [
      "subnet-XXXXXXXXXXXXX",
      "subnet-XXXXXXXXXXXXX",
    ]

    prod = [
      "subnet-XXXXXXXXXXXXX",
      "subnet-XXXXXXXXXXXXX",
    ]
  }

  AWS_ACCOUNT_ID = {
    dev = "XXXXXXXXXX"
    prod = "XXXXXXXXXXX"
  }

  security-groups = {
    dev = [
      "sg-XXXXX"
    ]
    prod = [
      "sg-XXXX"
    ]
  }

  load-balancer = {
    dev = "load-balancer-name"
    prod = "load-balancer-name"

  }

  cluster-name = {
    dev = "ecs-clusster-name"
    prod = "ecs-clusster-name"
  }

  config-server = {
    dev = "http://config-service-url(if any):8003/"
    prod = "http://config-service-url(if any):8003/"
  }

  code-build-branch = {
    dev = "aws-dev"
    prod = "master"
  }

  codestar-id = {
    dev = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX"
    prod = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX"
  }

  pipeline-log = {
    dev = "XXXXXXX"
    prod = "XXXXXXX"
  }

  GIT_PROVIDER = {
    dev = "https://github.com/",
    prod = "https://github.com/"
  }

  GIT_HUB_ACCOUNT = {
    dev = "YOUR-GIT-ACCOUNT-HERE",
    prod = "kevsAlex"
  }



}