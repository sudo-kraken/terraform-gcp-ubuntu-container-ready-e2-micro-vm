##~~~~~~~~~~~~~~~~~~~~~##
## GCP Linux VM - Main ##
##~~~~~~~~~~~~~~~~~~~~~##

# Create VM
resource "google_compute_instance" "gcp-cos-vm" {
  name         = "gcp-cos-vm-01"
  machine_type = var.vm_instance_type
  zone         = var.gcp_zone
  can_ip_forward = "true"
  allow_stopping_for_update = "true"
  tags         = ["ssh","http-server","https-server"]

 
  boot_disk {
    initialize_params {
      type  = "pd-standard"   
      image = var.cos_97
    }
  }

/* Disk --------------------------------------------------------------------- */

resource "google_compute_disk" "default" {
  name    = "disk-app-server"
  type    = "pd-standard"
  zone    = "${var.gcp_zone}"
  size    = 20
}

resource "google_compute_attached_disk" "default" {
  disk     = google_compute_disk.default.id
  instance = google_compute_instance.gcp-cos-vm.id

}

  metadata {
        startup-script = <<SCRIPT
        apt-get -y update
        fsck.ext4 -tvy /dev/sdb || mkfs.ext4 /dev/sdb
        mkdir -p /mnt/diskd/docker
        mount -o defaults -t ext4 /dev/sdb /mnt/disks/docker
        mkdir -p /mnt/docker/projects/app
        SCRIPT
    } 


provisioner "file" {
   # source file name on the local machine where you execute terraform plan and apply
   source      = "../compose_files/docker-compose.yaml"
   # destination is the file location on the newly created instance
   destination = "/mnt/disks/docker/projects/app/docker-compose.yaml"
   connection {
     host        = google_compute_instance.gcp-cos-vm.network_interface.0.access_config.0.nat_ip
     type        = "ssh"
     # username of the instance would vary for each account refer the OS Login in GCP documentation
     user        = var.user
     timeout     = "500s"
     private_key = file(var.privatekeypath)
   }
   # Commands to be executed as the instance gets ready.
   # installing nginx
   #inline = [
   #  "chmod a+x /tmp/startupscript.sh",
   #  "sed -i -e 's/\r$//' /tmp/startupscript.sh",
   #  "sudo /tmp/startupscript.sh"
   #]
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

  metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }

}