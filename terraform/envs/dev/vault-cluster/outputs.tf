output "s3_bucket" {
  value = aws_s3_bucket.vault_storage.id
}

output "dynamodb_table" {
  value = aws_dynamodb_table.vault_locks.name
}

output "vault_iam_role_arn" {
  value = aws_iam_role.vault.arn
}
output "kms_arn" {
  value = aws_kms_key.vault.arn
}

output "kms_key_id" {
  value = aws_kms_key.vault.key_id
}
output "kms_key_usage" {
  value = aws_kms_key.vault.key_usage
}