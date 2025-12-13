variable "compute_instance_platform_id" {
  type    = string
  default = "standard-v3"
}

locals {
  compute_instance_configs = {
    (local.compute_instance_names.bastion_name) = { # Bastion : NAT, public IP, SSH
      compute_instance_resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      compute_instance_initialize_params = {
        size = 10
      }

      compute_instance_network_interface = {
        nat = true
      }

      compute_instance_scheduling_policy = {
        preemptible = true
      }
    },
    (local.compute_instance_names.client_name) = { # Client : пользовательский хост
      compute_instance_resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      compute_instance_initialize_params = {
        size = 10
      }

      compute_instance_network_interface = {
        nat = false
      }

      compute_instance_scheduling_policy = {
        preemptible = true
      }
    },
    (local.compute_instance_names.resolver_name) = { # Unbound : рекурсивный сервер имен
      compute_instance_resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      compute_instance_initialize_params = {
        size = 10
      }

      compute_instance_network_interface = {
        nat = false
      }

      compute_instance_scheduling_policy = {
        preemptible = true
      }
    },
    (local.compute_instance_names.root_name) = { # bind9 : корневой сервер имен
      compute_instance_resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      compute_instance_initialize_params = {
        size = 10
      }

      compute_instance_network_interface = {
        nat = false
      }

      compute_instance_scheduling_policy = {
        preemptible = true
      }
    },
    (local.compute_instance_names.top_level_domain_name) = { # Knot DNS : сервер имен верхнего уровня
      compute_instance_resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      compute_instance_initialize_params = {
        size = 10
      }

      compute_instance_network_interface = {
        nat = false
      }

      compute_instance_scheduling_policy = {
        preemptible = true
      }
    },
    (local.compute_instance_names.authority_a_name) = { # PowerDNS : авторитативный сервер
      compute_instance_resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      compute_instance_initialize_params = {
        size = 10
      }

      compute_instance_network_interface = {
        nat = false
      }

      compute_instance_scheduling_policy = {
        preemptible = true
      }
    },
    (local.compute_instance_names.authority_b_name) = { # NSD : авторитативный сервер
      compute_instance_resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      compute_instance_initialize_params = {
        size = 10
      }

      compute_instance_network_interface = {
        nat = false
      }

      compute_instance_scheduling_policy = {
        preemptible = true
      }
    },
    (local.compute_instance_names.load_balancer_name) = { # haproxy : балансировка нагрузка
      compute_instance_resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      compute_instance_initialize_params = {
        size = 10
      }

      compute_instance_network_interface = {
        nat = false
      }

      compute_instance_scheduling_policy = {
        preemptible = true
      }
    },
  }

  compute_instance_cloud_init_templates = {
    (local.compute_instance_names.bastion_name)          = templatefile("${var.tpls_dir}/cloud-init-bastion.yaml.tftpl", { packages = [] })
    (local.compute_instance_names.client_name)           = templatefile("${var.tpls_dir}/cloud-init.yaml.tftpl", { packages = ["python3", "python3-pip", "iproute2"] })
    (local.compute_instance_names.resolver_name)         = templatefile("${var.tpls_dir}/cloud-init.yaml.tftpl", { packages = ["python3", "python3-pip", "iproute2"] })
    (local.compute_instance_names.root_name)             = templatefile("${var.tpls_dir}/cloud-init.yaml.tftpl", { packages = ["python3", "python3-pip", "iproute2"] })
    (local.compute_instance_names.top_level_domain_name) = templatefile("${var.tpls_dir}/cloud-init.yaml.tftpl", { packages = ["python3", "python3-pip", "iproute2"] })
    (local.compute_instance_names.authority_a_name)      = templatefile("${var.tpls_dir}/cloud-init.yaml.tftpl", { packages = ["python3", "python3-pip", "iproute2"] })
    (local.compute_instance_names.authority_b_name)      = templatefile("${var.tpls_dir}/cloud-init.yaml.tftpl", { packages = ["python3", "python3-pip", "iproute2"] })
    (local.compute_instance_names.load_balancer_name)    = templatefile("${var.tpls_dir}/cloud-init.yaml.tftpl", { packages = ["python3", "python3-pip", "iproute2"] })
  }
}

# ---

resource "yandex_compute_instance" "compute_instance" {
  for_each = local.compute_instance_configs

  zone        = yandex_vpc_subnet.subnet.zone
  platform_id = var.compute_instance_platform_id

  name     = each.key
  hostname = each.key

  resources {
    cores         = each.value.compute_instance_resources.cores
    memory        = each.value.compute_instance_resources.memory
    core_fraction = each.value.compute_instance_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.debian.id
      size     = each.value.compute_instance_initialize_params.size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = each.value.compute_instance_network_interface.nat
  }

  scheduling_policy {
    preemptible = each.value.compute_instance_scheduling_policy.preemptible
  }

  # CloudInit
  # - cloud-init status
  # - cloud-init status --long
  # - cat /var/log/cloud-init.log
  # - cat /var/log/cloud-init-output.log

  # ssh -o ProxyCommand="ssh -W %h:%p -i .auth/id-dns-bastion debian@158.160.53.245" -i .auth/id-dns-root debian@10.0.0.34
  # ssh -F ./.auth/ssh_config dns-resolver

  metadata = {
    ssh-keys  = "debian:${tls_private_key.key[each.key].public_key_openssh}"
    user-data = local.compute_instance_cloud_init_templates[each.key]
  }
}
