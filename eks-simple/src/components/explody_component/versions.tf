terraform {
  required_version = ">= 1.11.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.67.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "= 1.14"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 3.0.2"
    }
    datadog = {
      source  = "DataDog/datadog"
      version = "3.44.1"
    }
    # utils = {
    #   source  = "cloudposse/utils"
    #   version = "= 0.17.23"
    # }
  }
}
