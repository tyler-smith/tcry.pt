data "template_file" "cloud_init" {
  template = file("${path.module}/scripts/cloud-init")
}

resource "digitalocean_droplet" "compute_workers_region_1" {
  count = var.compute_worker_distribution[0]

  name               = "compute-worker-${var.region_1}-${count.index + 1}"
  ipv6               = true
  private_networking = true
  monitoring         = true

  region   = var.region_1
  vpc_uuid = digitalocean_vpc.region_1.id

  image     = var.compute_worker_image
  size      = var.compute_worker_instance_size
  user_data = data.template_file.cloud_init.rendered

  volume_ids = length(var.storage_region_1_volumes) > count.index ? [digitalocean_volume.region_1[count.index].id] : []
}

resource "digitalocean_droplet" "compute_workers_region_2" {
  count = var.compute_worker_distribution[1]

  name               = "compute-worker-${var.region_2}-${count.index + 1}"
  ipv6               = true
  private_networking = true
  monitoring         = true

  region   = var.region_2
  vpc_uuid = digitalocean_vpc.region_2.id

  image     = var.compute_worker_image
  size      = var.compute_worker_instance_size
  user_data = data.template_file.cloud_init.rendered
}

