locals {
  ca_cert_name = "ca"
  default_cert_info = {
    ca                     = local.ca_cert_name
    organizational_unit    = "Kubernetes"
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
      common_name         = "Kubernetes"
      organization        = "Kubernetes"
      organizational_unit = "CA"
      allowed_uses        = []
      is_ca_certificate   = true
    }
  ]
  ls_certs_info = [
    {
      name         = "apiserver-kubelet-client"
      common_name  = "kube-apiserver-kubelet-client"
      organization = "system:masters"
    },
    {
      name         = "apiserver"
      common_name  = "kube-apiserver"
      organization = "Kubernetes"
      dns_names = [
        "docker-for-desktop",
        "kubernetes",
        "kubernetes.default",
        "kubernetes.default.svc",
        "kubernetes.default.svc.cluster",
        "kubernetes.default.svc.cluster.local",
        "kubernetes.svc.cluster.local",
        "kubernetes.docker.internal",
        "localhost",
        "vm.docker.internal",
      ]
      ip_addresses = [
        "10.96.0.1",
        "0.0.0.0",
        "127.0.0.1",
        "192.168.65.4",
        "192.168.65.3",
      ]
    },
    {
      name                   = "sa"
      common_name            = "service_accounts"
      organization           = "Kubernetes"
      create_public_key = true
      create_certificate = false
    }
  ]
  ss_certs_info_full = [for cert_info in local.ss_certs_info : merge(local.default_cert_info, cert_info)]
  ls_certs_info_full = [for cert_info in local.ls_certs_info : merge(local.default_cert_info, cert_info)]
  certs_info_full    = concat(local.ss_certs_info_full, local.ls_certs_info_full)
}

