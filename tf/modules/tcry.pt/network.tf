resource "digitalocean_vpc" "region_1" {
  name     = "tcrypt-${var.env}-${var.region_1}"
  region   = var.region_1
  ip_range = var.network_vpc_1_cidr
}

resource "digitalocean_vpc" "region_2" {
  name     = "tcrypt-${var.env}-${var.region_2}"
  region   = var.region_2
  ip_range = var.network_vpc_2_cidr
}

//
// EIPs point to ingress-handling compute instances
//

resource "digitalocean_floating_ip" "proxy_1" {
  region     = var.region_1
  droplet_id = digitalocean_droplet.compute_workers_region_1.0.id
}

//
// DNS points to EIPs
// Wildcard default to the web proxy
//

resource "digitalocean_domain" "root" {
  name       = var.root_domain
  ip_address = digitalocean_floating_ip.proxy_1.ip_address
}

resource "digitalocean_record" "root_wildcard" {
  domain = digitalocean_domain.root.name
  name   = "*"
  type   = "A"
  value  = digitalocean_floating_ip.proxy_1.ip_address
}

resource "digitalocean_record" "internal" {
  domain = digitalocean_domain.root.name
  name   = "in"
  type   = "A"
  value  = var.network_internal_proxy_ip_address
}

resource "digitalocean_record" "internal_wildcard" {
  domain = digitalocean_domain.root.name
  name   = "*.in"
  type   = "A"
  value  = var.network_internal_proxy_ip_address
}

//
// Mail
//

resource "digitalocean_record" "mail_verification" {
  for_each = { for i, record in var.network_mail_txt_records : i => record }

  domain = digitalocean_domain.root.name
  type   = "TXT"
  name   = each.value.name
  value  = each.value.value
}

resource "digitalocean_record" "mail_mx" {
  for_each = { for i, record in var.network_mail_mx_records : i => record }

  domain   = digitalocean_domain.root.name
  type     = "MX"
  name     = "@"
  priority = each.value.priority
  value    = each.value.value
}

resource "digitalocean_record" "mail_cname" {
  for_each = { for i, record in var.network_mail_cname_records : i => record }

  domain = digitalocean_domain.root.name
  type   = "CNAME"
  name   = each.value.name
  value  = each.value.value
}

