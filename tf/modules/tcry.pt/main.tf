terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }
}

//
// Networking / DNS
//

resource "digitalocean_floating_ip" "proxy_1" {
  droplet_id = digitalocean_droplet.compute_1.id
  region     = digitalocean_droplet.compute_1.region
}

resource "digitalocean_domain" "root_domain" {
  name       = var.networking_root_domain
  ip_address = digitalocean_floating_ip.proxy_1.ip_address
}

resource "digitalocean_record" "mail_verification" {
  for_each = { for i, record in var.networking_mail_txt_records : i => record }

  domain = digitalocean_domain.root_domain.name
  type   = "TXT"
  name   = each.value.name
  value  = each.value.value
}

resource "digitalocean_record" "mail_mx" {
  for_each = { for i, record in var.networking_mail_mx_records : i => record }

  domain   = digitalocean_domain.root_domain.name
  type     = "MX"
  name     = "@"
  priority = each.value.priority
  value    = each.value.value
}

resource "digitalocean_record" "mail_cname" {
  for_each = { for i, record in var.networking_mail_cname_records : i => record }

  domain = digitalocean_domain.root_domain.name
  type   = "CNAME"
  name   = each.value.name
  value  = each.value.value
}

resource "digitalocean_record" "web_code_record" {
  domain = digitalocean_domain.root_domain.name
  name   = "code"
  type   = "A"
  value  = digitalocean_domain.root_domain.ip_address
}

resource "digitalocean_record" "web_go_record" {
  domain = digitalocean_domain.root_domain.name
  name   = "go"
  type   = "A"
  value  = digitalocean_domain.root_domain.ip_address
}

resource "digitalocean_record" "web_docker_record" {
  domain = digitalocean_domain.root_domain.name
  name   = "docker"
  type   = "A"
  value  = digitalocean_domain.root_domain.ip_address
}

//
// Storage
//

resource "digitalocean_volume" "storage_1" {
  name                    = "storage-1"
  region                  = var.compute_1_do_region
  size                    = var.storage_1_size_in_gb
  initial_filesystem_type = "ext4"
}

resource "digitalocean_spaces_bucket" "gomods" {
  name   = "tcrypt-gomods"
  region = var.compute_1_do_region
  acl    = "private"
}

resource "digitalocean_spaces_bucket" "s3" {
  name   = "tcrypt-s3"
  region = var.compute_1_do_region
  acl    = "private"
}

resource "digitalocean_spaces_bucket" "docker-registry" {
  name   = "tcrypt-docker"
  region = var.compute_1_do_region
  acl    = "private"
}

//
// Compute
//


resource "digitalocean_ssh_key" "compute_access" {
  name       = "compute access"
  public_key = var.compute_ssh_pub_key
}

resource "digitalocean_droplet" "compute_1" {
  name               = "compute-1"
  private_networking = true
  region             = var.compute_1_do_region
  image              = var.compute_1_do_image
  size               = var.compute_1_do_instance_size
  ssh_keys           = [digitalocean_ssh_key.compute_access.fingerprint]
  volume_ids         = [digitalocean_volume.storage_1.id]
}

resource "digitalocean_droplet" "monitor" {
  name               = "monitor"
  private_networking = true
  region             = var.monitor_do_region
  image              = var.monitor_do_image
  size               = var.monitor_do_instance_size
  ssh_keys           = [digitalocean_ssh_key.compute_access.fingerprint]
}
