module "network_watcher" {
    source                   = "github.com/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.git?ref=x.x.x"
    resource_group_name      = resource.azurerm_resource_group.macrolife.name
    region                   = resource.azurerm_resource_group.macrolife.location
    network_watcher_name     = var.network_watcher_name
    tags                     = local.vars.rg.tags
}

module "ddos-plan" {
    source                 = "github.com/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.git?ref=x.x.x"
    count                  = local.config_data.ddos-protection.inflate ? 1 : 0
    region                 = local.config_data.common.region
    resource_group_name    = local.config_data.common.resource-group-name
    tags                   = local.vars.rg.tags
}

module "vnet" {
  source                  = "github.com/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.git?ref=x.x.x"
  vnet-name               = var.vnet_name
  resource-group-name     = resource.azurerm_resource_group.macrolife.name
  region                  = resource.azurerm_resource_group.macrolife.location
  vnet-address-space      = var.vnet_address_space
  ddos-protection-plan-id = var.ddos ? [data.terraform_remote_state.ddos-protection-layer.outputs.ddos-protection-plan[0].ddos-plan.id] : []
  tags                    = local.vars.rg.tags
  depends_on              = [module.network_watcher]
}