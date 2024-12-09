##########################
# Provider Configuration #
##########################

# This provide the flexibility to re-use the module in other Cloud Platform OpenSearch cluster.
# Set the default to user application logs one.
# For modesec OpenSearch cluster, please add variable when calling the module and use cp-live-modsec-audit and opensearch-access-role for aws_opensearch_domain and aws_iam_role.

variable "aws_opensearch_domain" {
  description = "The OpenSearch Cluster for alert creation. Set default to user application logs one."
  type        = string
  default     = "cp-live-app-logs"
}

variable "aws_iam_role" {
  description = "AWS IAM role for alert creation. Set detault to user application logs one."
  type        = string
  default     = "opensearch-access-role-app-logs"
}

#################
# Secret Config #
#################

variable "secret_name" {
  description = "Name of secret created from cloud-platform-terraform-secrets-manager module"
  type        = string
}

variable "secret_key" {
  description = "Secret key for Slack URL"
  type        = string
}

variable "integration_secret_key" {
  description = "Secret key for Integration Key"
  default     = "integration_key"
  type        = string
}

################
# Alert Config #
################

variable "alert_type" {
  description = "How you want the alert to be configured. Available options: 'slack', 'webhook'"
  default     = "slack"
  type        = string
}

variable "environment_name" {
  description = "Environment name"
  type        = string
}

variable "slack_channel_name" {
  description = "Slack Channel Name"
  type        = string
}

variable "slack_channel_name_description" {
  description = "Slack Channel Description"
  type        = string
  default     = ""
}

variable "opensearch_alert_name" {
  description = "OpenSearch Alert Name"
  type        = string
}

variable "opensearch_alert_enabled" {
  description = "OpenSearch Alert Name"
  type        = bool
  default     = true
}

variable "monitor_period_interval" {
  description = "Interval for the monitor schedule period"
  type        = number
  default     = 1
}

variable "monitor_period_unit" {
  description = "Unit for the monitor schedule period"
  type        = string
  default     = "MINUTES"
}

variable "index" {
  description = "Indices to be monitored"
  type        = list(string)
  default     = ["live_kubernetes_cluster*"]
}

variable "alert_query" {
  description = "The OpenSearch query in JSON format"
  type        = string
}

variable "query_source" {
  description = "Source script for the query condition"
  type        = string
  default     = "ctx.results[0].hits.total.value > 1"
}

variable "trigger_name" {
  description = "Name of the trigger"
  type        = string
}

variable "serverity" {
  description = "Alert Serverity that only allows values from 1 to 5, with 1 is the highest and 5 is the lowest"
  type        = number
  default     = 1

  validation {
    condition     = var.serverity >= 1 && var.serverity <= 5
    error_message = "The serverity variable must be between 1 and 5 inclusive."
  }
}

variable "action_name" {
  description = "Name of the action"
  type        = string
}

variable "slack_message_template" {
  description = "Message template for Slack notifications"
  type        = string
  default     = <<-EOT
    Monitor {{ctx.monitor.name}} just entered alert status. Please investigate the issue.
    - Trigger: {{ctx.trigger.name}}
    - Severity: {{ctx.trigger.severity}}
  EOT
}

variable "alert_throttle_enabled" {
  description = "Trigger for Slack channel"
  type        = bool
  default     = true
}

variable "slack_message_subject" {
  description = "Subject for Slack Message"
  type        = string
}

variable "throttle_value" {
  description = "Use throttling to limit the number of notifications you receive within a given time frame"
  type        = number
  default     = 60
}

variable "throttle_unit" {
  description = "Unit for the throttle"
  type        = string
  default     = "MINUTES"
}