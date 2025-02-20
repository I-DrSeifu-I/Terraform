# -----------------------------
# General Configuration
# -----------------------------

RGname = ""  # Name of the Azure Resource Group
location = ""  # Azure region (e.g., "eastus", "westus2")

# -----------------------------
# Networking Configuration
# -----------------------------

subnet_ID = ""  # Subnet ID where AVD session hosts will be deployed

# -----------------------------
# Virtual Machine Configuration
# -----------------------------

avdSessionHostPrefix = ""  # Prefix for AVD session host names (e.g., "AVD-Host-")
VMsize = ""  # Azure VM size (e.g., "Standard_B2ms")
avdSessionHostCount = 1  # Number of AVD session hosts to deploy

# -----------------------------
# Tagging Information
# -----------------------------

resourceTags = {
  ApplicationName      = ""  # Name of the application associated with AVD
  Environment          = ""  # Environment (e.g., "Development", "Production")
  BusinessCriticality  = ""  # Level of business importance
  createdBy            = ""  # Name of the person or automation deploying the resource
  Department           = ""  # Department responsible for the resource
  PrimaryOwner         = ""  # Primary owner of the resource
  SecondaryOwner       = ""  # Secondary owner of the resource
  EndDateOfTheProject  = ""  # Expected end date of the project
  BillingOwner         = ""  # Billing owner responsible for cost allocation
}

# -----------------------------
# VM Image Reference
# -----------------------------

avdImageReference = {
  publisher = ""  # VM image publisher (e.g., "MicrosoftWindowsDesktop")
  offer     = ""  # VM image offer (e.g., "Windows-11")
  sku       = ""  # SKU version (e.g., "win11-23h2-avd")
  version   = ""  # VM image version (e.g., "latest")
}

# -----------------------------
# Administrative Credentials
# -----------------------------

adminUsername = ""  # Administrator username for session hosts
keyvaultname = ""  # Azure Key Vault name for storing secrets
keyvaultRG = ""  # Resource Group where Key Vault is deployed
keyvaultsecretname = ""  # Secret name in Key Vault for storing admin credentials

# -----------------------------
# AVD Pool Configuration
# -----------------------------

AVDpoolName = ""  # Name of the AVD host pool
avdPoolMaxConcurrentSessions = 10  # Maximum concurrent user sessions per host
avdPoolFriendlyName = ""  # Friendly display name for the host pool
avdPoolDescription = ""  # Description of the host pool

# -----------------------------
# AVD App Group Configuration
# -----------------------------

avdAppGroupName = ""  # Name of the AVD application group
avdAppGroupFriendlyName = ""  # Friendly name for the app group
avdAppGroupDescription = ""  # Description of the app group

# -----------------------------
# AVD Workspace Configuration
# -----------------------------

avdWorkspaceName = ""  # Name of the AVD workspace
avdWorkspaceFriendlyName = ""  # Friendly name for the workspace
avdWorkspaceDescription = ""  # Description of the workspace

# -----------------------------
# AVD Session Host Registration
# -----------------------------

avd_register_session_host_modules_url = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_02-23-2022.zip"  # URL for session host registration script

# -----------------------------
# Active Directory Domain Join Configuration
# -----------------------------

domain_name = ""  # Active Directory domain name
domain_ou = ""  # Organizational Unit (OU) path for domain join
domain_username = ""  # Domain admin username for domain join
domain_password = ""  # Domain admin password (should be stored securely)

