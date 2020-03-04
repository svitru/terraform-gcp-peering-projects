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

resource "google_compute_instance" "vm_instance_a" {
  project = var.project_a

  name         = "instance-a"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = var.image
      size  = "10"
    }
  }

  network_interface {
    network = google_compute_network.network_a.name
    subnetwork = google_compute_subnetwork.network_a_central.self_link
    access_config {
    }
  }

  metadata = {
    ssh-keys = "${var.user}:${file(var.public_key_path)}"
  }
}

resource "google_compute_instance" "vm_instance_b" {
  project = var.project_b

  name         = "instance-b"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = var.image
      size  = "10"
    }
  }

  network_interface {
    network = google_compute_network.network_b.name
    subnetwork = google_compute_subnetwork.network_b_central.self_link
    access_config {
    }
  }

  metadata = {
    ssh-keys = "${var.user}:${file(var.public_key_path)}"
  }
}

resource "google_compute_network" "private_network" {
#  provider = google-beta
  project = var.project_a

  name = "private-network"
}

resource "google_compute_global_address" "private_ip_address" {
#  provider = google-beta
  project = var.project_a

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
#  provider = google-beta

  network                 = google_compute_network.private_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "instance" {
#  provider = google-beta
  project = var.project_a

  name   = "private-instance-mysql"
  region = "us-central1"

  database_version = "MYSQL_5_7"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.self_link
    }
  }
}

