locals {
  hostnames = {
    bastion   = "bastion"
    stub      = "stub"
    recursive = "recursive"
    root      = "root"
    tld       = "tld"
    auth_a    = "auth-a"
    auth_b    = "auth-b"
    www_a     = "www-a"
    www_b     = "www-b"
  }
  hosts = {
    (local.hostnames.bastion) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 10
      }

      network_interface = {
        nat                = true
        security_group_ids = [yandex_vpc_security_group.bastion.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "bastion"
    },
    (local.hostnames.stub) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 10
      }

      network_interface = {
        nat                = false
        security_group_ids = [yandex_vpc_security_group.internal.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "stub"
    },
    (local.hostnames.recursive) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 10
      }

      network_interface = {
        nat                = false
        security_group_ids = [yandex_vpc_security_group.internal.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "recursive"
    },
    (local.hostnames.root) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 10
      }

      network_interface = {
        nat                = false
        security_group_ids = [yandex_vpc_security_group.internal.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "root"
    },
    (local.hostnames.tld) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 10
      }

      network_interface = {
        nat                = false
        security_group_ids = [yandex_vpc_security_group.internal.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "tld"
    },
    (local.hostnames.auth_a) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 10
      }

      network_interface = {
        nat                = false
        security_group_ids = [yandex_vpc_security_group.internal.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "auth-a"
    },
    (local.hostnames.auth_b) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 10
      }

      network_interface = {
        nat                = false
        security_group_ids = [yandex_vpc_security_group.internal.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "auth-b"
    },
    (local.hostnames.www_a) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 10
      }

      network_interface = {
        nat                = false
        security_group_ids = [yandex_vpc_security_group.internal.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "www-a"
    },
    (local.hostnames.www_b) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 10
      }

      network_interface = {
        nat                = false
        security_group_ids = [yandex_vpc_security_group.internal.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "www-b"
    },
  }

  cloud_init_templates = {
    (local.hostnames.bastion)   = templatefile("${var.templates_dir}/cloud-init/bastion.yaml.tftpl", { packages = [] })
    (local.hostnames.stub)      = templatefile("${var.templates_dir}/cloud-init/default.yaml.tftpl", { packages = ["python3", "python3-pip", "iproute2"] })
    (local.hostnames.recursive) = templatefile("${var.templates_dir}/cloud-init/recursive-resolver.yaml.tftpl", { packages = ["python3", "python3-pip"] })
    (local.hostnames.root)      = templatefile("${var.templates_dir}/cloud-init/default.yaml.tftpl", { packages = ["python3", "python3-pip"] })
    (local.hostnames.tld)       = templatefile("${var.templates_dir}/cloud-init/default.yaml.tftpl", { packages = ["python3", "python3-pip"] })
    (local.hostnames.auth_a)    = templatefile("${var.templates_dir}/cloud-init/default.yaml.tftpl", { packages = ["python3", "python3-pip"] })
    (local.hostnames.auth_b)    = templatefile("${var.templates_dir}/cloud-init/default.yaml.tftpl", { packages = ["python3", "python3-pip"] })
    (local.hostnames.www_a)     = templatefile("${var.templates_dir}/cloud-init/default.yaml.tftpl", { packages = ["python3", "python3-pip"] })
    (local.hostnames.www_b)     = templatefile("${var.templates_dir}/cloud-init/default.yaml.tftpl", { packages = ["python3", "python3-pip"] })
  }
}
