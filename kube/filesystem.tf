resource "local_file" "keys" {
  for_each = {
    for cert_info in local.certs_info_full : cert_info.name => cert_info
  }

  filename = "${each.value.filedir}/${each.key}.key"
  content  = tls_private_key.this[each.key].private_key_pem
  file_permission = "0644"
}

resource "local_file" "public_keys" {
  for_each = {
    for cert_info in local.certs_info_full : cert_info.name => cert_info if cert_info.create_public_key
  }

  filename = "${each.value.filedir}/${each.key}.pub"
  content  = tls_private_key.this[each.key].public_key_pem
  file_permission = "0644"
}

resource "local_file" "ss_certs" {
  for_each = {
    for cert_info in local.ss_certs_info_full : cert_info.name => cert_info if cert_info.create_certificate
  }

  filename = "${each.value.filedir}/${each.key}.crt"
  content  = tls_self_signed_cert.this[each.key].cert_pem
  file_permission = "0644"
}

resource "local_file" "ls_certs" {
  for_each = {
    for cert_info in local.ls_certs_info_full : cert_info.name => cert_info if cert_info.create_certificate
  }

  filename = "${each.value.filedir}/${each.key}.crt"
  content  = tls_locally_signed_cert.this[each.key].cert_pem
  file_permission = "0644"
}

