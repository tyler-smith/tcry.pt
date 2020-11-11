//
// Base settings
//

variable "env" {
  type = string
}

variable "root_domain" {
  type = string
}

variable "region_1" {
  type = string
}

variable "region_2" {
  type = string
}

//
// Network
//

variable "network_vpc_1_ip_range" {
  type = string
}

variable "network_mail_txt_records" {
  type = list(object({
    name  = string
    value = string
  }))
}

variable "network_mail_mx_records" {
  type = list(object({
    value    = string
    priority = number
  }))
}

variable "network_mail_cname_records" {
  type = list(object({
    name  = string
    value = string
  }))
}

//
// Storage
//

variable "storage_1_size_in_gb" {
  type = number
}
//
// Compute
//

variable "compute_ssh_pub_key" {
  type = string
}

variable "compute_beacon_image" {
  type = string
}

variable "compute_beacon_instance_size" {
  type = string
}

variable "compute_worker_image" {
  type = string
}

variable "compute_worker_instance_size" {
  type = string
}

variable "compute_worker_distribution" {
  type = tuple([number, number])
}
