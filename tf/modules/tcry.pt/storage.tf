resource "digitalocean_volume" "storage_1" {
  name                    = "storage-1"
  region                  = var.region_1
  size                    = var.storage_1_size_in_gb
  initial_filesystem_type = "ext4"
}

resource "digitalocean_spaces_bucket" "gomods" {
  name   = "tcrypt-gomods"
  region = var.region_1
  acl    = "private"
}

resource "digitalocean_spaces_bucket" "s3" {
  name   = "tcrypt-s3"
  region = var.region_1
  acl    = "private"
}

resource "digitalocean_spaces_bucket" "docker-registry" {
  name   = "tcrypt-docker"
  region = var.region_1
  acl    = "private"
}
