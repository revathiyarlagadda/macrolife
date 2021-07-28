module "network_watcher" {
    source                   = "github.com/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.git?ref=x.x.x"
    resource_group_name      = resource.azurerm_resource_group.macrolife.name
    region                   = resource.azurerm_resource_group.macrolife.location
    network_watcher_name     = local.vars.network_watcher.name
    tags                     = local.vars.rg.tags
}

module "ddos-plan" {
    source                 = "github.com/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.git?ref=x.x.x"
    count                  = local.vars.ddos.inflate ? 1 : 0
    region                 = resource.azurerm_resource_group.macrolife.location
    resource_group_name    = resource.azurerm_resource_group.macrolife.location
    tags                   = local.vars.rg.tags
    
}

module "vnet" {
  source                  = "github.com/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.git?ref=x.x.x"
  vnet-name               = local.vars.vnet_name
  resource-group-name     = resource.azurerm_resource_group.macrolife.name
  region                  = resource.azurerm_resource_group.macrolife.location
  vnet-address-space      = local.vars.network.vnet_address_space
  ddos-protection-plan-id = local.vars.ddos.inflate ? [module.ddos-plan.outputs.ddos-protection-plan[0].ddos-plan.id] : [] #Assuming there is such module output
  tags                    = local.vars.rg.tags
  depends_on              = [module.network_watcher]
}

module "subnets" {
  source                                         = "github.com/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.git?ref=x.x.x"
  for_each                                       = local.vars.network.subnets
  resource-group-name                            = module.vnet.vnet.resource_group_name
  vnet-name                                      = module.vnet.vnet.name
  subnet-prefixes                                = [each.value]
  subnet-name                                    = each.key
  depends_on                                     = [module.vnet]
}

locals {
  #it's in rules.tf
  merged_rules = { for k, v in local.subnet_rules : k => merge(v, local.common_rules.Common)}
  flat_rules = flatten([
    for k, v in local.merged_rules : [
      for a, b in v : {
          "${(k)}_${a}" = b
      }
    ]
  ])
  rules_map = { for item in local.flat_rules:  keys(item)[0] => values(item)[0]}
}

module "nsg_rules" {
  for_each                      = local.rules_map
  source                        = "github.com/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.git?ref=x.x.x"
  name                          = each.value.name
  priority                      = each.value.priority
  direction                     = each.value.direction
  access                        = each.value.access
  protocol                      = each.value.protocol
  source_port_range             = try(each.value.source_port_range,null)
  source_port_ranges            = try(each.value.source_port_ranges,null)
  destination_port_range        = try(each.value.destination_port_range,null)
  destination_port_ranges       = try(each.value.destination_port_ranges,null)
  source_address_prefix         = try(each.value.source_address_prefix, null)
  source_address_prefixes       = try(each.value.source_address_prefixes, null)
  destination_address_prefix    = try(each.value.destination_address_prefix, null)
  destination_address_prefixes  = try(each.value.destination_address_prefixes, null)
  nsg_name                      = lookup(module.nsg, split("_", each.key)[0]).nsg.name
  resource_group_name           = data.terraform_remote_state.resource_group_layer.outputs.rg_ddn["${local.config_data.common.region}-${local.config_data.common.ddntags.asset-insight-id}-ddn-resources"].name
  depends_on          = [module.nsg]
  
  /*
  we have to define the variables like this in NSG module code. So from template, we can pass either source_port_range or source_port_ranges.
  It is important to set default = null
  The same goes for others like ranges or address prefixes.

  variable "source_port_range" {
    description = "Port or port range for the Source. "
    type = string
    default = null
}

variable "source_port_ranges" {
    description = "Port or port range for the Source. "
    type = list(string)
    default = null
}
*/

}