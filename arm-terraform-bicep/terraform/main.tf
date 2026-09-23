resource "azurerm_resource_group" "az104" {
  name     = "rg-az104-terraform-01"
  location = "East US"
}
resource "azurerm_storage_account" "az104" {
  name                = "patelterraformstorage001"
  resource_group_name = azurerm_resource_group.az104.name
  location            = "eastus"
  account_kind        = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
