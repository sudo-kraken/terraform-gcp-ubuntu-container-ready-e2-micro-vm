##~~~~~~~~~~~~~~~~~~~~~~~~~~##
## Terraform - Variables ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~##

# Please update all the info below with your own project ID, region you want this hosted in, network CIDR and instance type.

# GCP Settings
gcp_project   = "PROJECT-ID-HERE"
gcp_region    = "us-west1"
gcp_zone      = "us-west1-a"
gcp_auth_file = "../auth/google-key.json"

# GCP Netwok
network-subnet-cidr = "10.0.10.0/24"

# Linux VM
vm_instance_type = "e2-micro"
user = "middlewareinvetory_gmail_com" # this should match the username set by the OS Login
email = "tf-serviceaccount@PROJECTNAME.iam.gserviceaccount.com" # this should match the service account we set earlier
