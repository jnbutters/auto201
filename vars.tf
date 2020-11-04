variable "f5_ami_search_name" {
  description = "filter used to find AMI for deployment"
  default     = "F5*BIGIP-15.1.1*Best*25Mbps*"
}

variable "prefix" {
  description = "Prefix used for deployment"
  default     = "auto201"
}