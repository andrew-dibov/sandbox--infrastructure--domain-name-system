locals {
  inss__names = {
    towr = "dns-ins-tower"
    bast = "dns-ins-bastion"
    root = "dns-ins-root"
    tldd = "dns-ins-top-level-domain"
    au_a = "dns-ins-authoritative-a"
    au_b = "dns-ins-authoritative-b"
    recr = "dns-ins-recursor"
    stub = "dns-ins-stub"
  }
  inss__confs = {
    (local.inss__names.towr) = {
      description = "observability instance : towr : prometheus + ELK"

      resources = {
        cores         = 4
        memory        = 4
        core_fraction = 20
      }

      initialize_params = {
        size = 20
      }

      network_interface = {
        nat                = true
        security_group_ids = [yandex_vpc_security_group.towr.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      role = "towr"
    },
    (local.inss__names.bast) = {
      description = "bastion instance : bast : ssh gateway"

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
        security_group_ids = [yandex_vpc_security_group.bast.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      role = "bast"
    },
    (local.inss__names.root) = {
      description = "DNS instance : root : root domain name server"

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
        security_group_ids = [yandex_vpc_security_group.core.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      role = "root"
    },
    (local.inss__names.tldd) = {
      description = "DNS instance : tldd : top level domain name server"

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
        security_group_ids = [yandex_vpc_security_group.core.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      role = "tldd"
    },
    (local.inss__names.au_a) = {
      description = "DNS instance : au_a : primary authority domain name server"

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
        security_group_ids = [yandex_vpc_security_group.core.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      role = "au_a"
    },
    (local.inss__names.au_b) = {
      description = "DNS instance : au_b : secondary authority domain name server"

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
        security_group_ids = [yandex_vpc_security_group.core.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      role = "au_b"
    },
    (local.inss__names.recr) = {
      description = "resolver instance : recr : recursive resolver"

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
        security_group_ids = [yandex_vpc_security_group.core.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      role = "recr"
    },
    (local.inss__names.stub) = {
      description = "resolver instance : stub : stub resolver"

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
        security_group_ids = [yandex_vpc_security_group.core.id]
      }

      scheduling_policy = {
        preemptible = true
      }

      role = "stub"
    },
  }
  inss__templates = {
    (local.inss__names.towr) = templatefile("${var.tf_templates__dir}/cloud-config/dock.tftpl", { pkgs = ["python${var.py__version}", "ca-certificates", "curl"] })
    (local.inss__names.bast) = templatefile("${var.tf_templates__dir}/cloud-config/bast.tftpl", { pkgs = [] })
    (local.inss__names.root) = templatefile("${var.tf_templates__dir}/cloud-config/deft.tftpl", { pkgs = ["python${var.py__version}"] })
    (local.inss__names.tldd) = templatefile("${var.tf_templates__dir}/cloud-config/deft.tftpl", { pkgs = ["python${var.py__version}"] })
    (local.inss__names.au_a) = templatefile("${var.tf_templates__dir}/cloud-config/deft.tftpl", { pkgs = ["python${var.py__version}"] })
    (local.inss__names.au_b) = templatefile("${var.tf_templates__dir}/cloud-config/deft.tftpl", { pkgs = ["python${var.py__version}"] })
    (local.inss__names.recr) = templatefile("${var.tf_templates__dir}/cloud-config/deft.tftpl", { pkgs = ["python${var.py__version}"] })
    (local.inss__names.stub) = templatefile("${var.tf_templates__dir}/cloud-config/dock.tftpl", { pkgs = ["python${var.py__version}", "ca-certificates", "curl"] })
  }
}
