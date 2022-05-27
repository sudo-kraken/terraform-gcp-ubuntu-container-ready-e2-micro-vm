##~~~~~~~~~~~~~~~~~~~~~~~~~~##
## GCP COS VM - Variables   ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~##

variable "linux_instance_type" {
  type        = string
  description = "VM instance type"
  default     = "e2-micro"
}

variable "email_address" {
  type        = string
  description = "Email Address"
}

variable "admin_password" {
  type        = string
  description = "Admin Password"
}

variable "root_domain" {
  type        = string
  description = "Root Domain for hosting services"
}

