# resource group deployment
resource "azurerm_resource_group" "Create_RG" {
  name     = var.RGname
  location = var.location
  tags = merge(var.resourceTags, {
    createdDate = local.current_time_for_tag
  })

  lifecycle {
    ignore_changes = [tags["createdDate"]]
  }
}

resource "azurerm_network_interface" "VMnic" {
  count               = var.avdSessionHostCount
  name                = format("%s%02d-NIC%02d", var.avdSessionHostPrefix, count.index + 1, count.index + 1)
  location            = azurerm_resource_group.Create_RG.location
  resource_group_name = azurerm_resource_group.Create_RG.name
  tags = merge(var.resourceTags, {
    createdDate = local.current_time_for_tag
  })

  lifecycle {
    ignore_changes = [tags["createdDate"]]
  }

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_ID
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "avdSessionHost" {
  count                 = var.avdSessionHostCount
  name                  = format("%s%02d", var.avdSessionHostPrefix, count.index + 1)
  resource_group_name   = azurerm_resource_group.Create_RG.name
  location              = var.location
  size                  = var.VMsize
  admin_username        = var.adminUsername
  admin_password        = data.azurerm_key_vault_secret.KVsecret.value
  network_interface_ids = [azurerm_network_interface.VMnic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = format("%s%02d-osDisk", var.avdSessionHostPrefix, count.index + 1)
  }
  source_image_reference {
    publisher = var.avdImageReference.publisher
    offer     = var.avdImageReference.offer
    sku       = var.avdImageReference.sku
    version   = var.avdImageReference.version
  }
  tags = merge(var.resourceTags, {
    createdDate = local.current_time_for_tag
  })

  lifecycle {
    ignore_changes = [tags["createdDate"]]
  }
}

resource "azurerm_virtual_desktop_host_pool" "avdPool" {
  name                     = var.AVDpoolName
  location                 = var.location
  resource_group_name      = azurerm_resource_group.Create_RG.name
  type                     = "Pooled"
  load_balancer_type       = "BreadthFirst"
  maximum_sessions_allowed = var.avdPoolMaxConcurrentSessions
  friendly_name            = var.avdPoolFriendlyName
  description              = var.avdPoolDescription
  tags = merge(var.resourceTags, {
    createdDate = local.current_time_for_tag
  })

  lifecycle {
    ignore_changes = [tags["createdDate"]]
  }
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "avdPoolRegInfo" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.avdPool.id
  expiration_date = timeadd(local.current_time, local.expiration_duration)
}

resource "azurerm_virtual_desktop_application_group" "avdAppGroup" {
  name                         = var.avdAppGroupName
  location                     = var.location
  resource_group_name          = azurerm_resource_group.Create_RG.name
  type                         = "Desktop"
  host_pool_id                 = azurerm_virtual_desktop_host_pool.avdPool.id
  friendly_name                = var.avdAppGroupFriendlyName
  default_desktop_display_name = var.avdAppGroupFriendlyName
  description                  = var.avdAppGroupDescription
  tags = merge(var.resourceTags, {
    createdDate = local.current_time_for_tag
  })

  lifecycle {
    ignore_changes = [tags["createdDate"]]
  }
}

resource "azurerm_virtual_desktop_workspace" "avdWorkspace" {
  name                = var.avdWorkspaceName
  location            = var.location
  resource_group_name = azurerm_resource_group.Create_RG.name # Ensure this references the correct RG
  friendly_name       = var.avdWorkspaceFriendlyName
  description         = var.avdWorkspaceDescription
  tags = merge(var.resourceTags, {
    createdDate = local.current_time_for_tag
  })

  lifecycle {
    ignore_changes = [tags["createdDate"]]
  }
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "avdGroupAssociation" {
  workspace_id         = azurerm_virtual_desktop_workspace.avdWorkspace.id
  application_group_id = azurerm_virtual_desktop_application_group.avdAppGroup.id
}


resource "azurerm_virtual_machine_extension" "avd_register_session_host" {
  count                = var.avdSessionHostCount
  name                 = "AVD-registerhost-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.avdSessionHost.*.id[count.index]
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.73"
  tags = merge(var.resourceTags, {
    createdDate = local.current_time_for_tag
  })

  settings = <<-SETTINGS
    {
      "modulesUrl": "${var.avd_register_session_host_modules_url}",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "hostPoolName": "${azurerm_virtual_desktop_host_pool.avdPool.name}",
        "aadJoin": false
      }
    }
    SETTINGS

  protected_settings = <<-PROTECTED_SETTINGS
    {
      "properties": {
        "registrationInfoToken": "${azurerm_virtual_desktop_host_pool_registration_info.avdPoolRegInfo.token}"
      }
    }
    PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [settings, protected_settings, tags["createdDate"]]
  }

}



resource "azurerm_virtual_machine_extension" "avdDomainJoin" {
  count                = var.avdSessionHostCount
  name                 = "domainJoinExtension"
  virtual_machine_id   = azurerm_windows_virtual_machine.avdSessionHost.*.id[count.index]
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"

  settings = <<SETTINGS
    {
      "Name": "${var.domain_name}",
      "OUPath": "${var.domain_ou}",
      "User": "${var.domain_username}",
      "Restart": "true",
      "Options": "3"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "Password": "${var.domain_password}"
    }
PROTECTED_SETTINGS
  tags = merge(var.resourceTags, {
    createdDate = local.current_time_for_tag
  })
}





