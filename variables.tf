variable "domain_name" {
  type = string
  description = "The domain name for the website(recordset_name.zone_name). It is the name of main bucket."
}

variable "redirector_bucket_name" {
  type = string
  description = "The name of the redirector bucket(redirector_recordset_name.zone_name). Normally without the www.prefix of main bucket"
}

variable "recordset_name" {
  type = string
  description = "The record set name for the website."
}

variable "redirector_recordset_name" {
  type = string
  description = "The record set name for the redirector."
}

variable "website_root" {
  type = string
  description = "The website root(path)"
}

variable "zone_name" {
  type = string
  description = "The name of DNS Zone"
}

variable "rg_name" {
  type = string
  description = "The name of the resource group of DNS Zone"
}

variable "root_object" {
  type = string
  description = "The name of the root object"
}

variable "error_object" {
  type = string
  description = "The name of the object to get error message"
}