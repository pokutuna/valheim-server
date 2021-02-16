provider "google" {
  credentials = file("./keys/${var.project}.json")
  project     = var.project
  region      = var.region
  version     = "~> 3.56"
}

terraform {
  backend "gcs" {
  }
}
