provider "google" {
  credentials = file("./keys/terraform.json")
  project     = var.project
  region      = var.region
  version     = "~> 3.56"
}

terraform {
  backend "gcs" {
  }
}
