data "aws_caller_identity" "current" {}

# IAM user 'terraform' (assumed already exists)
data "aws_iam_user" "terraform_user" {
  user_name = "terraform"
}

# KMS key for Vault auto-unseal
resource "aws_kms_key" "vault" {
  description             = "KMS key for Vault auto-unseal"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  # Allow terraform user to administer the key
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-vault-policy",
    Statement = [
      # 👇 Root account full admin
      {
        Sid    = "EnableRootUserFullAccess",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      # 👇 Vault usage permissions for IAM user 'terraform'
      {
        Sid    = "AllowVaultUnseal",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraform"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey"
        ],
        Resource = "*"
      }
    ]
  })
}

# Alias for the KMS key (easier reference in Vault config)
resource "aws_kms_alias" "vault_alias" {
  name          = "alias/vault-auto-unseal"
  target_key_id = aws_kms_key.vault.key_id
}

# IAM policy document granting permission to use the KMS key
data "aws_iam_policy_document" "vault_kms_usage" {
  statement {
    sid    = "VaultKMSUsage"
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]

    resources = [aws_kms_key.vault.arn]
  }
}

# IAM policy resource based on that document
resource "aws_iam_policy" "vault_kms_usage_policy" {
  name   = "VaultKMSUsagePolicy"
  policy = data.aws_iam_policy_document.vault_kms_usage.json
}

# Attach the policy to the terraform user
resource "aws_iam_user_policy_attachment" "attach_kms_policy_to_user" {
  user       = data.aws_iam_user.terraform_user.user_name
  policy_arn = aws_iam_policy.vault_kms_usage_policy.arn
}
