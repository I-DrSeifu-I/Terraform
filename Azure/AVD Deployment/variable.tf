variable "RGname" {
  type    = string
  description = "Resource group name for resources"
}

variable "location" {
  type    = string
  description = "Location for resource creation. By default set to eastus"
  default = "eastus"
}

variable "subnet_ID" {
  type = string
  description = "Subnet ID for which AVD will connect to"
}

variable "VMsize" {
  type    = string
  description = "VM size, by defualt is Standard_B2ms"
  default = "Standard_B2ms"
}

variable "avdSessionHostCount" {
  description = "The name of the session host with no indexing"
  type        = number
}

variable "resourceTags" {
  type = object({
    ApplicationName      = string
    Environment          = string
    BusinessCriticality  = string
    createdBy            = string
    Department           = string
    PrimaryOwner         = string
    SecondaryOwner       = string
    EndDateOfTheProject  = string
    BillingOwner         = string
  })

  default = {
    ApplicationName      = "test"
    Environment          = "test"
    BusinessCriticality  = "test"
    createdBy            = "test"
    Department           = "test"
    PrimaryOwner         = "test"
    SecondaryOwner       = "test"
    EndDateOfTheProject  = "test"
    BillingOwner         = "test"
  }
}


variable "avdImageReference" {
  description = "The source image reference for the VM."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-11"
    sku       = "win11-23h2-avd"
    version   = "latest"
  }
}

variable "adminUsername" {
  type    = string
  description = "Local admin username for the VM"
}

variable "keyvaultname" {
  type    = string
  description = "key vault for retrieving local admin account password for VM"
}

variable "keyvaultRG" {
  type    = string
  description = "key vault resource group for retrieving local admin account password for VM"
}

variable "keyvaultsecretname" {
  type    = string
  description = "key vault secret name for retrieving local admin account password for VM"
}

variable "AVDpoolName" {
  type    = string
  description = "AVD Pool name"
}

variable "avdPoolMaxConcurrentSessions" {
  type    = number
  default = 10
  description = "Maximum number of concurrent sessions for the AVD pool"
}

variable "avdSessionHostPrefix" {
  description = "The name of the session host with no indexing. By default: AZ-AVD-"
  default     = "AZ-AVD-"
  type        = string
  validation {
    condition     = length(var.avdSessionHostPrefix) <= 11
    error_message = "The avdSessionHostPrefix must be 11 or fewer characters to account for indexing"
  }
}

variable "avdPoolFriendlyName" {
  type    = string
  description = "Friendly name for AVD pool"
}

variable "avdPoolDescription" {
  type    = string
  description = "AVD pool description"
}

variable "avdAppGroupName" {
  type    = string
  description = "AVD application group name"
}

variable "avdAppGroupFriendlyName" {
  type    = string
  description = "AVD application friendly name"
}

variable "avdAppGroupDescription" {
  type    = string
  description = "AVD application group description"
}

variable "avdWorkspaceName" {
  type    = string
  description = "AVD workspace name"
}

variable "avdWorkspaceFriendlyName" {
  type    = string
  description = "AVD workspace friendly name"
}

variable "avdWorkspaceDescription" {
  description = "The displayed description of the workspace - include purpose and who may be using it"
  type        = string
}

variable "avd_register_session_host_modules_url" {
  type        = string
  description = "URL to .zip file containing DSC configuration to register AVD session hosts to AVD host pool."
  default     = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_02-23-2022.zip"
}

variable "domain_name" {
  description = "The domain name used to AD domain join"
  type        = string
}

variable "domain_ou" {
  description = "The domain organizational unit for the VM to join"
  type        = string
}

variable "domain_username" {
  description = "The domain username used to AD domain join"
  type        = string
}

variable "domain_password" {
  description = "The domain password used to AD domain join"
  type        = string
  sensitive   = true
}

