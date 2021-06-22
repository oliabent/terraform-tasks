terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }
  backend "gcs" {
    bucket = "tf-state-prod-obent"
    prefix = "oliabent"
  }
}

provider "google" {
  project = var.my_project
  region  = "europe-west1"
}

