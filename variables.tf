variable "env_code" {
  type    = string
  default = "training"
}

variable "vpc_name" {
  type    = string
  default = "default"
}

variable "my_public_ip" {
  description = "My local system public IP ..."
  default     = "71.200.239.209/32"
}
