resource "digitalocean_volume" "region_1" {
  count                   = length(var.storage_region_1_volumes)
  name                    = "storage-${var.region_1}-1"
  region                  = var.region_1
  size                    = var.storage_region_1_volumes[count.index]
  initial_filesystem_type = "ext4"
}

