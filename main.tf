terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Referencia al Resource Group existente del alumno
data "azurerm_resource_group" "utec_rg" {
  name = var.resource_group_name
}


resource "azurerm_redis_cache" "redis" {
  name                = "redis-utec-${var.student_name}"
  location            = data.azurerm_resource_group.utec_rg.location
  resource_group_name = data.azurerm_resource_group.utec_rg.name
  capacity            = 1
  family              = "C"     # C = Basic/Standard, P = Premium
  sku_name            = "Basic" # Basic | Standard | Premium

  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  redis_configuration {}
  tags = {
    Entorno = "Laboratorio"
    Curso   = "Arquitectura Multinube"
    Alumno  = var.student_name
  }
}
