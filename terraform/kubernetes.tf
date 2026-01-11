terraform {
  backend "s3" {
    bucket = "mimosa-terraform-state"
    key    = "mimosa-cluster.tfstate"
    region = "eu-central-1"

    endpoints = {
      s3 = "https://fsn1.your-objectstorage.com"
    }

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
  }
}

variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API Token"
  sensitive   = true
}

module "kubernetes" {
  source  = "hcloud-k8s/kubernetes/hcloud"
  version = "3.19.0"

  cluster_name = "mimosa"
  hcloud_token = var.hcloud_token

  cluster_kubeconfig_path  = "../.kube/kubeconfig"
  cluster_talosconfig_path = "../.kube/talosconfig"

  cilium_gateway_api_enabled = true

  talos_extra_remote_manifests = [
    "https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.34.0/controller.yaml"
  ]

  # Do not auto detect current operator IP
  firewall_use_current_ipv4 = false
  firewall_use_current_ipv6 = false

  firewall_api_source = [
    "103.151.172.24/32", # HKZ03
    "101.88.92.62/32"    # Asai Home
  ]

  kube_api_load_balancer_enabled = true
  kube_api_hostname              = "mimosa.requiem.garden"

  control_plane_nodepools = [
    { name = "control", type = "cpx22", location = "fsn1", count = 3 }
  ]
  worker_nodepools = [
    { name = "worker", type = "cpx22", location = "fsn1", count = 3 }
  ]
}
