# Examples

<!-- Add links to specific examples of this module being used, if needed. -->

This Terraform module creates an OpenSearch alert for detecting specific conditions on user application logs and sends notifications to a Slack channel. It allows users to configure various aspects of the alert, including the query, triggers, and Slack channel settings.

It targets the [Application Log OpenSearch Cluster](https://app-logs.cloud-platform.service.justice.gov.uk/_dashboards/) by default.

For modesec OpenSearch cluster, add below variable when calling the module

```
var.aws_opensearch_domain = "cp-live-modsec-audit"
var.aws_iam_role          = "opensearch-access-role"
var.index                 = [live_k8s_modsec*, live_k8s_modsec_ingress*]
```