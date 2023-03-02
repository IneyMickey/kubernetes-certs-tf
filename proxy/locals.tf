locals {
  ca_cert_name = "front-proxy-ca"
  default_cert_info = {
    ca                     = local.ca_cert_name
    organizational_unit    = "Kubernetes"
    organization           = "Kubernetes"
    dns_names              = null
    ip_addresses           = null
    country                = "US"
    locality               = "Portland"
    province               = "Oregon"
    validity_period_hours  = 8760
    allowed_uses           = ["cert_signing", "key_encipherment", "server_auth", "client_auth"]
    is_ca_certificate      = false
    create_public_key      = false
    create_certificate     = true
    filedir                = "../pki"
  }
  ss_certs_info = [
    {
      name                = local.ca_cert_name
      common_name         = "front-proxy-ca"
      organization        = "Kubernetes"
      organizational_unit = "CA"
      allowed_uses        = []
      is_ca_certificate   = true
      dns_names           = ["front-proxy-ca"]
    }
  ]
  ls_certs_info = [
    {
      name         = "front-proxy-client"
      common_name  = "front-proxy-client"
    },
  ]
  ss_certs_info_full = [for cert_info in local.ss_certs_info : merge(local.default_cert_info, cert_info)]
  ls_certs_info_full = [for cert_info in local.ls_certs_info : merge(local.default_cert_info, cert_info)]
  certs_info_full    = concat(local.ss_certs_info_full, local.ls_certs_info_full)
}

