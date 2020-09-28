terraform {
  backend "gcs" {
    bucket = "pixelistic-tfstate"
    prefix = "terraform/state"
  }
}