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
      name = "tcrypt-production"
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

  networking_mail_cname_records = [
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

  networking_mail_mx_records = [
    {
      priority = 10
      value    = "mail.protonmail.ch."
    },
    {
      priority = 20
      value    = "mailsec.protonmail.ch."
    },
  ]

  networking_mail_txt_records = [
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
  networking_root_domain = "tcry.pt"

  storage_1_size_in_gb = 20

  compute_1_ssh_pub_key      = file("files/compute_access_1.pub")
  compute_1_do_image         = "ubuntu-20-04-x64"
  compute_1_do_instance_size = "s-1vcpu-1gb"
  compute_1_do_region        = "sfo2"
}
