# aws-ecs-terraform-automated-service-deploy

This intention of this project is to deploy services on a ECS cluster in AWS

![Alt text](https://ecu-infra-images.s3.us-east-2.amazonaws.com/neo-ecs-infra.drawio.png "Optional title")

This project has 5 modules 

1. Environment : Designed to manage different AWS accounts (one for dev and other for production)
2. [ECR](#ECR) : Creates ECR repository of a service
3. [LOAD_BALANCER](#LOAD_BALANCER) : Take care of listener and target groups of the ECS load balancer 
4. [ECS](#ECS) Creates service and its task definitions
5. [CODE_BUILD](#CODE_BUILD) Manage CI/CD using AWS code pipeline 


### Módules

## <a name="ECR"></a> ECR







```hcl
module "ECR" {
  source = "./modules/ECR"
  repositorios = local.servicios
}
```

Gets an array of servis for being created and exposed

- `repositorios` An array of services

```hcl
[
      {
        name = "dummy-spring-service",
        port = 8127
        task-environment = "dev"
      },
      {
        name = "dummy-python-service",
        port = 8128
        task-environment = "dev"
      }
]
```

## <a name="LOAD_BALANCER"></a> Load Balancer

```hcl
module "LB_MODULE" {
  source = "./modules/LOAD_BALANCER"
  
  vpc-lb = local.vpc
  load-balancer = local.load-balancer
  security-groups = local.security-groups
}
```

- `vpc-lb` La vpc del balanceador
- `load-balancer` El nombre del balanceador
- `security-groups` los security groups al que hacen referencia los target group

## <a name="ECS"></a> ECS

```hcl
module "ECS_MODULE" {

  source = "./modules/ECS"
  security-groups = local.security-groups
  subnets = local.subnets
  vpc = local.vpc
  target-groups = module.LB_MODULE.target-groups
  services = local.servicios
  cluster = local.cluster
  AWS_ACCOUNT_ID = local.AWS_ACCOUNT_ID
  config-server = local.config-server
}
```

## <a name="CODE_BUILD"></a> CODE BUILD

```hcl
module "CODE_BUILD" {

  source = "./modules/CODE_BUILD"
  AWS_ACCOUNT_ID = local.AWS_ACCOUNT_ID
  AWS_DEFAULT_REGION = var.region
  security-groups = local.security-groups
  subnets = local.subnets
  vpc = local.vpc
  compilations = local.servicios
  subnet-arn = local.subnet-arn
  code-build-branch = local.code-build-branch
  cluster-name = local.cluster-name
  codestar-arn = local.codestar-arn
}
```





