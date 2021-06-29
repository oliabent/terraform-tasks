variable "my_project" {
  description = "My GCP project name"
  type        = string
  default     = "development-314115"
}

variable "my_vpc_network" {
  description = "My VPC network name"
  type        = string
  default     = "terraform-network"
}

variable "region" {
  description = "Region where resourcees will be deployed"
  type        = string
  default     = "europe-west1"
}

variable "wp_bucket_name" {
  description = "Name of bucket used as a shared folder for wordpress managed instance group"
  type        = string
  default     = "wordpress-bucket"
}

variable "sql_server_name" {
  description = "SQL serever name"
  type        = string
  default     = "wordpress-db-server"
}

variable "wp_db_name" {
  description = "Wordpress database name"
  type        = string
  default     = "wordpress"
}

variable "wp_db_user" {
  description = "Wordpress database user name"
  type        = string
  default     = "wordpressuser"
}
