data "azurerm_key_vault" "governance_kv" {
  name                = local.vars.governance.kv_name
  resource_group_name = local.vars.governance.rg_name
}

data "azurerm_key_vault_secret" "vm_password" {
  name         = local.vars.governance.secret_name
  key_vault_id = data.azurerm_key_vault.governance_kv.id
}

data "azurerm_key_vault_certificate" "cert" {
  name         = local.vars.governance.secret_cert_name
  key_vault_id = data.azurerm_key_vault.governance_kv.id
}


module "windowsservers" {
  for_each                      = module.subnets[*].outputs
  source                        = "github.com/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.git?ref=x.x.x"
  resource_group_name           = resource.azurerm_resource_group.macrolife.name
  vm_hostname                   = local.vars.compute.vmname
  is_windows_image              = true
  admin_password                = data.azurerm_key_vault_secret.vm_password.value
  allocation_method             = "Static"
  public_ip_sku                 = "Standard"
  vm_os_publisher               = "MicrosoftWindowsServer"
  vm_os_offer                   = "WindowsServer"
  vm_os_sku                     = "2012-R2-Datacenter"
  vm_size                       = "Standard_DS2_V2"
  vnet_subnet_id                = each.value.subnet.id
  enable_accelerated_networking = true
  license_type                  = "Windows_Client"
  identity_type                 = "SystemAssigned" // can be empty, SystemAssigned or UserAssigned

  extra_disks = [
    {
      size = 50
      name = "logs"
    },
    {
      size = 200
      name = "backup"
    }
  ]

  os_profile_secrets = [{
    source_vault_id   = data.azurerm_key_vault.governance_kv.id
    certificate_url   = data.azurerm_key_vault_certificate.example.secret_id
    certificate_store = "My"
  }]
}