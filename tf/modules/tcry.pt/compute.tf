data "template_file" "cloud_init" {
  template = file("${path.module}/scripts/cloud-init")
}

resource "digitalocean_ssh_key" "terraform" {
  name       = "terraform"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3YZKXgdbLQ5b0U3krcM/5vAwATXdWZorAsaqqNzPXy"
}

resource "digitalocean_droplet" "compute_beacon" {
  name               = "compute-beacon"
  ipv6               = true
  private_networking = true
  monitoring         = true

  region   = var.region_1
  vpc_uuid = digitalocean_vpc.region_1.id

  image = var.compute_beacon_image
  size  = var.compute_beacon_instance_size

  user_data = data.template_file.cloud_init.rendered
  ssh_keys  = [digitalocean_ssh_key.terraform.fingerprint]
}

resource "digitalocean_droplet" "compute_worker_1" {
  name               = "compute-worker-1"
  ipv6               = true
  private_networking = true
  monitoring         = true

  region   = var.region_1
  vpc_uuid = digitalocean_vpc.region_1.id

  image = var.compute_worker_image
  size  = var.compute_worker_instance_size
  volume_ids = [
  digitalocean_volume.storage_1.id]

  user_data = data.template_file.cloud_init.rendered
  ssh_keys  = [digitalocean_ssh_key.terraform.fingerprint]
}

