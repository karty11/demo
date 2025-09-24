variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "cluster_name" {
  type = string
  default = "project-cluster"
}

variable "eks_sa_namespace" {
  type    = string
  default = "external-secrets"
}

variable "eks_sa_name" {
  type    = string
  default = "external-secrets-sa"
}


variable "oidc_thumbprint" {
  type    = string
  default = ""
}

variable "role_name" {
  description = "Name of the IAM role for the EBS CSI driver"
  type        = string
  default     = "ebs-csi-driver-irsa"
}
