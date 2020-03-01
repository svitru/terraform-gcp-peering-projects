provider "google" {
  credentials = file(var.credentials_file)

  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network_peering" "peering_ab" {
  name         = "peering-ab"
  network      = google_compute_network.network_a.self_link
  peer_network = google_compute_network.network_b.self_link
}

resource "google_compute_network_peering" "peering_ba" {
  name         = "peering-ba"
  network      = google_compute_network.network_b.self_link
  peer_network = google_compute_network.network_a.self_link
}

resource "google_compute_subnetwork" "network_a_central" {
  project = var.project_a

  name          = "network-a-central"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.network_a.self_link
}

resource "google_compute_network" "network_a" {
  project = var.project_a

  name                    = "network-a"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "network_a_fw" {
  project = var.project_a

  name    = "network-a-fw"
  network = google_compute_network.network_a.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

}

resource "google_compute_subnetwork" "network_b_central" {
  project = var.project_b

  name          = "network-b-central"
  ip_cidr_range = "10.8.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.network_b.self_link
}

resource "google_compute_network" "network_b" {
  project = var.project_b

  name                    = "network-b"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "network_b_fw" {
  project = var.project_b

  name    = "network-b-fw"
  network = google_compute_network.network_b.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

}


