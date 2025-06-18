module "acm" {
  source = "../../../modules/acm"

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
}

module "alb" {
  source              = "../../../modules/alb"
  name                = "devops-app"
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnets
  acm_certificate_arn = module.acm.acm_certificate_arn



}

module "ecr" {
  source = "../../../modules/ecr"

  ecr_repo_names = var.ecr_repo_names
}
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow access to RDS PostgreSQL"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
module "db_password_ssm" {
  source      = "../../../modules/ssm"
  name        = "/devops/backend/db_password"
  value       = var.db_password
  description = "PostgreSQL password for backend app"
  secure      = true
}
module "db_username_ssm" {
  source      = "../../../modules/ssm"
  name        = "/devops/backend/db_user"
  value       = "postgres"
  description = "PostgreSQL password for backend app"
  secure      = true
}
module "db_name_ssm" {
  source      = "../../../modules/ssm"
  name        = "/devops/backend/db_name"
  value       = module.rds.db_name
  description = "PostgreSQL password for backend app"
  secure      = true
}
module "db_host_ssm" {
  source      = "../../../modules/ssm"
  name        = "/devops/backend/db_host"
  value       = module.rds.db_endpoint
  description = "PostgreSQL password for backend app"
  secure      = true
}

module "rds" {
  source            = "../../../modules/rds"
  name              = "devops-app"
  db_name           = "devopsdb"
  db_username       = "postgres"
  db_password       = var.db_password
  private_subnets   = module.vpc.private_subnets
  security_group_id = aws_security_group.rds_sg.id
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

  environment_vars = [
    {
      name  = "DB_HOST"
      value = module.rds.db_endpoint
    },
    {
      name  = "DB_NAME"
      value = module.rds.db_name
    },
    {
      name  = "DB_USER"
      value = "postgres"
    },
    {
      name  = "DB_PASSWORD"
      value = var.db_password
    }
  ]
}
