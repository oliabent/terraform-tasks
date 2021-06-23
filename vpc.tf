module "network" {
  source                  = "terraform-google-modules/network/google"
  version                 = "3.3.0"
  project_id              = var.my_project
  network_name            = var.my_vpc_network
  auto_create_subnetworks = false
  subnets = [
    {
      subnet_name           = "private-subnet"
      subnet_ip             = "10.174.0.0/20"
      subnet_region         = var.region
      subnet_private_access = true
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

module "cloud-nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = "~> 2.0.0"
  # insert the 4 required variables here
  project_id                          = var.my_project
  region                              = var.region
  router                              = "tf-router"
  create_router                       = true
  enable_endpoint_independent_mapping = false
  network                             = var.my_vpc_network
  source_subnetwork_ip_ranges_to_nat  = "LIST_OF_SUBNETWORKS"
  subnetworks = [
    {
      name                     = "private-subnet"
      source_ip_ranges_to_nat  = ["10.174.0.0/20"]
      secondary_ip_range_names = null

    }
  ]
  depends_on = [
    module.network
  ]
}