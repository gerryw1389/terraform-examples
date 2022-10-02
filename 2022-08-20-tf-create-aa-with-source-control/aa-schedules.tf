
resource "azurerm_automation_schedule" "monday_tuesday" {
  name                    = "tfex-automation-schedule"
  resource_group_name     = azurerm_resource_group.aa_rg.name
  automation_account_name = azurerm_automation_account.aa.name
  frequency               = "Week"
  interval                = 1
  timezone                = "America/Chicago"
  start_time              = "2022-10-05T16:05:16-07:00"
  description             = "Production schedule"
  week_days               = ["Monday", "Tuesday"]
}

resource "azurerm_automation_schedule" "wednes_thurs" {
  name                    = "tfex-automation-schedule"
  resource_group_name     = azurerm_resource_group.aa_rg.name
  automation_account_name = azurerm_automation_account.aa.name
  frequency               = "Week"
  interval                = 1
  timezone                = "America/Chicago"
  start_time              = "2022-10-05T16:05:16-07:00"
  description             = "Production schedule"
  week_days               = ["Wednesday", "Thursday"]
}