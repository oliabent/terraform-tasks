module "vm_instance_template" {
  source           = "terraform-google-modules/vm/google//modules/instance_template"
  version          = "6.5.0"
  min_cpu_platform = ""
  project_id       = "development-314115"
  region           = "europe-west1"
  service_account = {
    email  = "my-compure-account@development-314115.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  disk_size_gb = 10
  machine_type = "e2-micro"
  name_prefix  = "wordpress"
  network      = "terraform-network"

  source_image_family  = "ubuntu-2004-lts"
  source_image_project = "ubuntu-os-cloud"

  subnetwork     = "private-subnet"
  startup_script = file("./wordpress_template.sh")

  depends_on = [
    module.network
  ]
}


module "vm_mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "6.5.0"
  # insert the 3 required variables here
  project_id       = "development-314115"
  region           = "europe-west1"
  instance_template = module.vm_instance_template.self_link
  target_size = "2"
  mig_name = "wp-group"

   depends_on = [
    module.sql-db_mysql,
    module.cloud-storage_simple_bucket
  ]
}