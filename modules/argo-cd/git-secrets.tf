# resource "kubernetes_secret" "argocd_repo" {
#   metadata {
#     name      = "repo-goit-devops"
#     namespace = "argocd"
#     labels = {
#       "argocd.argoproj.io/secret-type" = "repository"
#     }
#   }

#   data = {
#     type     = "git"
#     url      = "https://github.com/KryvkoSergii/goit-devops.git"
#     username = var.github_user
#     password = var.github_pat
#   }

#   type = "Opaque"

#   depends_on = [ helm_release.argo_cd ]
# }