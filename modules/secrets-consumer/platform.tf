resource "aws_iam_role" "eso_irsa" {
  name = "${var.cluster_name}-eso-irsa"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Federated = var.oidc_provider_arn },
      Action    = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(var.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:${var.eso_ns}:${var.eso_sa_name}"
        }
      }
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "eso_sm_policy" {
  name = "${var.cluster_name}-eso-sm-policy"
  role = aws_iam_role.eso_irsa.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Effect = "Allow", Action = ["secretsmanager:GetSecretValue"], Resource = var.secret_arns }
      # in case we use custom KMS: add kms:Decrypt
      # { Effect="Allow", Action=["kms:Decrypt"], Resource="arn:aws:kms:${var.aws_region}:<ACCOUNT_ID>:key/<KEY_ID>" }
    ]
  })
}

resource "kubernetes_namespace" "external_secrets" {
  metadata { name = var.eso_ns }
}

resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  namespace        = kubernetes_namespace.external_secrets.metadata[0].name
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = "0.9.13"
  create_namespace = false

  values = [yamlencode({
    installCRDs = true
    serviceAccount = {
      create      = true
      name        = var.eso_sa_name
      annotations = { "eks.amazonaws.com/role-arn" = aws_iam_role.eso_irsa.arn }
    }
  })]

  wait             = true
  timeout          = 600
  atomic           = true

  depends_on = [aws_iam_role.eso_irsa]
}

resource "time_sleep" "wait_for_crds" {
  create_duration = "20s"
  depends_on      = [helm_release.external_secrets]
}

resource "kubernetes_manifest" "cluster_secret_store" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ClusterSecretStore"
    metadata   = { name = var.css_name }
    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region  = var.aws_region
          auth = {
            jwt = {
              serviceAccountRef = {
                name      = var.eso_sa_name
                namespace = var.eso_ns
              }
            }
          }
        }
      }
    }
  }
  depends_on = [time_sleep.wait_for_crds]
}