resource "google_compute_disk" "gamedata" {
  name = "gamedata"
  type = "pd-balanced"
  zone = var.zone
  size = 3
}

resource "google_compute_instance" "gameserver" {
  name         = "valheim01"
  machine_type = "n1-standard-1"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-85-lts"
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
    user-data       = file("cloud-init.yaml")
    shutdown-script = file("shutdown.sh")
  }
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
