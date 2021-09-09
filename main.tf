terraform {
  required_providers {
    intersight = {
      source = "CiscoDevNet/intersight"
      version = ">=1.0.11"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.4.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.3.0"
    }    
  }
}

provider "intersight" {
  apikey    = var.api_key
  secretkey = var.secretkey
  endpoint = "https://intersight.com"
}

data "intersight_kubernetes_cluster" "my-cluster" {
    name = var.cluster_name
}

locals {
    kube_config = yamldecode(base64decode(data.intersight_kubernetes_cluster.my-cluster.results[0].kube_config))
}

provider "helm" {
  kubernetes {
    host                   = local.kube_config.clusters[0].cluster.server
    client_certificate     = base64decode(local.kube_config.users[0].user.client-certificate-data)
    client_key             = base64decode(local.kube_config.users[0].user.client-key-data)
    cluster_ca_certificate = base64decode(local.kube_config.clusters[0].cluster.certificate-authority-data)
  }
}

resource "helm_release" "iwo_k8s_collector" {
  name      = "iwok8scollector"
  namespace = "default"
  # namespace = "iwo-collector"
  # chart = "https://prathjan.github.io/helm-chart/iwok8scollector-0.6.2.tgz"
  verify = false
  chart = "."
  set {
    name  = "iwoServerVersion"
    value = "8.0"
  }
  set {
    name  = "collectorImage.tag"
    value = "8.0.6"
  }
  set {
    name  = "targetName"
    value = "${var.cluster_name}_sample"
  }
}
