##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     Ubuntu Versions           ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
##     Change as Required        ##
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

variable "ubnt_1804" {
  type        = string
  description = "Ubuntu Minimal - 18.04 - Bionic - LTS"
  default     = "ubuntu-os-cloud/ubuntu-minimal-1804-lts"
}

variable "ubnt_2004" {
  type        = string
  description = "Ubuntu Minimal - 20.04 - Focal - LTS"
  default     = "ubuntu-os-cloud/ubuntu-minimal-2004-lts"
}

variable "ubnt_2204" {
  type        = string
  description = "Ubuntu Minimal - 22.04 - Jammy - LTS"
  default     = "ubuntu-os-cloud/ubuntu-minimal-2204-lts"
}