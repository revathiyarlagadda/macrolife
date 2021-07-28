locals {
  common_rules = {
    Common = {
      Inbound_80_442 = {
        name                       = "Inbound_80_443"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_ranges     = ["80","443"]
        source_address_prefix      = "*"
        destination_address_prefix = local.vars.network.vnet_address_space
      },
      Outbound_80_443 = {
        name                       = "Outbound_80_443"
        priority                   = 1001
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_ranges     = ["80","443"]
        source_address_prefix      = local.vars.network.vnet_address_space
        destination_address_prefix = "*"
      }
    }
  }
  subnet_rules = {
      subnet1 = {},
      subnet2 = {}

  }
}