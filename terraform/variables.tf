variable "vpc_net__name" {
  type    = string
  default = "dns-net"
}

variable "vpc_subnet__name" {
  type    = string
  default = "dns-sub"
}

variable "vpc_subnet__v4_cidr_blocks" {
  type    = list(string)
  default = ["10.0.0.0/24"]
}

variable "vpc_gw__name" {
  type    = string
  default = "dns-gw"
}

variable "vpc_rt__name" {
  type    = string
  default = "dns-rt"
}

variable "vpc_sg_bast__name" {
  type    = string
  default = "dns-sg-bastion"
}

variable "vpc_sg_towr__name" {
  type    = string
  default = "dns-sg-tower"
}

variable "vpc_sg_core__name" {
  type    = string
  default = "dns-sg-core"
}

variable "img__name" {
  type    = string
  default = "debian-12"
}

variable "ins__platform_id" {
  type    = string
  default = "standard-v3"
}

