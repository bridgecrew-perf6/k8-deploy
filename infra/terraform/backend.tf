terraform {
  backend "gcs" {
    bucket  = "k8-deploy"
    prefix  = "terraform/state"
  }
}
