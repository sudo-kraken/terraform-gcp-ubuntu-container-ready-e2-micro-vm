##~~~~~~~~~~~~~~~~~~~~~##
## GCP Linux VM - Main ##
##~~~~~~~~~~~~~~~~~~~~~##

# Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 4
}

# Bootstrapping Script to Update VM
data "template_file" "linux-metadata" {
template = <<EOF
sudo apt-get update;
EOF
}

# Create VM
resource "google_compute_instance" "vm_instance_public" {
  name         = "gcp-vm-01-${random_id.instance_id.hex}"
  machine_type = var.linux_instance_type
  zone         = var.gcp_zone
  # only add hostname if you want to put this on your domain
  #hostname     = "gcp-vm-01-${random_id.instance_id.hex}"
  tags         = ["ssh"]

  boot_disk {
    initialize_params {
      image = var.debian_11
    }
  }

  metadata_startup_script = data.template_file.linux-metadata.rendered

  network_interface {
    network       = google_compute_network.vpc.name
    subnetwork    = google_compute_subnetwork.network_subnet.name
    access_config { }
  }
}
