provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source          = "../../../modules/vpc"
  vpc_name        = var.vpc_name
  cidr_block      = var.vpc_cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}
module "iam" {
  source = "../../../modules/iam"
  # add any required variables
}

module "alb" {
  source            = "../../../modules/alb"
  name              = "devops-app"
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnets
  security_group_id = module.alb.alb_security_group_id


}


module "ecr" {
  source = "../../../modules/ecr"

  ecr_repo_names = var.ecr_repo_names
}

resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "Allow traffic to backend container"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # You can lock this down
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "frontend_sg" {
  name        = "frontend-sg"
  description = "Allow traffic to frontend container"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "frontend_ecs" {
  source             = "../../../modules/ecs"
  cluster_name       = "my-frontend-cluster"
  task_family        = "frontend-task"
  service_name       = "frontend-service"
  container_name     = "frontend"
  container_image    = var.frontend_image
  container_port     = 80
  cpu                = 256
  memory             = 512
  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn
  subnets            = module.vpc.private_subnets
  security_group_id  = aws_security_group.frontend_sg.id
  desired_count      = 1
  target_group_arn   = module.alb.frontend_target_group_arn
  lb_listener        = module.alb.listener

}

module "backend_ecs" {
  source             = "../../../modules/ecs"
  cluster_name       = "my-backend-cluster"
  task_family        = "backend-task"
  service_name       = "backend-service"
  container_name     = "backend"
  container_image    = var.backend_image
  container_port     = 8000
  cpu                = 512
  memory             = 1024
  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn
  subnets            = module.vpc.private_subnets
  security_group_id  = aws_security_group.backend_sg.id
  desired_count      = 1
  target_group_arn   = module.alb.backend_target_group_arn
  lb_listener        = module.alb.listener

}




