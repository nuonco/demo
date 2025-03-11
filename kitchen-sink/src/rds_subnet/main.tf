locals {
  private_subnet_ids = split(",", trim(replace(var.private_subnet_ids, " ", ","), "[]"))
}

resource "aws_db_subnet_group" "rds_subnet" {
  name       = var.rds_subnet_name
  subnet_ids = local.private_subnet_ids
  tags = {
    Name                  = var.rds_subnet_display_name,
    "app.nuon.co/install" = var.install_id,
  }
}
