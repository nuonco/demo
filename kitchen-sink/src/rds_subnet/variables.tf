variable "region" {
  type = string
}

variable "private_subnet_ids" {
  type        = string
  description = "Comma-delimited string of subnet ids to be split for use in this tf."
}

variable "install_id" {
  type        = string
  description = "The id of the install."
}

variable "rds_subnet_name" {
  type        = string
  description = "The name of the rds subnet."
}

variable "rds_subnet_display_name" {
  type        = string
  description = "The name of the rds subnet for use in the Name Tag"
}
