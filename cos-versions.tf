##~~~~~~~~~~~~~~~~~##
## Debian Versions ##
##~~~~~~~~~~~~~~~~~##

variable "debian_9" {
  type        = string
  description = "Debian 9"
  default     = "debian-cloud/debian-9"
}

variable "debian_10" {
  type        = string
  description = "Debian 10"
  default     = "debian-cloud/debian-10"
}

variable "debian_11" {
  type        = string
  description = "Debian 11"
  default     = "debian-cloud/debian-11"
