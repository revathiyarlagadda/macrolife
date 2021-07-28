module "storage_account" {
  source                    = "github.com/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.git?ref=x.x.x"
  storage_account_name      = local.vars.storage.storage_account_name
  resource_group_name       = resource.azurerm_resource_group.macrolife.name
  location                  = resource.azurerm_resource_group.macrolife.location
  account_tier              = local.vars.storage.account_tier
  account_kind              = local.vars.storage.account_kind
  account_replication_type  = local.vars.storage.account_replication_type
  tags                      = local.vars.rg.tags
}
