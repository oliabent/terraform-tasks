module "cloud-storage_simple_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "2.1.0"
  # insert the 9 required variables here
  name       = "mytestbucket_obent8"
  project_id = "development-314115"
  location   = "europe-west1"
   force_destroy = true

  depends_on = [
    module.network
  ]
}