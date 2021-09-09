variable "api_key" {
type = string
description = "API Key Id from Intersight"
}
variable "secretkey" {
type = string
description = "The path to your secretkey file for Intersight"
}
variable "api_endpoint" {
/*type = string
description = "The Intersight end point"*/
default = "https://www.intersight.com"
}
variable "cluster_name" {
type = string
}

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
