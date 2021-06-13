terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.45.0"
    }
  }
  backend "gcs" {
    bucket = "tf-state-prod-obent"
    prefix = "oliabent"
  }
}

provider "google" {
  project = "development-314115"
  region  = "europe-west1"
}

