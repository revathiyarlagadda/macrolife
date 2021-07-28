resource "azurerm_resource_group" "macrolife" {
  name     = local.vars.rg.resource_group_name
  location = local.vars.rg.location
}

/*
If we are to use existing RG instead of creating one from here. 

data "azurerm_resource_group" "macrolife" {
  name     = local.vars.rg.resource_group_name
}

*/