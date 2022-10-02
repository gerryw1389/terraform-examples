

#### Runbook 1

data "local_file" "show_subs_script" {
  filename = "${path.module}/example.ps1"
}

resource "azurerm_automation_runbook" "show_subs" {
  name                    = "Show-VMs"
  location                = var.region
  resource_group_name     = azurerm_resource_group.aa_rg.name
  automation_account_name = azurerm_automation_account.aa.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "This is an example runbook that will show VMs"
  runbook_type            = "PowerShell"

  content = data.local_file.show_subs_script.content
  tags    = local.sbx_tags
}

resource "azurerm_automation_job_schedule" "show_subs_sched" {
  resource_group_name     = azurerm_resource_group.aa_rg.name
  automation_account_name = azurerm_automation_account.aa.name
  runbook_name            = azurerm_automation_runbook.show_subs.name
  schedule_name           = azurerm_automation_schedule.monday_tuesday.name
}

#### Runbook 2

data "local_file" "show_subs_script_2" {
  filename = "${path.module}/example-2.ps1"
}

resource "azurerm_automation_runbook" "show_subs_2" {
  name                    = "Show-VMs-2"
  location                = var.region
  resource_group_name     = azurerm_resource_group.aa_rg.name
  automation_account_name = azurerm_automation_account.aa.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "This is an example runbook that will show VMs 2"
  runbook_type            = "PowerShell"

  content = data.local_file.show_subs_script_2.content
  tags    = local.sbx_tags
}

resource "azurerm_automation_job_schedule" "show_subs_2_sched" {
  resource_group_name     = azurerm_resource_group.aa_rg.name
  automation_account_name = azurerm_automation_account.aa.name
  runbook_name            = azurerm_automation_runbook.show_subs_2.name
  schedule_name           = azurerm_automation_schedule.wednes_thurs.name
}
