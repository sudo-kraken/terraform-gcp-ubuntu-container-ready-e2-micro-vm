##~~~~~~~~~~~~~~~~~~~~~~~~~~##
## GCP Linux VM - Variables ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~##

variable "linux_instance_type" {
  type        = string
  description = "VM instance type"
  default     = "e2-micro"
}
