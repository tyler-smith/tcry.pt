variable "root_domain" {
  type = string
}

variable "region_1" {
  type = string
}

variable "region_2" {
  type = string
}

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

variable "storage_1_size_in_gb" {
  type = number
}

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
