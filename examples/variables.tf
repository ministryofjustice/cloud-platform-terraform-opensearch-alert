variable "environment" {
  description = "Environment name"
  type        = string
  default     = "non-production"
}

variable "eks_cluster_name" {
  default = "live"
}

variable "business_unit" {
  description = "Area of the MOJ responsible for the service."
  default     = "Example"
}

variable "team_name" {
  description = "The name of your development team"
  default     = "example"
}

variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form team-email."
  default     = "example@digital.justice.gov.uk"
}

variable "is_production" {
  default = "false"
}

variable "slack_channel" {
  description = "Team slack channel to use if we need to contact your team"
  default     = "example"
}

variable "application" {
  description = "Name of Application you are deploying"
  default     = "example-app"
}

variable "namespace" {
  default = "example-team"
}