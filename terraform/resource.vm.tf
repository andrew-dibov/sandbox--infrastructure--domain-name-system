resource "yandex_compute_instance" "hosts" {
  for_each = local.hosts

  zone        = yandex_vpc_subnet.subnet.zone
  platform_id = var.platform_id

  name     = each.key
  hostname = each.key

  labels = {
    ansible_role = each.value.ansible_role
  }

  resources {
    cores         = each.value.resources.cores
    memory        = each.value.resources.memory
    core_fraction = each.value.resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.debian.id
      size     = each.value.initialize_params.size
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet.id
    nat                = each.value.network_interface.nat
    security_group_ids = each.value.network_interface.security_group_ids
  }

  scheduling_policy {
    preemptible = each.value.scheduling_policy.preemptible
  }

  metadata = {
    ssh-keys  = "debian:${tls_private_key.key[each.key].public_key_openssh}"
    user-data = local.cloud_init_templates[each.key]
  }
}

resource "local_file" "ansible_cfg" {
  filename = "../ansible/ansible.cfg"
  content  = templatefile("${var.templates_dir}/ansible/ansible.tftpl", {})
}

resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory/terraform.yaml"
  content = templatefile("${var.templates_dir}/ansible/inventory.tftpl", {
    hosts = yandex_compute_instance.hosts
  })
}

resource "local_file" "ansible_variables" {
  filename = "../ansible/variables/terraform.yaml"
  content = templatefile("${var.templates_dir}/ansible/variables.tftpl", {
    su_cidr = var.vpc_subnet_v4_cidr_blocks[0]

    stub_ip = yandex_compute_instance.hosts["${local.hostnames.stub}"].network_interface[0].ip_address
    recr_ip = yandex_compute_instance.hosts["${local.hostnames.recr}"].network_interface[0].ip_address

    root_ip = yandex_compute_instance.hosts["${local.hostnames.root}"].network_interface[0].ip_address
    tldd_ip = yandex_compute_instance.hosts["${local.hostnames.tldd}"].network_interface[0].ip_address

    au_a_ip = yandex_compute_instance.hosts["${local.hostnames.au_a}"].network_interface[0].ip_address
    au_b_ip = yandex_compute_instance.hosts["${local.hostnames.au_b}"].network_interface[0].ip_address

    ho_a_ip = yandex_compute_instance.hosts["${local.hostnames.ho_a}"].network_interface[0].ip_address
    ho_b_ip = yandex_compute_instance.hosts["${local.hostnames.ho_b}"].network_interface[0].ip_address
  })
}
