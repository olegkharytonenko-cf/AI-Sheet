variable "profile" {
    description = "Profile of deployment"
}

variable "ip_network_mgmt" {
  description = "Network part of Management CIDR"
  type        = string
  default     = "69.0"
}