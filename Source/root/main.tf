/**
* # Parent Template Properties  
*
* This is the parent Terraform Template used to call the component modules to create the infrastructure and deploy the [Helium](https://github.com/retaildevcrews/helium) application.  
*
* The only resurces created in the template are the resource groups that each Service will go into. It is advised to create a terraform.tfvars file to assign values to the variables in the `variables.tf` file.
*
* To keep sensitive keys from being stored on disk or source control you can set local environment variables that start with TF_VAR_**NameOfVariable**. This can be used with the Terraform Service Principal Variables
*
* tfstate usage (not real values)
*
* ```shell
* export TF_VAR_TF_SUB_ID="gy6tgh5t-9876-3uud-87y3-r5ygytd6uuyr"
* export TF_VAR_TF_TENANT_ID="frf34ft5-gtfv-wr34-343fw-hfgtry657uk8"
* export TF_VAR_TF_CLIENT_ID="ju76y5h8-98uh-oin8-n7ui-ger43k87d5nl"
* export TF_VAR_TF_CLIENT_SECRET="kjbh89098hhiuovvdh6j8uiop="
* ```
*/

provider "azurerm" {
  version = "2.0.0"
  features {}

  subscription_id = var.TF_SUB_ID
  client_id       = var.TF_CLIENT_ID
  client_secret   = var.TF_CLIENT_SECRET
  tenant_id       = var.TF_TENANT_ID
}

provider "azuread" {
  subscription_id = var.TF_SUB_ID
  client_id       = var.TF_CLIENT_ID
  client_secret   = var.TF_CLIENT_SECRET
  tenant_id       = var.TF_TENANT_ID
}

resource "azurerm_resource_group" "tw_rg" {
  name     = "tw-rg"
  location = var.LOCATION
}

module "db" {
  source         = "../modules/db"
  DB_RG_NAME 	 = azurerm_resource_group.db.name
  NAME           = var.NAME
  LOCATION       = var.LOCATION
}
