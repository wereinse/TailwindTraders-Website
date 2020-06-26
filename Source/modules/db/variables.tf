variable "NAME" {
  type        = string
  description = "The prefix which should be used for all resources in this example"
}

variable "COSMOS_RG_NAME" {
  type        = string
  description = "The Azure Resource Group the resource should be added to"
}

variable "LOCATION" {
  type        = string
  description = "The Azure Region in which all resources in this example should be created."
}

variable "INSTANCES" {
  description = "Map of the environment name and the helium application language to use i.e {myinstance1 = csharp, myinstance2 = typescript}"
  type        = map(string)
}

variable "COSMOS_RU" {
  type = number
}
