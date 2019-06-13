## This is a Terraform file-
# To run this you need to add system variables to your PC or you can replace with the the actual values 
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

provider "azurerm" {
  version           = "1.27.0"
  client_id         = "${var.client_id}"
  client_secret     = "${var.client_secret}"
  tenant_id         = "${var.tenant_id}"
  subscription_id   = "${var.subscription_id}"
}

resource "azurerm_resource_group" "rg-test" {
    name    = "rg-test1"
    location = "eastus2"
}


