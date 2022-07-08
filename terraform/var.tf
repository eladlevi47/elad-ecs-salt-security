variable "RegionCode" {
  type        = string
  description = "region code"
  default     = "us-west-2"
}

variable "ip_addresses1" {
  type        = any
  description = "ip_addresses"
  default     = "147.236.179.190/32"
}

variable "ip_addresses2" {
  type        = any
  description = "ip_addresses"
  default     = "46.121.98.188/32"
}
