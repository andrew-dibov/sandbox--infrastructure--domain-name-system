locals {
  hostnames = {
    bast = "bastion"
    stub = "resolver-stub"
    recr = "resolver-recursor"
    root = "dns-root"
    tldd = "dns-top-level-domain"
    au_a = "dns-authoritative-a"
    au_b = "dns-authoritative-b"
    ho_a = "host-www-a"
    ho_b = "host-www-b"
  }
  hosts = {
    (local.hostnames.bast) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 5
      }

      network_interface = {
        nat                = true
        security_group_ids = [yandex_vpc_security_group.bastion.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "bast"
    },
    (local.hostnames.stub) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 5
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
    (local.hostnames.recr) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 5
      }

      network_interface = {
        nat                = false
        security_group_ids = [yandex_vpc_security_group.internal.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "recr"
    },
    (local.hostnames.root) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 5
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
    (local.hostnames.tldd) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 5
      }

      network_interface = {
        nat                = false
        security_group_ids = [yandex_vpc_security_group.internal.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "tldd"
    },
    (local.hostnames.au_a) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 5
      }

      network_interface = {
        nat                = false
        security_group_ids = [yandex_vpc_security_group.internal.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "au-a"
    },
    (local.hostnames.au_b) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 5
      }

      network_interface = {
        nat                = false
        security_group_ids = [yandex_vpc_security_group.internal.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "au-b"
    },
    (local.hostnames.ho_a) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 5
      }

      network_interface = {
        nat                = false
        security_group_ids = [yandex_vpc_security_group.internal.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "ho-a"
    },
    (local.hostnames.ho_b) = {
      resources = {
        cores         = 2
        memory        = 2
        core_fraction = 20
      }

      initialize_params = {
        size = 5
      }

      network_interface = {
        nat                = false
        security_group_ids = [yandex_vpc_security_group.internal.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      ansible_role = "ho-b"
    },
  }

  cloud_init_templates = {
    (local.hostnames.bast) = templatefile("${var.templates_dir}/cloud-config/bastion.tftpl", { pkgs = [] })
    (local.hostnames.stub) = templatefile("${var.templates_dir}/cloud-config/stub.tftpl", { pkgs= ["python3", "python3-pip", "ca-certificates", "curl"] })
    (local.hostnames.recr) = templatefile("${var.templates_dir}/cloud-config/default.tftpl", { pkgs = ["python3", "python3-pip"] })
    (local.hostnames.root) = templatefile("${var.templates_dir}/cloud-config/default.tftpl", { pkgs = ["python3", "python3-pip"] })
    (local.hostnames.tldd) = templatefile("${var.templates_dir}/cloud-config/default.tftpl", { pkgs = ["python3", "python3-pip"] })
    (local.hostnames.au_a) = templatefile("${var.templates_dir}/cloud-config/default.tftpl", { pkgs = ["python3", "python3-pip"] })
    (local.hostnames.au_b) = templatefile("${var.templates_dir}/cloud-config/default.tftpl", { pkgs = ["python3", "python3-pip"] })
    (local.hostnames.ho_a) = templatefile("${var.templates_dir}/cloud-config/default.tftpl", { pkgs = ["python3", "python3-pip"] })
    (local.hostnames.ho_b) = templatefile("${var.templates_dir}/cloud-config/default.tftpl", { pkgs = ["python3", "python3-pip"] })
  }
}
