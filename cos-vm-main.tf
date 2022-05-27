##~~~~~~~~~~~~~~~~~~~~~##
## GCP Linux VM - Main ##
##~~~~~~~~~~~~~~~~~~~~~##

# Add module for cloudinit
module "container-server" {
  source  = "christippett/container-server/cloudinit"
  version = "~> 1.2"

  # change for your domain and also in the env section
  domain = "gcp.${var.root_domain}"
  email  = var.email_address

  files = [
    {
      filename = "docker-compose.yaml"
      content  = filebase64("${path.module}/../compose_files/docker-compose.yaml")
    }
  ]
  env = {
    TRAEFIK_API_DASHBOARD = false
    DOCKER_APP_DATA       = "/run/app"
    ADMIN_EMAIL           = var.email_address
    ADMIN_PASSWORD        = var.admin_password
    INET_DOMAIN           = "gcp.${var.root_domain}"
  }

  # Extra cloud-init config provided to setup and format persistent disk
  cloudinit_part = [{
    content_type = "text/cloud-config"
    content      = local.cloudinit_disk
  }]
}

# Prepare persistent disk
locals {
  cloudinit_disk = <<EOT
#cloud-config
bootcmd:
  - fsck.ext4 -tvy /dev/sdb || mkfs.ext4 /dev/sdb
  - mkdir -p /run/app
  - mount -o defaults -t ext4 /dev/sdb /run/app
EOT
}

# Create VM
resource "google_compute_instance" "gcp-cos-vm" {
  name         = "gcp-cos-vm-01"
  machine_type = var.linux_instance_type
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
      # https://cloud.google.com/compute/docs/images/os-details
      image = data.google_compute_image.cos.self_link
    }
  }

  # Define Network
  network_interface {
    network = "default"
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
  instance = google_compute_instance.pluto.id
}


