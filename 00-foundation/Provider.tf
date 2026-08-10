# Provider.tf 
# this tells the terraform "We are using Microsoft Azure" and which version

terraform {
    required_version = ">= 1.6.0"

    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~> 3.100" # ~> means "3.100.x but not 4.x"
        }
    }
}

# configure Azure

provider "azurerm" {
    features {

    }
}