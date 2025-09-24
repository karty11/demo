
provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

data "aws_caller_identity" "current" {}

locals {
  oidc_provider_url = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  oidc_sub_key      = "${local.oidc_provider_url}:sub"
}

data "tls_certificate" "oidc" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
}
# }
# resource "aws_iam_openid_connect_provider" "eks" {
#   url             = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.external.oidc_thumbprint.result.["thumbprint"]]
# }

data "aws_iam_policy_document" "irsa_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }
    condition {
      test     = "StringEquals"
      variable = local.oidc_sub_key
      values   = ["system:serviceaccount:${var.eks_sa_namespace}:${var.eks_sa_name}"]
    }
  }
}

resource "aws_iam_role" "external_secrets_irsa" {
  name = "external-secrets-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn   # <-- federated OIDC provider here
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            # replace <oidc-provider-host> with issuer host without https://
            # e.g. "oidc.eks.<region>.amazonaws.com/id/XXXXXXXXXXXX:sub" = "system:serviceaccount:<namespace>:<sa-name>"
            (local.oidc_sub_key) = "system:serviceaccount:external-secrets:external-secrets-sa"

          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "ebs_csi_driver_irsa" {
  name = "ebs-csi-driver-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            (local.oidc_sub_key) = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ebs_csi_driver_policy" {
  name = "ebs-csi-driver-policy"
  role = aws_iam_role.ebs_csi_driver_irsa.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateVolume",
          "ec2:AttachVolume",
          "ec2:DeleteVolume",
          "ec2:DetachVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumeAttribute",
          "ec2:DescribeVolumeStatus"
        ]
        Resource = "*"
      }
    ]
  })
}
