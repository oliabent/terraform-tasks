module "vm_instance_template" {
  source           = "terraform-google-modules/vm/google//modules/instance_template"
  version          = "6.5.0"
  min_cpu_platform = ""
  project_id       = "development-314115"
  region           = var.region
  service_account = {
    email  = "my-compure-account@development-314115.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  disk_size_gb = 10
  machine_type = "e2-micro"
  name_prefix  = "wordpress"
  network      = var.my_vpc_network

  source_image_family  = "ubuntu-2004-lts"
  source_image_project = "ubuntu-os-cloud"

  subnetwork     = "private-subnet"
  startup_script = data.template_file.config.rendered

  depends_on = [
    module.network
  ]
}


module "vm_mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "6.5.0"
  # insert the 3 required variables here
  project_id        = "development-314115"
  region            = var.region
  instance_template = module.vm_instance_template.self_link
  target_size       = "2"
  mig_name          = "wp-group"

  depends_on = [
    module.sql-db_mysql,
    module.cloud-storage_simple_bucket,
    module.vm_instance_template
  ]
}


data "template_file" "config" {
  template = file("wordpress_template.tpl")
  vars = {
    DB_HOST     = module.sql-db_mysql.private_ip_address
    DB_NAME     = var.wp_db_name
    DB_USER     = var.wp_db_user
    DB_PASSWORD = module.sql-db_mysql.generated_user_password
    WP_BUCKET = var.wp_bucket_name
  }
}

module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google"
  version = "5.1.1"
  # insert the 10 required variables here
  project = var.my_project
  name    = "wp-lb"
  backends = {
    default = {
      description                     = null
      protocol                        = "HTTP"
      port                            = 80
      port_name                       = "http"
      timeout_sec                     = 30
      enable_cdn                      = false
      custom_request_headers          = null
      security_policy                 = null
      connection_draining_timeout_sec = null
      session_affinity                = null
      affinity_cookie_ttl_sec         = null
      health_check = {
        check_interval_sec  = null
        timeout_sec         = null
        healthy_threshold   = null
        unhealthy_threshold = null
        request_path        = "/readme.html"
        port                = 80
        host                = null
        logging             = null
      }
      log_config = {
        enable      = true
        sample_rate = 1.0
      }
      groups = [
        {
          group                        = module.vm_mig.instance_group
          balancing_mode               = null
          capacity_scaler              = null
          description                  = null
          max_connections              = null
          max_connections_per_instance = null
          max_connections_per_endpoint = null
          max_rate                     = null
          max_rate_per_instance        = null
          max_rate_per_endpoint        = null
          max_utilization              = null
        },
      ]
      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }
    }
  }
  depends_on = [
    module.vm_mig
  ]

}
