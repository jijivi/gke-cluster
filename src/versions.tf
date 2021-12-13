terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.3.0"
    }
  }

  required_version = ">= 1.1"
  backend "gcs" {
    bucket  = "jijivi"
    prefix  = "terraform/state/gke"
    # https://cloud.google.com/docs/authentication/production#command-line
    # impersonate_service_account = "github-actions@jijivi.iam.gserviceaccount.com"
  }
}

provider "google" {
  # credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

provider "google-beta" {
  # credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  zone        = var.zone
}
