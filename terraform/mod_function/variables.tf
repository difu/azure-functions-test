variable "function_name" {
  type = string
}

variable "functions_path" {
  type = string
  default = "../function"
}
# variable "resource_group_name" {}
# variable "location" {}

variable "resource_group" {
    type = object({
      name = string
      location = string
      id = string
  })
}

variable "storage_account" {
    type = object({
      name = string
      id = string
      primary_access_key = string
    })
}

variable "storage_container_name" {
  type = string
}

variable "instrumentation_key" {
  type = string
}