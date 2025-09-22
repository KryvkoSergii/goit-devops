resource "kubernetes_manifest" "external_secret_jenkins" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata = { name = "jenkins-shared", namespace = var.namespace }
    spec = {
      refreshInterval = "1h"
      secretStoreRef  = { name = var.cluster_secret_store_name, kind = "ClusterSecretStore" }
      target          = { name = "jenkins-shared", creationPolicy = "Owner" }
      data = [
        { secretKey = "DB_USERNAME", remoteRef = { key = "db/creds",     property = "username" } },
        { secretKey = "DB_PASSWORD", remoteRef = { key = "db/creds",     property = "password" } },
        { secretKey = "DB_NAME",     remoteRef = { key = "db/creds",     property = "name" } },
        { secretKey = "GITHUB_USER", remoteRef = { key = "github/creds", property = "user" } },
        { secretKey = "GITHUB_PAT",  remoteRef = { key = "github/creds", property = "pat" } },
        { secretKey = "GITHUB_REPO_URL",  remoteRef = { key = "github/creds", property = "repo_url" } },
      ]
    }
  }
}