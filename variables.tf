variable "region" {
  type        = string
  default = "us-east-1"
}

variable "env_code" {
  type        = string
  default = "training"
}

variable "public" {
  type        = string
  default = "FrontEnd"
}

variable "private" {
  type        = string
  default = "BackEnd"
}

variable "igw" {
  type        = string
  default = "main"
}

variable "ngw" {
  type        = string
  default = "main"
}

variable "rt" {
  type        = string
  default = "public"
}

variable "rtp" {
  type        = string
  default = "private"
}

