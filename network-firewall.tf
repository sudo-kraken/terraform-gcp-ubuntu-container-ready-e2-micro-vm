##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
## Network Firewall Rules - Main ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

# Allow http
resource "google_compute_firewall" "allow-http" {
  name    = "default-fw-allow-http"
  network = default
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
}

# allow https
resource "google_compute_firewall" "allow-https" {
  name    = "default-fw-allow-https"
  network = default
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["https-server"]
}

# allow ssh
resource "google_compute_firewall" "allow-ssh" {
  name    = "default-fw-allow-ssh"
  network = default
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh"]
}
