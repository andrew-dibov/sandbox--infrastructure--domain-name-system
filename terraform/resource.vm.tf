data "yandex_compute_image" "img" {
  family = var.img__name
}

resource "yandex_compute_instance" "inss" {
  for_each = local.inss__confs

  zone        = yandex_vpc_subnet.sub.zone
  platform_id = var.ins__platform_id

  name        = each.key
  description = each.value.description
  hostname    = each.key

  labels = {
    role = each.value.role
  }

  resources {
    cores         = each.value.resources.cores
    memory        = each.value.resources.memory
    core_fraction = each.value.resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.img.id
      size     = each.value.initialize_params.size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.sub.id
    nat                = each.value.network_interface.nat
    security_group_ids = each.value.network_interface.security_group_ids
  }

  scheduling_policy {
    preemptible = each.value.scheduling_policy.preemptible
  }

  metadata = {
    ssh-keys  = "debian:${tls_private_key.key[each.key].public_key_openssh}"
    user-data = local.inss__templates[each.key]
  }
}

resource "local_file" "ansible_cfg" {
  filename = "${var.ansible__dir}/ansible.cfg"
  content  = templatefile("${var.tf_templates__dir}/ansible/ansible.tftpl", {
    py = "python${var.py__version}"
  })
}

resource "local_file" "ansible_inv" {
  filename = "${var.ansible__dir}/inventory/terraform.yaml"
  content = templatefile("${var.tf_templates__dir}/ansible/inventory.tftpl", {
    inss = yandex_compute_instance.inss
  })
}

resource "local_file" "ansible_var" {
  filename = "${var.ansible__dir}/variables/terraform.yaml"
  content = templatefile("${var.tf_templates__dir}/ansible/variables.tftpl", {
    su_cidr = var.vpc_subnet__v4_cidr_blocks[0]
    towr_ip = yandex_compute_instance.inss["${local.inss__names.towr}"].network_interface[0].ip_address
    root_ip = yandex_compute_instance.inss["${local.inss__names.root}"].network_interface[0].ip_address
    tldd_ip = yandex_compute_instance.inss["${local.inss__names.tldd}"].network_interface[0].ip_address
    au_a_ip = yandex_compute_instance.inss["${local.inss__names.au_a}"].network_interface[0].ip_address
    au_b_ip = yandex_compute_instance.inss["${local.inss__names.au_b}"].network_interface[0].ip_address
    recr_ip = yandex_compute_instance.inss["${local.inss__names.recr}"].network_interface[0].ip_address
    stub_ip = yandex_compute_instance.inss["${local.inss__names.stub}"].network_interface[0].ip_address
  })
}
