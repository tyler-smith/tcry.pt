resource "digitalocean_vpc" "region_1" {
  name     = "tcrypt-${var.env}-${var.region_1}"
  region   = var.region_1
  ip_range = var.network_vpc_1_ip_range
}

//
// EIPs point to ingress-handling compute instances
//

resource "digitalocean_floating_ip" "beacon" {
  droplet_id = digitalocean_droplet.compute_beacon.id
  region     = digitalocean_droplet.compute_beacon.region
}

resource "digitalocean_floating_ip" "proxy_1" {
  droplet_id = digitalocean_droplet.compute_worker_1.id
  region     = digitalocean_droplet.compute_worker_1.region
}

//
// DNS points to EIPs
//

resource "digitalocean_domain" "beacon_domain" {
  name       = var.beacon_domain
  ip_address = digitalocean_floating_ip.beacon.ip_address
}

resource "digitalocean_domain" "root_domain" {
  name       = var.root_domain
  ip_address = digitalocean_floating_ip.proxy_1.ip_address
}

//
// Point all web subdomains to proxy 1
//

resource "digitalocean_record" "web_code_record" {
  domain = digitalocean_domain.root_domain.name
  name   = "code"
  type   = "A"
  value  = digitalocean_floating_ip.proxy_1.ip_address
}

resource "digitalocean_record" "web_go_record" {
  domain = digitalocean_domain.root_domain.name
  name   = "go"
  type   = "A"
  value  = digitalocean_floating_ip.proxy_1.ip_address
}

resource "digitalocean_record" "web_docker_record" {
  domain = digitalocean_domain.root_domain.name
  name   = "docker"
  type   = "A"
  value  = digitalocean_floating_ip.proxy_1.ip_address
}

//
// Mail
//

resource "digitalocean_record" "mail_verification" {
  for_each = { for i, record in var.network_mail_txt_records : i => record }

  domain = digitalocean_domain.root_domain.name
  type   = "TXT"
  name   = each.value.name
  value  = each.value.value
}

resource "digitalocean_record" "mail_mx" {
  for_each = { for i, record in var.network_mail_mx_records : i => record }

  domain   = digitalocean_domain.root_domain.name
  type     = "MX"
  name     = "@"
  priority = each.value.priority
  value    = each.value.value
}

resource "digitalocean_record" "mail_cname" {
  for_each = { for i, record in var.network_mail_cname_records : i => record }

  domain = digitalocean_domain.root_domain.name
  type   = "CNAME"
  name   = each.value.name
  value  = each.value.value
}

