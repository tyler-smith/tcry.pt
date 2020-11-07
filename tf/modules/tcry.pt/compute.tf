resource "digitalocean_ssh_key" "compute_access" {
  name       = "compute access"
  public_key = var.compute_ssh_pub_key
}

resource "digitalocean_droplet" "compute_beacon" {
  name               = "compute-beacon"
  ipv6               = true
  private_networking = true
  monitoring         = true

  region   = var.region_1
  vpc_uuid = digitalocean_vpc.region_1.id

  image    = var.compute_beacon_image
  size     = var.compute_beacon_instance_size
  ssh_keys = [digitalocean_ssh_key.compute_access.fingerprint]
}

resource "digitalocean_droplet" "compute_worker_1" {
  name               = "compute-worker-1"
  ipv6               = true
  private_networking = true
  monitoring         = true

  region   = var.region_1
  vpc_uuid = digitalocean_vpc.region_1.id

  image      = var.compute_worker_image
  size       = var.compute_worker_instance_size
  volume_ids = [digitalocean_volume.storage_1.id]
  ssh_keys   = [digitalocean_ssh_key.compute_access.fingerprint]
}

