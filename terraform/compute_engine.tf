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
}
