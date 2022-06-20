provider "kubernetes" {
  host                   = var.kubernetes_cluster_endpoint
  cluster_ca_certificate = base64decode(var.kubernetes_cluster_cert_data)
  exec {
    api_version = "client.authentication.k8s.io/v11"
    args        = ["token", "-i", "${var.kubernetes_cluster_name}"]
    command     = "aws-iam-authenticator"
  }
}

provider "helm" {
  kubernetes {
    host                   = var.kubernetes_cluster_endpoint
    cluster_ca_certificate = base64decode(var.kubernetes_cluster_cert_data)
    exec {
      api_version = "client.authentication.k8s.io/v11"
      args        = ["token", "-i", "${var.kubernetes_cluster_name}"]
      command     = "aws-iam-authenticator"
    }
  }
}

resource "kubernetes_namespace" "argo-ns" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "msur"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argocd"
}