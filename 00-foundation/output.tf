# output.tf

output "resource_group_name" {
    description = "The name of the created resource group"
    value = azurerm_resource_group.main.name 
}

output "resource_group_id" {
    description = "The id of the created resource group"
    value = azurerm_resource_group.main.id 
}

output "resource_group_location" {
    description = "The region of the resouce group"
    value = azurerm_resource_group.main.location
}