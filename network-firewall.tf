##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
## Network Firewall Rules - Main ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     Change as Required        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

# Allow http
resource "google_compute_firewall" "allow-http" {
  name    = "IDENTIFIER-fw-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
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
  target_tags = ["https-server"]
}

# allow ssh
resource "google_compute_firewall" "allow-ssh" {
  name    = "IDENTIFIER-fw-allow-http-fw-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["ssh"]
}
