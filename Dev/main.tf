variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

# Configure the Microsoft Azure Provider.
provider "azurerm" {
    version = "=1.27.0"
}

## VM-Terraform
# Create a resource group
resource "azurerm_resource_group" "rg" {
    name     = "rg-terraform"
    location = "westus2"
}
# Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "VNET-Terraform"
    address_space       = ["10.0.0.0/16"]
    location            = "westus2"
    resource_group_name = "${azurerm_resource_group.rg.name}"
}

# Create subnet
resource "azurerm_subnet" "subnet" {
    name                 = "SN-Terraform"
    resource_group_name  = "${azurerm_resource_group.rg.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "10.0.1.0/24"
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
    name                         = "PIP-VM-Terraform"
    location                     = "westus2"
    resource_group_name          = "${azurerm_resource_group.rg.name}"
    allocation_method            = "Static"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
    name                = "NSG-Terraform"
    location            = "westus2"
    resource_group_name = "${azurerm_resource_group.rg.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
    name                      = "NIC-Terraform"
    location                  = "westus2"
    resource_group_name       = "${azurerm_resource_group.rg.name}"
    network_security_group_id = "${azurerm_network_security_group.nsg.id}"

    ip_configuration {
        name                          = "NIC-Terraform-Config"
        subnet_id                     = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.publicip.id}"
    }
}

# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm" {
    name                  = "VM-Terraform"
    location              = "westus2"
    resource_group_name   = "${azurerm_resource_group.rg.name}"
    network_interface_ids = ["${azurerm_network_interface.nic.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "VM-Terraform"
        admin_username = "admin"
        admin_password = "Secr3t!"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

}
