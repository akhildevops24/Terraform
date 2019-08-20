## This is a Test Terraform file- 
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "mpc_default_location" {}
variable "web_server_rg" {}

provider "azurerm" {
  version           = "1.27.0"
  client_id         = "${var.client_id}"
  client_secret     = "${var.client_secret}"
  tenant_id         = "${var.tenant_id}"
  subscription_id   = "${var.subscription_id}"
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "web_server_rg" {
    name     = "${var.web_server_rg}"
    location = "${var.mpc_default_location}"
}