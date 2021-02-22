resource "google_compute_disk" "gamedata" {
  name = "gamedata"
  type = "pd-balanced"
  zone = var.zone
  size = var.gamedata_disk_size
}

data "google_compute_default_service_account" "default" {
}

resource "google_compute_instance" "gameserver" {
  name         = "valheim01"
  zone         = var.zone
  machine_type = var.instance_type

  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/cos-cloud/global/images/cos-85-13310-1209-10"
      type  = "pd-balanced"
      size  = 10
    }
    auto_delete = true
  }

  network_interface {
    network = "default"
    access_config {}
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  attached_disk {
    source      = google_compute_disk.gamedata.name
    device_name = "gamedata"
    mode        = "READ_WRITE"
  }

  metadata = {
    user-data = file("cloud-init.yaml")
  }

  service_account {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform"]
  }

  allow_stopping_for_update = true
}


resource "google_compute_firewall" "vallheim" {
  name    = "vallheim"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["2454-2458"]
  }

  allow {
    protocol = "udp"
    ports    = ["2454-2458"]
  }
}
