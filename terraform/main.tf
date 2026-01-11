# terraform.tfvars
variable "yandex_cloud__cloud_id" {
  type = string
}

# terraform.tfvars
variable "yandex_cloud__folder_id" {
  type = string
}

# terraform.tfvars
variable "yandex_cloud__zone_id" {
  type = string
}

# terraform.tfvars
variable "auth__dir" {
  type = string
}

# terraform.tfvars
variable "tf_templates__dir" {
  type = string
}

# terraform.tfvars
variable "sa_key__name" {
  type = string
}

# terraform.tfvars
variable "py__version" {
  type = string
}

# terraform.tfvars
variable "ansible__dir" {
  type = string
}

# ---

terraform {
  required_version = "~> 1.14.0" # 1.14.X

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.174.0" # 0.174.X
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.1.0" # 4.1.X
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.6.1" # 2.6.X
    }
  }
}

provider "yandex" {
  cloud_id                 = var.yandex_cloud__cloud_id
  folder_id                = var.yandex_cloud__folder_id
  zone                     = var.yandex_cloud__zone_id
  service_account_key_file = "${var.auth__dir}/${var.sa_key__name}"
}
