module "network" {
  source                  = "terraform-google-modules/network/google"
  version                 = "3.3.0"
  project_id              = var.my_project
  network_name            = "terraform-network"
  auto_create_subnetworks = false
  subnets = [
    {
      subnet_name           = "private-subnet"
      subnet_ip             = "10.174.0.0/20"
      subnet_region         = "europe-west1"
      subnet_private_access = true
    },
    {
      subnet_name   = "public-subnet"
      subnet_ip     = "10.172.0.0/20"
      subnet_region = "europe-west1"
    }
  ]

  firewall_rules = [{
    name                    = "allow-ssh-ingress"
    description             = null
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["35.235.240.0/20"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = null
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["22"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
    },
    {
      name                    = "apache-80"
      description             = null
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["130.211.0.0/22", "35.191.0.0/16"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["80"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = "allow-internal"
      description             = null
      direction               = "INGRESS"
      priority                = null
      ranges                  = ["10.128.0.0/9"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["0-65535"]
        },
        {
          protocol = "udp"
          ports    = ["0-65535"]
        },
        {
          protocol = "icmp"
          ports    = null
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
  }]
}