#__________________________________________________________
#
# Terraform Cloud Organization
#__________________________________________________________

variable "tfc_organization" {
  description = "Terraform Cloud Organization."
  type        = string
}


#______________________________________________
#
# Terraform Cloud kubeconfig Workspace
#______________________________________________

variable "ws_kubeconfig" {
  description = "Intersight Kubernetes Service (IKS) kubeconfig Workspace Name.  The default value will be set to {cluster_name}_kubeconfig by the tfe variable module."
  type        = string
}
