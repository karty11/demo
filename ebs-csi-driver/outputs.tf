output "ebs_csi_driver_role_arn" {
  description = "IAM Role ARN for EBS CSI driver"
  value       = aws_iam_role.ebs_csi_driver_irsa.arn
}
