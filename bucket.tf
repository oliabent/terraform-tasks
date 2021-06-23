module "cloud-storage_simple_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "2.1.0"
  # insert the 9 required variables here
  name          = var.wp_bucket_name
  project_id    = var.my_project
  location      = var.region
  force_destroy = true

  depends_on = [
    module.network
  ]
}