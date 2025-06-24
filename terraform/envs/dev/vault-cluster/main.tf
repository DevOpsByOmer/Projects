

resource "aws_s3_bucket" "vault_storage" {
  bucket        = "vault-secure-storage-bucket"
  force_destroy = true

}

resource "aws_dynamodb_table" "vault_locks" {
  name         = "vault-ha-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Path" # 👈 Must be "Path"

  attribute {
    name = "Path"
    type = "S"
  }
}


resource "aws_iam_role" "vault" {
  name = "vault-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com" # If using EC2. Change for EKS.
      }
    }]
  })
}

resource "aws_iam_policy" "vault_s3_dynamodb_policy" {
  name = "VaultS3DynamoDBPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Effect = "Allow",
        Resource = [
          "${aws_s3_bucket.vault_storage.arn}",
          "${aws_s3_bucket.vault_storage.arn}/*"
        ]
      },
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem"
        ],
        Effect   = "Allow",
        Resource = aws_dynamodb_table.vault_locks.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "vault_attachment" {
  role       = aws_iam_role.vault.name
  policy_arn = aws_iam_policy.vault_s3_dynamodb_policy.arn
}

resource "aws_iam_user_policy_attachment" "attach_policy_to_user" {
  user       = data.aws_iam_user.terraform_user.user_name
  policy_arn = aws_iam_policy.vault_s3_dynamodb_policy.arn
}

