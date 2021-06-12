resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "private" {
  name                     = "private-subnet"
  ip_cidr_range            = "10.174.0.0/20"
  region                   = "europe-west1"
  private_ip_google_access = true
  network                  = google_compute_network.vpc_network.id
}


resource "google_compute_subnetwork" "public" {
  name          = "public-subnet"
  ip_cidr_range = "10.172.0.0/20"
  region        = "europe-west1"
  network       = google_compute_network.vpc_network.id
}