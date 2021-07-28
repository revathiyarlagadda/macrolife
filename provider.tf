provider "azurerm" {
  features {
      # if we create a KV using tf, would recommend setting KV block to support softdelete/purge things
  }
  
  /*
  #subscription_id = "00000000-0000-0000-0000-000000000000"
  #client_id       = "00000000-0000-0000-0000-000000000000"
  #client_secret   = var.client_secret
  #tenant_id       = "00000000-0000-0000-0000-000000000000"

  Better to configure these as env variables form the pipeline.

  */

}