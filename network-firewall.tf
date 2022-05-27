##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
## Network Firewall Rules - Main ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

# Update IDENTIFIER in each of the rule names to be something related to the vm or user I just use vmname or my initials usually.

# Allow http
resource "google_compute_firewall" "allow-http" {
  name    = "IDENTIFIER-fw-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http"]
}

# allow https
resource "google_compute_firewall" "allow-https" {
  name    = "IDENTIFIER-fw-allow-https"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["https"]
}

# allow ssh
resource "google_compute_firewall" "allow-ssh" {
  name    = "IDENTIFIER-fw-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh"]
}

# allow rdp
resource "google_compute_firewall" "allow-rdp" {
  name    = "IDENTIFIER-fw-allow-rdp"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["rdp"]
}
