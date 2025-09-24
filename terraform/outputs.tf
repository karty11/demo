output "iam_role_arn" {
  value = aws_iam_role.external_secrets_irsa.arn
}

output "oidc_provider" {
  value = aws_iam_openid_connect_provider.eks.url
}

output "cluster_name_debug" {
  value = var.cluster_name
}

output "aws_region_debug" {
  value = var.aws_region
}

output "aws_identity_debug" {
  value = data.aws_caller_identity.current.arn
}

output "role_name" {
  value = aws_iam_role.external_secrets_irsa.name
}

output "ebs_csi_driver_role_name" {
  description = "Name of the IAM role for the EBS CSI driver"
  value       = aws_iam_role.ebs_csi_driver_irsa.name
}

output "ebs_csi_driver_role_arn" {
  description = "ARN of the IAM role for the EBS CSI driver"
  value       = aws_iam_role.ebs_csi_driver_irsa.arn
}
