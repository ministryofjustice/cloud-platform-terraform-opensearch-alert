terraform {
  required_version = ">= 1.2.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0"
    }
    opensearch = {
      source  = "opensearch-project/opensearch"
      version = "2.2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0.0"
    }
  }
}