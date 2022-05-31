##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##  GCP Ubuntu VM - Variables    ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     Change as Required        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

variable "vm_instance_type" {
  type        = string
  description = "VM instance type"
  default     = "e2-micro"
}

variable "vm_name" {
  type        = string
  description = "VM name"
}

variable "privatekeypath" {
    type = string
    default = "~/.ssh/sshkey"
}

variable "publickeypath" {
    type = string
    default = "~/.ssh/sshkey.pub"
}

variable "user" {
    type = string
}

variable "email" {
    type = string
}