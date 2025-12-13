variable "vpc_network_name" {
  type    = string
  default = "dns-net"
}

variable "vpc_subnet_name" {
  type    = string
  default = "dns-subnet"
}

variable "vpc_subnet_v4_cidr_blocks" {
  type    = list(string)
  default = ["10.0.0.0/24"]
}

# ---

resource "yandex_vpc_network" "network" {
  name = var.vpc_network_name
}

resource "yandex_vpc_subnet" "subnet" {
  network_id = yandex_vpc_network.network.id

  name           = var.vpc_subnet_name
  v4_cidr_blocks = var.vpc_subnet_v4_cidr_blocks
}

# ---

variable "security_group_bastion_name" {
  type    = string
  default = "dns-bastion-sg"
}

variable "security_group_internal_name" {
  type    = string
  default = "dns-internal-sg"
}

# ---

resource "yandex_vpc_security_group" "bastion" {
  network_id = yandex_vpc_network.network.id
  name       = var.security_group_bastion_name

  ingress {                # Входящий трафик : только SSH со всех адресов
    protocol       = "TCP" # Transmission Control Protocol
    port           = 22    # SSH
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {                                                   # Исходящий трайик : только SSH на адреса внутренней подсети
    protocol       = "TCP"                                   # Transmission Control Protocol
    port           = 22                                      # SSH
    v4_cidr_blocks = yandex_vpc_subnet.subnet.v4_cidr_blocks # Внутренняя подсеть
  }

  egress {                 # Исходящий трафик : любой трафик на все адреса
    protocol       = "ANY" # Любой протокол
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "internal" {
  network_id = yandex_vpc_network.network.id
  name       = var.security_group_internal_name

  ingress {                                                  # Входящий трафик : только через Bastion
    protocol          = "TCP"                                # Transmission Control Protocol 
    port              = 22                                   # SSH
    security_group_id = yandex_vpc_security_group.bastion.id # Bastion
  }

  ingress {                                                  # Входящий трафик : только DNS с хостов внутренней подсети
    protocol       = "UDP"                                   # User Datagram Protocol : ответ < 512 байт : скорость благодаря отсутствию трехэтапного квитирования
    port           = 53                                      # DNS
    v4_cidr_blocks = yandex_vpc_subnet.subnet.v4_cidr_blocks # Внутренняя подсеть
  }

  ingress {
    protocol       = "TCP"                                   # Transmission Control Protocol : ответ > 512 байт + трансфер зон по AXFR/IXFR
    port           = 53                                      # DNS
    v4_cidr_blocks = yandex_vpc_subnet.subnet.v4_cidr_blocks # Внутренняя подсеть
  }

  ingress { # Входящий трафик : общение хостов внутри подсети
    protocol       = "ANY"
    v4_cidr_blocks = yandex_vpc_subnet.subnet.v4_cidr_blocks # Внутренняя подсеть
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
