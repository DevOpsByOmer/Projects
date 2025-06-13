aws_region = "ap-south-1"

vpc_name        = "devops-vpc"
vpc_cidr_block  = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
azs             = ["ap-south-1a", "ap-south-1b"]

ecr_repo_names = ["backend", "frontend"]

frontend_image = "296062587378.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest"
backend_image  = "296062587378.dkr.ecr.ap-south-1.amazonaws.com/backend:latest"

lb_name = "APP1-lb"
