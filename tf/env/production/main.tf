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

  monitor_do_image         = "ubuntu-20-04-x64"
  monitor_do_instance_size = "s-1vcpu-1gb"
  monitor_do_region        = "sfo2"
  monitor_ssh_pub_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMRjAcQ+nJfGDsZd0T5HAsdo77xX1S1x8GpQXTLyKgAUTsP1vQl5uCM1iYQjvmbGjKFroE/bvNggVVIWdOS6O0z2xIVgFG7aOiIW40NG9Gsb7w7B/0GiWw2W+9FiTjfMlelAs1StFQtLUaYvVeWK6b+PiuN1sLVIz+OEIw0soX//55+FG6Hwyxf8i9/m0gpdGeziLQPl0B7tjDCxTlqpXMFJXwd9PWUdD+vzdzkPEGe18sG5PwQdOw5y75RMkKF3OgE7A6I52ORticqbm4lrU4bDmvoo7CNBu2nJVgI03qHQVY3SvCoJFkrI8MGi9hZgHUX5f7s5Bh36djAn5A+b7CYPnChr6CSecPAjFgxUFLrZThpq1t3BZzTN3cP+Qx5YcVBkc3ZAQidQX/WMUZkCkm6gFkd88uV1lNokdjBxAoOQPJlPmlRJB3F9LefwesCZ9BZj7Ccgj8N58KMaNH91UmCmt9A6QMBwtLnR2DYGGalT5vESLz1iiQJlmbBgaU8YLbgKAmO5PHfkJqEPpXvJfh5Vqlw44rfeadsSJUtSLcL1OzGCzmj/l3/yn/V0q9s3bmFCe4nkkgJqnrgTKa5IcDpWsTP4jESTYN5+8W6+khVth2kmAOoL6oDccWcIOcAbXlYmMUTaET0adj6VHnUnLQD0sm18ZnM3VMQc9zbnsYwQ=="

  compute_1_do_image         = "ubuntu-20-04-x64"
  compute_1_do_instance_size = "s-1vcpu-1gb"
  compute_1_do_region        = "sfo2"
  compute_1_ssh_pub_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMRjAcQ+nJfGDsZd0T5HAsdo77xX1S1x8GpQXTLyKgAUTsP1vQl5uCM1iYQjvmbGjKFroE/bvNggVVIWdOS6O0z2xIVgFG7aOiIW40NG9Gsb7w7B/0GiWw2W+9FiTjfMlelAs1StFQtLUaYvVeWK6b+PiuN1sLVIz+OEIw0soX//55+FG6Hwyxf8i9/m0gpdGeziLQPl0B7tjDCxTlqpXMFJXwd9PWUdD+vzdzkPEGe18sG5PwQdOw5y75RMkKF3OgE7A6I52ORticqbm4lrU4bDmvoo7CNBu2nJVgI03qHQVY3SvCoJFkrI8MGi9hZgHUX5f7s5Bh36djAn5A+b7CYPnChr6CSecPAjFgxUFLrZThpq1t3BZzTN3cP+Qx5YcVBkc3ZAQidQX/WMUZkCkm6gFkd88uV1lNokdjBxAoOQPJlPmlRJB3F9LefwesCZ9BZj7Ccgj8N58KMaNH91UmCmt9A6QMBwtLnR2DYGGalT5vESLz1iiQJlmbBgaU8YLbgKAmO5PHfkJqEPpXvJfh5Vqlw44rfeadsSJUtSLcL1OzGCzmj/l3/yn/V0q9s3bmFCe4nkkgJqnrgTKa5IcDpWsTP4jESTYN5+8W6+khVth2kmAOoL6oDccWcIOcAbXlYmMUTaET0adj6VHnUnLQD0sm18ZnM3VMQc9zbnsYwQ=="

}
