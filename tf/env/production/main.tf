terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "tcrypt"

    workspaces {
      name = "production-tcrypt"
    }
  }
}

variable "provider_do_token" {}
variable "provider_do_spaces_access_id" {}
variable "provider_do_spaces_secret_key" {}

provider "digitalocean" {
  token             = var.provider_do_token
  spaces_access_id  = var.provider_do_spaces_access_id
  spaces_secret_key = var.provider_do_spaces_secret_key
}

module "tcrypt" {
  source = "../../modules/tcry.pt"

  env = "production"

  root_domain = "tcry.pt"

  region_1 = "sfo2"
  region_2 = "sgp1"

  storage_region_1_volumes = [20]

  compute_beacon_image         = "ubuntu-20-04-x64"
  compute_beacon_instance_size = "s-1vcpu-1gb"

  compute_worker_image         = "ubuntu-20-04-x64"
  compute_worker_instance_size = "s-1vcpu-1gb"
  compute_worker_distribution  = [2, 1]

  compute_ssh_pub_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3YZKXgdbLQ5b0U3krcM/5vAwATXdWZorAsaqqNzPXy"

  network_internal_proxy_ip_address = "100.76.128.85"
  network_vpc_1_cidr                = "10.2.0.0/20"
  network_vpc_2_cidr                = "10.4.0.0/20"

  network_mail_cname_records = [
    {
      name  = "protonmail._domainkey"
      value = "protonmail.domainkey.dphg5th7spizk4rifzm6xds24bsasvxyop6giavg2t4gykahuyhbq.domains.proton.ch."
    },
    {
      name  = "protonmail2._domainkey"
      value = "protonmail2.domainkey.dphg5th7spizk4rifzm6xds24bsasvxyop6giavg2t4gykahuyhbq.domains.proton.ch."
    },
    {
      name  = "protonmail3._domainkey"
      value = "protonmail3.domainkey.dphg5th7spizk4rifzm6xds24bsasvxyop6giavg2t4gykahuyhbq.domains.proton.ch."
    },
  ]
  network_mail_mx_records = [
    {
      priority = 10
      value    = "mail.protonmail.ch."
    },
    {
      priority = 20
      value    = "mailsec.protonmail.ch."
    },
  ]
  network_mail_txt_records = [
    {
      name  = "@"
      value = "protonmail-verification=b11ecaa061e81370afb2f0023cda3e0a57ba23b0"
    },
    {
      name  = "@"
      value = "v=spf1 include:_spf.protonmail.ch mx ~all"
    },
    {
      name  = "_dmarc"
      value = "v=DMARC1; p=quarantine; rua=mailto:mail@tcry.pt"
    },
  ]
}
