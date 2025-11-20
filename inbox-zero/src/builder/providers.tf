provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "install.nuon.co/id"     = var.nuon_install_id
      "component.nuon.co/name" = "builder"
    }
  }
}
