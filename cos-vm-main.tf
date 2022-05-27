##~~~~~~~~~~~~~~~~~~~~~##
## GCP Linux VM - Main ##
##~~~~~~~~~~~~~~~~~~~~~##

# Prepare persistent disk
locals {
  cloudinit_disk = <<EOT
#cloud-config
bootcmd:
  - fsck.ext4 -tvy /dev/sdb || mkfs.ext4 /dev/sdb
  - mkdir -p /mnt/docker
  - mount -o defaults -t ext4 /dev/sdb /mnt/docker
EOT
}

# Create VM
resource "google_compute_instance" "gcp-cos-vm" {
  name         = "gcp-cos-vm-01"
  machine_type = var.vm_instance_type
  zone         = var.gcp_zone
  can_ip_forward = "true"
  allow_stopping_for_update = "true"
  tags         = ["ssh","http-server","https-server"]

  metadata = {
    user-data = module.container-server.cloud_config
  }

  boot_disk {
    initialize_params {
      type  = "pd-standard"   
      image = var.cos_97
    }
  }

  # Define Network
  network_interface {
    network       = google_compute_network.vpc.name
    subnetwork    = google_compute_subnetwork.network_subnet.name
    access_config {
    }
  }

  scheduling {
    automatic_restart = true
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }
}

/* Disk --------------------------------------------------------------------- */

resource "google_compute_disk" "default" {
  name    = "disk-app-server"
  type    = "pd-standard"
  zone    = "${var.gcp_region}-b"
  size    = 20
}

resource "google_compute_attached_disk" "default" {
  disk     = google_compute_disk.default.id
  instance = google_compute_instance.gcp-cos-vm.id
}

provisioner "file" {
  source      = "../compose_files/docker-compose.yaml"
  destination = "/mnt/docker/projects/app/docker-compose.yaml"
}

