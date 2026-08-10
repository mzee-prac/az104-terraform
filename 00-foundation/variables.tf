# variables.tf
# this file defines all INPUT variables

variable "location" {
    description = "The Azure region where the resource will be deployed"
    type = string
    default = "East US"

    validation {
        condition = contains(["East US","West US","UK South","North UAE"], var.location)
        error_message = " only location from East US,West US,UK South,North UAE are acceptable"
    }
} 

variable "environment" {
    description = "Environment names: Dev, Prod or staging"
    type = string
    default = "Dev"

    validation {
        condition = contains(["dev","staging","prod"], var.environment)
        error_message = "Environment must be one of: dev, staging, prod."
    }
}

variable "project_name" {
    description =  "Name of the project - used in resource naming"
    type = string 
    default = "az104training"
}

variable "tags" {
    description = "Common tags to apply to all resources"
    type = map(string)
    default = {}
}