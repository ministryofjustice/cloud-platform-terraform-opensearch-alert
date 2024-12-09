###########################
# Get account information #
###########################

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

#####################################
# Get OpenSeach Cluster information #
#####################################

data "aws_opensearch_domain" "live_app_logs" {
  domain_name = var.aws_opensearch_domain
}

data "aws_iam_role" "os_access_role_app_logs" {
  name = var.aws_iam_role
}

provider "opensearch" {
  alias               = "app_logs"
  url                 = "https://${data.aws_opensearch_domain.live_app_logs.endpoint}"
  aws_assume_role_arn = data.aws_iam_role.os_access_role_app_logs.arn
  sign_aws_requests   = true
  healthcheck         = false
  sniff               = false
}

########################
# Generate identifiers #
########################

resource "random_id" "id" {
  byte_length = 4
}

locals {
  identifier = random_id.id.hex
}

#####################
# Slack Webhook URL #
#####################

# Data call to fetch slack url secret value from secret manager module output

data "aws_secretsmanager_secret_version" "slack_webhook_url" {
  secret_id = var.secret_name
}

##############################################
# OpenSearch channel configuration for Slack #
##############################################

# Channel configuration to notify Slack
locals {
  slack_alarm = jsonencode(
    {
      "config_id" : "slack-config-id-${local.identifier}", # to prevent change in terraform plan
      "config" : {
        "name" : "${var.environment_name}-${var.slack_channel_name}-${local.identifier}",
        "description" : var.slack_channel_name_description,
        "config_type" : "slack",
        "is_enabled" : true,
        "slack" : {
          "url" : jsondecode(data.aws_secretsmanager_secret_version.slack_webhook_url.secret_string)["${var.secret_key}"]
        }
      }
    }
  )
  custom_webhook = jsonencode(
    {
      "config_id" : "webhook-config-id-${local.identifier}", # to prevent change in terraform plan
      "config" : {
        "name" : "${var.environment_name}-${var.slack_channel_name}-${local.identifier}",
        "description" : var.slack_channel_name_description,
        "config_type" : "webhook",
        "is_enabled" : true,
        "webhook" : {
          "url" : jsondecode(data.aws_secretsmanager_secret_version.slack_webhook_url.secret_string)["${var.secret_key}"],
          "headers": {
            "Authorization": jsondecode(data.aws_secretsmanager_secret_version.slack_webhook_url.secret_string)["${var.integration_secret_key}"],
            "Content-Type": "application/json"
          }
        }
      }
    }
  )
}

resource "opensearch_channel_configuration" "slack_alarm" {
  provider = opensearch.app_logs
  body     = var.alert_type == "webhook" ? local.custom_webhook : local.slack_alarm
}

##################################
# OpenSearch Alert Configuration #
##################################

locals {
  opensearch_alert = jsonencode(
    {
      "owner" : "alerting",
      "monitor_type" : "query_level_monitor",
      "data_sources" : {
        "alerts_history_index" : ".opendistro-alerting-alert-history-write",
        "alerts_history_index_pattern" : "<.opendistro-alerting-alert-history-{now/d}-1>",
        "alerts_index" : ".opendistro-alerting-alerts",
        "findings_enabled" : false,
        "findings_index" : ".opensearch-alerting-finding-history-write",
        "findings_index_pattern" : "<.opensearch-alerting-finding-history-{now/d}-1>",
        "query_index" : ".opensearch-alerting-queries",
        "query_index_mappings_by_type" : {}
      },
      "name" : "${var.environment_name}-${var.opensearch_alert_name}-${local.identifier}",
      "type" : "monitor",
      "monitor_type" : "query_level_monitor",
      "enabled" : var.opensearch_alert_enabled,
      "schedule" : {
        "period" : {
          "interval" : var.monitor_period_interval,
          "unit" : var.monitor_period_unit
        }
      },
      "inputs" : [
        {
          "search" : {
            "indices" : var.index,
            "query" : jsondecode(var.alert_query)
          }
        }
      ],
      "triggers" : [
        {
          "query_level_trigger" : {
            "id" : "trigger-id-${local.identifier}", # to prevent change in terraform plan
            "name" : "${var.environment_name}-${var.trigger_name}-${local.identifier}", 
            "severity" : var.serverity,
            "condition" : {
              "script" : {
                "source" : var.query_source,
                "lang" : "painless"
              }
            },
            "actions" : [
              {
                "id" : "action-id-${local.identifier}", # to prevent change in terraform plan
                "name" : var.action_name,
                "destination_id" : opensearch_channel_configuration.slack_alarm.id,
                "message_template" : {
                  "source" : var.slack_message_template,
                  "lang" : "mustache"
                },
                "throttle_enabled" : var.alert_throttle_enabled,
                "subject_template" : {
                  "source" : var.slack_message_subject,
                  "lang" : "mustache"
                },
                "throttle" : {
                  "value" : var.throttle_value,
                  "unit" : var.throttle_unit
                }
              }
            ]
          }
        }
      ]
    }
  )
}

resource "opensearch_monitor" "opensearch_alert" {
  provider   = opensearch.app_logs
  body       = local.opensearch_alert
  depends_on = [opensearch_channel_configuration.slack_alarm]
}