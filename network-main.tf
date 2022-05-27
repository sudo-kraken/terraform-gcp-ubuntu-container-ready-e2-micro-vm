##~~~~~~~~~~~~~~~~##
## Network - Main ##
##~~~~~~~~~~~~~~~~##

# Update IDENTIFIER in the name fields below with something unique to you like VM name or your initials.

# Create VPC
resource "google_compute_network" "vpc" {
  name                    = "IDENTIFIER-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

# create public subnet
resource "google_compute_subnetwork" "network_subnet" {
  name          = "IDENTIFIER-subnet"
  ip_cidr_range = var.network-subnet-cidr
  network       = google_compute_network.vpc.name
  region        = var.gcp_region
}
