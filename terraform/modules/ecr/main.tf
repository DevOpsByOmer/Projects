resource "aws_ecr_repository" "this" {
  for_each = toset(var.ecr_repo_names)

  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
