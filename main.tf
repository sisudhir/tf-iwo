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


#__________________________________________________________
#
# Get Outputs from the kubeconfig Workspace
#__________________________________________________________

data "terraform_remote_state" "kubeconfig" {
  backend = "remote"
  config = {
    organization = var.tfc_organization
    workspaces = {
      name = var.ws_kubeconfig
    }
  }
}

locals {
  # IKS Cluster Name
  cluster_name = data.terraform_remote_state.kubeconfig.outputs.cluster_name
  # Kubernetes Configuration File
  kubeconfig = yamldecode(data.terraform_remote_state.kubeconfig.outputs.kubeconfig)
}

#______________________________________________________________________
#
# Deploy the Intersight Workload Optimizer Pod using the Helm Provider
#______________________________________________________________________

resource "helm_release" "iwo_k8s_collector" {
  name      = "iwok8scollector"
  namespace = "default"
  #  namespace = "iwo-collector"
  chart = "https://prathjan.github.io/helm-chart/iwok8scollector-0.6.2.tgz"
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
    value = "${local.cluster_name}_sample"
  }
}
