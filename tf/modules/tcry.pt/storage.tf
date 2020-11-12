resource "digitalocean_volume" "storage_1" {
  name                    = "storage-1"
  region                  = var.region_1
  size                    = var.storage_1_size_in_gb
  initial_filesystem_type = "ext4"
}

