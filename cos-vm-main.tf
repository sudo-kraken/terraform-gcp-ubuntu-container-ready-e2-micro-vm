##~~~~~~~~~~~~~~~~~~~~~##
## GCP Linux VM - Main ##
##~~~~~~~~~~~~~~~~~~~~~##

/* VM --------------------------------------------------------------------- */
resource "google_compute_instance" "gcp-cos-vm" {
  name         = "gcp-cos-vm-01"
  machine_type = var.vm_instance_type
  zone         = var.gcp_zone
  can_ip_forward = "true"
  allow_stopping_for_update = "true"
  tags         = ["ssh","http-server","https-server"]


/* Boot Disk --------------------------------------------------------------------- */
  boot_disk {
      initialize_params {
          image = var.cos_97
      }
  }

/* File Copy --------------------------------------------------------------------- 
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
 } */

/* Startup Script --------------------------------------------------------------------- */
  metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  } 
  
  metadata_startup_script = "${file("../startup/startup.sh")}"
  
  /* Network --------------------------------------------------------------------- */
  network_interface {
    network       = google_compute_network.vpc.name
    subnetwork    = google_compute_subnetwork.network_subnet.name
    access_config {
    }
  }

  /* Options --------------------------------------------------------------------- */
  scheduling {
    automatic_restart = true
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }

}

/* App Data Disk --------------------------------------------------------------------- */
resource "google_compute_disk" "app-data" {
  name    = "disk-app-server"
  type    = "pd-standard"
  zone    = "${var.gcp_zone}"
  size    = 20
  labels = {
    vm        = "gcp-cos-vm-01"
    managedby = "terraform"
  }  
}

resource "google_compute_attached_disk" "app-data" {
  disk     = google_compute_disk.app-data.id
  instance = google_compute_instance.gcp-cos-vm.id

}