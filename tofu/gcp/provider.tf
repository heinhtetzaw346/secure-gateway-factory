terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "7.13.0"
    }
  }
}

provider "google" {
  project = var.project
  region = var.region
  credentials = var.credentials != "" && var.credentials != null ? var.credentials : null
}
