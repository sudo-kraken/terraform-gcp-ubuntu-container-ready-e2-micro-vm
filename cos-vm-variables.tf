##~~~~~~~~~~~~~~~~~~~~~~~~~~##
## GCP COS VM - Variables   ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~##

variable "vm_instance_type" {
  type        = string
  description = "VM instance type"
  default     = "e2-micro"
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