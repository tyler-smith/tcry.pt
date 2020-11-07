//
// Provider
//

//variable "provider_do_token" {}
//variable "provider_do_spaces_access_id" {}
//variable "provider_do_spaces_secret_key" {}

//
// Networking
//

variable "networking_root_domain" {
  type = string
}

//
// Compute
//

variable "monitor_ssh_pub_key" {
  type = string
}

variable "monitor_do_region" {
  type = string
}

variable "monitor_do_image" {
  type = string
}

variable "monitor_do_instance_size" {
  type = string
}

variable "compute_1_ssh_pub_key" {
  type = string
}

variable "compute_1_do_region" {
  type = string
}

variable "compute_1_do_image" {
  type = string
}

variable "compute_1_do_instance_size" {
  type = string
}

//
// Storage
//

variable "storage_1_size_in_gb" {
  type = number
}

//
// Mail
//

variable "networking_mail_txt_records" {
  type = list(object({
    name  = string
    value = string
  }))
}

variable "networking_mail_mx_records" {
  type = list(object({
    value    = string
    priority = number
  }))
}

variable "networking_mail_cname_records" {
  type = list(object({
    name  = string
    value = string
  }))
}
