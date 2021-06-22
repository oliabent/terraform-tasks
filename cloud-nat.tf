module "cloud-nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = "~> 2.0.0"
  # insert the 4 required variables here
  project_id                          = var.my_project
  region                              = "europe-west1"
  router                              = "tf-router"
  create_router                       = true
  enable_endpoint_independent_mapping = false
  network                             = "terraform-network"
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