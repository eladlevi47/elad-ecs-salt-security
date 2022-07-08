provider "aws" {
  region = var.RegionCode # Change to the right region

  default_tags {
    tags = {
      user = "elad.levi"
    }
  }
}