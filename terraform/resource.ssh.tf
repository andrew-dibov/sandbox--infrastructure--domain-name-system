resource "tls_private_key" "key" {
  for_each  = toset(values(local.inss__names))
  algorithm = "ED25519"
}

resource "local_file" "prv_key" {
  for_each = tls_private_key.key

  filename        = "${var.auth__dir}/${each.key}"
  content         = each.value.private_key_openssh
  file_permission = "0600"
}

resource "local_file" "pub_key" {
  for_each = tls_private_key.key

  filename        = "${var.auth__dir}/${each.key}.pub"
  content         = each.value.public_key_openssh
  file_permission = "0644"
}

resource "local_file" "ssh_cfg" {
  filename = "${var.ansible__dir}/ssh_config"
  content = templatefile("${var.tf_templates__dir}/ssh-config.tftpl", {
    bast = local.inss__names.bast
    inss = {
      for name, vm in yandex_compute_instance.inss :
      name => {
        is_bast  = name == (local.inss__names.bast)
        ins_name = name == (local.inss__names.bast) ? vm.network_interface[0].nat_ip_address : vm.network_interface[0].ip_address
        key_path = "${var.auth__dir}/${name}"
        user     = "debian"
      }
    }
  })
  file_permission = "0600"
}
