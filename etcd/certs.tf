#
# PRIVATE KEYS
#
resource "tls_private_key" "this" {
  for_each = toset([for cert_info in local.certs_info_full : cert_info.name])

  algorithm = "RSA"
  rsa_bits  = 2048
}

#
# SELF SIGNED CERTS
#
resource "tls_self_signed_cert" "this" {
  for_each = {
    for cert_info in local.ss_certs_info_full : cert_info.name => cert_info
  }

  private_key_pem = tls_private_key.this[each.value.name].private_key_pem

  subject {
    common_name         = each.value.common_name
    organization        = each.value.organization
    organizational_unit = each.value.organizational_unit
    country             = each.value.country
    locality            = each.value.locality
    province            = each.value.province
  }

  validity_period_hours = each.value.validity_period_hours
  allowed_uses          = each.value.allowed_uses
  is_ca_certificate     = each.value.is_ca_certificate

  ip_addresses = each.value.ip_addresses
  dns_names    = each.value.dns_names
}

#
# LOCALLY SIGNED CERTS
#
#
resource "tls_cert_request" "this" {
  for_each = {
    for cert_info in local.ls_certs_info_full : cert_info.name => cert_info
  }

  private_key_pem = tls_private_key.this[each.value.name].private_key_pem

  subject {
    common_name         = each.value.common_name
    organization        = each.value.organization
    organizational_unit = each.value.organizational_unit
    country             = each.value.country
    locality            = each.value.locality
    province            = each.value.province
  }

  ip_addresses = each.value.ip_addresses
  dns_names    = each.value.dns_names
}

resource "tls_locally_signed_cert" "this" {
  for_each = {
    for cert_info in local.ls_certs_info_full : cert_info.name => cert_info
  }

  cert_request_pem   = tls_cert_request.this[each.value.name].cert_request_pem
  ca_private_key_pem = tls_private_key.this[each.value.ca].private_key_pem
  ca_cert_pem        = tls_self_signed_cert.this[each.value.ca].cert_pem

  validity_period_hours = each.value.validity_period_hours
  allowed_uses          = each.value.allowed_uses
  is_ca_certificate     = each.value.is_ca_certificate
}

