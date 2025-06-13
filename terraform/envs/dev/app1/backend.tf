terraform {
  backend "s3" {
    bucket         = "terraform-central-tf-state-bucketxxs" # Shared bucket
    key            = "envs/dev/app1/terraform.tfstate"      # Unique per project/env
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table" # Shared table
    encrypt        = true
  }
}
