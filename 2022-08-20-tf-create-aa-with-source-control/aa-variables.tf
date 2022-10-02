
resource "azurerm_automation_variable_string" "my_string_1" {
  name                    = "tfex-example-var"
  resource_group_name     = azurerm_resource_group.aa_rg.name
  automation_account_name = azurerm_automation_account.aa.name
  value                   = "Hello, Terraform Basic Test."
}