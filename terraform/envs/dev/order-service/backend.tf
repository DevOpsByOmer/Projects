terraform {
  backend "s3" {
    bucket         = "Terraform-central-tf-state-bucketxxs"
    key            = "envs/dev/order-service/terraform.tfstate" # path inside the bucket
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
