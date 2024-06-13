# cloud-platform-terraform-opensearch-alert

[![Releases](https://img.shields.io/github/v/release/ministryofjustice/cloud-platform-terraform-opensearch-alert.svg)](https://github.com/ministryofjustice/cloud-platform-terraform-opensearch-alert/releases)

This Terraform module creates an OpenSearch alert for detecting specific conditions on user application logs and sends notifications to a Slack channel. It allows users to configure various aspects of the alert, including the query, triggers, and Slack channel settings.

It targets the [Application Log OpenSearch Cluster](https://app-logs.cloud-platform.service.justice.gov.uk/_dashboards/) by default.

For modesec OpenSearch cluster, add below variable when calling the module

```
var.aws_opensearch_domain = "cp-live-modsec-audit"
var.aws_iam_role          = "opensearch-access-role"
var.index                 = ["live_k8s_modsec*", "live_k8s_modsec_ingress*"]
```

## Usage

### Prerequisites

Before using this module, you need to use [cloud-platform-terraform-secrets-manager](https://github.com/ministryofjustice/cloud-platform-terraform-secrets-manager) module to create secret in AWS Secrets Manager to store the Slack webhook URL. 

You will then need to log in to the AWS Console to manually set the secret key and secret value.

Set the secret key to your desired key (e.g url) and the secret value to the actual Slack webhook URL.

Once the Slack webhook URL is stored, you can reference the variable `secret_name` and the `secret_key` in the OpenSearch alert module.

### Example for creating alert in **application log OpenSearch Cluster**
```hcl
module "opensearch_alert_app_log" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-opensearch-alerts?ref=1.0.0" # use the latest module

  secret_name                    = "secret-name-created-by-secret-manager-module" 
  secret_key                     = "url"

  slack_channel_name             = "your-slack-channel-name" 
  slack_channel_name_description = "slack-channel-description"

  environment_name               = var.environment
  opensearch_alert_name          = "example-opensearch-alert-name" #To main uniqueness, the actual alert will be in the format of "${var.environment_name}-${var.opensearch_alert_name}-${local.identifier}"
  opensearch_alert_enabled       = true
  monitor_period_interval        = "1"
  monitor_period_unit            = "MINUTES"
  alert_query                    = jsonencode(
    {
      Your_alert_query : query
    }
  )
  trigger_name                   = "example-trigger-name"
  serverity                      = "1"
  query_source                   = "ctx.results[0].hits.total.value > 1"
  action_name                    = "trigger-action-name"
  slack_message_subject          = "slack-message-subject"
  slack_message_template         = "Monitor {{ctx.monitor.name}} just entered alert status. Please investigate the issue.\n- Trigger: {{ctx.trigger.name}}\n- Severity: {{ctx.trigger.severity}}" 
  alert_throttle_enabled         = true
  throttle_value                 = 60
  throttle_unit                  = "MINUTES"
}
```

### Example for creating alert in **modsec OpenSearch Cluster**
```hcl
module "opensearch_alert_mod_sec" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-opensearch-alerts?ref=1.0.0" # use the latest module

  aws_opensearch_domain          = "cp-live-modsec-audit" #add this for modsec opensearch cluster
  aws_iam_role                   = "opensearch-access-role" #add this for modsec opensearch cluster
  index                          = ["live_k8s_modsec*", "live_k8s_modsec_ingress*"] #add this for modsec opensearch cluster

  secret_name                    = "secret-name-created-by-secret-manager-module" 
  secret_key                     = "url"

  slack_channel_name             = "your-slack-channel-name" 
  slack_channel_name_description = "slack-channel-description"

  environment_name               = var.environment
  opensearch_alert_name          = "example-opensearch-alert-name" #To main uniqueness, the actual alert will be in the format of "${var.environment_name}-${var.opensearch_alert_name}-${local.identifier}"
  opensearch_alert_enabled       = true
  monitor_period_interval        = "1"
  monitor_period_unit            = "MINUTES"
  alert_query                    = jsonencode(
    {
      Your_alert_query : query
    }
  )
  trigger_name                   = "example-trigger-name"
  serverity                      = "1"
  query_source                   = "ctx.results[0].hits.total.value > 1"
  action_name                    = "trigger-action-name"
  slack_message_subject          = "slack-message-subject"
  slack_message_template         = "Monitor {{ctx.monitor.name}} just entered alert status. Please investigate the issue.\n- Trigger: {{ctx.trigger.name}}\n- Severity: {{ctx.trigger.severity}}" 
  alert_throttle_enabled         = true
  throttle_value                 = 60
  throttle_unit                  = "MINUTES"
}
```

See the [examples/](examples/) folder and [Cloud Platform User Guide](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/logging-an-app/create-os-monitor-alert.html) for more information. 

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.25.2 |
| <a name="requirement_opensearch"></a> [opensearch](#requirement\_opensearch) | 2.2.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |
| <a name="provider_opensearch.app_logs"></a> [opensearch.app\_logs](#provider\_opensearch.app\_logs) | 2.2.1 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [opensearch_channel_configuration.slack_alarm](https://registry.terraform.io/providers/opensearch-project/opensearch/2.2.1/docs/resources/channel_configuration) | resource |
| [opensearch_monitor.opensearch_alert](https://registry.terraform.io/providers/opensearch-project/opensearch/2.2.1/docs/resources/monitor) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_role.os_access_role_app_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_opensearch_domain.live_app_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/opensearch_domain) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret_version.slack_webhook_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_name"></a> [action\_name](#input\_action\_name) | Name of the action | `string` | n/a | yes |
| <a name="input_alert_query"></a> [alert\_query](#input\_alert\_query) | The OpenSearch query in JSON format | `string` | n/a | yes |
| <a name="input_alert_throttle_enabled"></a> [alert\_throttle\_enabled](#input\_alert\_throttle\_enabled) | Trigger for Slack channel | `bool` | `true` | no |
| <a name="input_aws_iam_role"></a> [aws\_iam\_role](#input\_aws\_iam\_role) | AWS IAM role for alert creation. Set detault to user application logs one. | `string` | `"opensearch-access-role-app-logs"` | no |
| <a name="input_aws_opensearch_domain"></a> [aws\_opensearch\_domain](#input\_aws\_opensearch\_domain) | The OpenSearch Cluster for alert creation. Set default to user application logs one. | `string` | `"cp-live-app-logs"` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Environment name | `string` | n/a | yes |
| <a name="input_index"></a> [index](#input\_index) | Indices to be monitored | `list(string)` | <pre>[<br>  "live_kubernetes_cluster*"<br>]</pre> | no |
| <a name="input_monitor_period_interval"></a> [monitor\_period\_interval](#input\_monitor\_period\_interval) | Interval for the monitor schedule period | `number` | `1` | no |
| <a name="input_monitor_period_unit"></a> [monitor\_period\_unit](#input\_monitor\_period\_unit) | Unit for the monitor schedule period | `string` | `"MINUTES"` | no |
| <a name="input_opensearch_alert_enabled"></a> [opensearch\_alert\_enabled](#input\_opensearch\_alert\_enabled) | OpenSearch Alert Name | `bool` | `true` | no |
| <a name="input_opensearch_alert_name"></a> [opensearch\_alert\_name](#input\_opensearch\_alert\_name) | OpenSearch Alert Name | `string` | n/a | yes |
| <a name="input_query_source"></a> [query\_source](#input\_query\_source) | Source script for the query condition | `string` | `"ctx.results[0].hits.total.value > 1"` | no |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | Secret key for Slack URL | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | Name of secret created from cloud-platform-terraform-secrets-manager module | `string` | n/a | yes |
| <a name="input_serverity"></a> [serverity](#input\_serverity) | Alert Serverity that only allows values from 1 to 5, with 1 is the highest and 5 is the lowest | `number` | `1` | no |
| <a name="input_slack_channel_name"></a> [slack\_channel\_name](#input\_slack\_channel\_name) | Slack Channel Name | `string` | n/a | yes |
| <a name="input_slack_channel_name_description"></a> [slack\_channel\_name\_description](#input\_slack\_channel\_name\_description) | Slack Channel Description | `string` | `""` | no |
| <a name="input_slack_message_subject"></a> [slack\_message\_subject](#input\_slack\_message\_subject) | Subject for Slack Message | `string` | n/a | yes |
| <a name="input_slack_message_template"></a> [slack\_message\_template](#input\_slack\_message\_template) | Message template for Slack notifications | `string` | `"Monitor {{ctx.monitor.name}} just entered alert status. Please investigate the issue.\n- Trigger: {{ctx.trigger.name}}\n- Severity: {{ctx.trigger.severity}}\n"` | no |
| <a name="input_throttle_unit"></a> [throttle\_unit](#input\_throttle\_unit) | Unit for the throttle | `string` | `"MINUTES"` | no |
| <a name="input_throttle_value"></a> [throttle\_value](#input\_throttle\_value) | Use throttling to limit the number of notifications you receive within a given time frame | `number` | `60` | no |
| <a name="input_trigger_name"></a> [trigger\_name](#input\_trigger\_name) | Name of the trigger | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Tags

Some of the inputs for this module are tags. All infrastructure resources must be tagged to meet the MOJ Technical Guidance on [Documenting owners of infrastructure](https://technical-guidance.service.justice.gov.uk/documentation/standards/documenting-infrastructure-owners.html).

You should use your namespace variables to populate these. See the [Usage](#usage) section for more information.

## Reading Material

<!-- Add links to useful documentation -->

- [Cloud Platform user guide](https://user-guide.cloud-platform.service.justice.gov.uk/#cloud-platform-user-guide)
