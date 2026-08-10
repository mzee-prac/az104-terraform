# main.tf

locals {
  resource_group_name = "rg-${var.project_name}-${var.environment}-001"

  common_tags = merge ( var.tags, {
    Environment = var.environment
    Project = var.project_name
    ManagedBy = "Terraform"
    CreatedDate = formatdate("YYYY-MM-DD",timestamp())
  })

}

# defining the resources in actual

resource "azurerm_resource_group" "main" {
    name = local.resource_group_name
    location = var.location
    tags = local.common_tags
} 