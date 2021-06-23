module "sql-db_private_service_access" {
  source      = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version     = "5.1.1"
  project_id  = var.my_project
  vpc_network = var.my_vpc_network
  depends_on = [
    module.network
  ]
}

module "sql-db_mysql" {
  source              = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  version             = "5.1.1"
  database_version    = "MYSQL_5_7"
  encryption_key_name = null
  name                = var.sql_server_name
  project_id          = var.my_project
  region              = var.region
  zone                = "europe-west1-b"
  db_name             = var.wp_db_name
  db_charset          = "utf8"
  db_collation        = "utf8_unicode_ci"
  create_timeout      = "15m"
  deletion_protection = false
  user_name           = var.wp_db_user
  tier                = "db-f1-micro"

  ip_configuration = {
    ipv4_enabled        = false
    require_ssl         = null
    private_network     = "projects/development-314115/global/networks/terraform-network"
    authorized_networks = []
  }

  availability_type = "REGIONAL"

  backup_configuration = {
    enabled                        = true
    binary_log_enabled             = true
    start_time                     = "02:55"
    location                       = null
    transaction_log_retention_days = 3
    retained_backups               = 3
    retention_unit                 = "COUNT"
  }


  module_depends_on = [
    module.sql-db_private_service_access.peering_completed
  ]
}