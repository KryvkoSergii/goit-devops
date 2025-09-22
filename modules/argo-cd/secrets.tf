resource "kubernetes_manifest" "external_secret_argo" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata   = { name = "django-app", namespace = var.namespace }
    spec = {
      refreshInterval = "1h"
      secretStoreRef  = { name = var.cluster_secret_store_name, kind = "ClusterSecretStore" }
      target = { name = "django-app", creationPolicy = "Owner",
        template = {
          metadata = {
            labels = {
              "argocd.argoproj.io/secret-type" = "repository"
            }
          }
      } }
      data = [
        { secretKey = "url", remoteRef = { key = "github/creds", property = "repo_url" } },
        { secretKey = "username", remoteRef = { key = "github/creds", property = "github_user" } },
        { secretKey = "password", remoteRef = { key = "github/creds", property = "github_pat" } }
      ]
    }
  }
}
