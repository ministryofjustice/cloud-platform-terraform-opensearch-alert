# example for creating alert in modsec OpenSearch Cluster

module "opensearch_alert_modsec_1" {

  source = "../"

  aws_opensearch_domain          = "cp-live-modsec-audit"
  aws_iam_role                   = "opensearch-access-role"
  index                          = ["live_k8s_modsec*", "live_k8s_modsec_ingress*"]

  secret_name                    = "live-test-development-014c5454b9aca2da"
  secret_key                     = "url"

  slack_channel_name             = "test-example-modsec-1"
  slack_channel_name_description = "slack-channel-description"

  environment_name               = var.environment
  opensearch_alert_name          = "test-example-modsec-1" #To main uniqueness, the actual alert will be in the format of "${var.environment_name}-${var.opensearch_alert_name}-${local.identifier}"
  opensearch_alert_enabled       = true
  monitor_period_interval        = "1"
  monitor_period_unit            = "MINUTES"

  trigger_name                   = "test-example-modsec-1"
  serverity                      = 1
  query_source                   = "ctx.results[0].hits.total.value > 100"
  action_name                    = "test-example-modsec-1"
  slack_message_subject          = "slack-message-subject"
  slack_message_template         = "Monitor {{ctx.monitor.name}} just entered alert status. Please investigate the issue.\n- Trigger: {{ctx.trigger.name}}\n- Severity: {{ctx.trigger.severity}}" 
  alert_throttle_enabled         = true
  throttle_value                 = 60
  throttle_unit                  = "MINUTES"
  alert_query = jsonencode(
    {
      "size" : 0,
      "query" : {
        "bool" : {
          "filter" : [
            {
              "bool" : {
                "filter" : [
                  {
                    "bool" : {
                      "should" : [
                        {
                          "match_phrase" : {
                            "kubernetes.namespace_name" : {
                              "query" : "kube-system",
                              "slop" : 0,
                              "zero_terms_query" : "NONE",
                              "boost" : 1
                            }
                          }
                        }
                      ],
                      "adjust_pure_negative" : true,
                      "minimum_should_match" : "1",
                      "boost" : 1
                    }
                  },
                  {
                    "bool" : {
                      "filter" : [
                        {
                          "bool" : {
                            "should" : [
                              {
                                "match_phrase" : {
                                  "kubernetes.pod_name" : {
                                    "query" : "external-dns-*",
                                    "slop" : 0,
                                    "zero_terms_query" : "NONE",
                                    "boost" : 1
                                  }
                                }
                              }
                            ],
                            "adjust_pure_negative" : true,
                            "minimum_should_match" : "1",
                            "boost" : 1
                          }
                        },
                        {
                          "bool" : {
                            "filter" : [
                              {
                                "bool" : {
                                  "should" : [
                                    {
                                      "match_phrase" : {
                                        "log" : {
                                          "query" : "level=error",
                                          "slop" : 0,
                                          "zero_terms_query" : "NONE",
                                          "boost" : 1
                                        }
                                      }
                                    }
                                  ],
                                  "adjust_pure_negative" : true,
                                  "minimum_should_match" : "1",
                                  "boost" : 1
                                }
                              },
                              {
                                "bool" : {
                                  "should" : [
                                    {
                                      "match_phrase" : {
                                        "log" : {
                                          "query" : "Throttling: Rate exceeded",
                                          "slop" : 0,
                                          "zero_terms_query" : "NONE",
                                          "boost" : 1
                                        }
                                      }
                                    }
                                  ],
                                  "adjust_pure_negative" : true,
                                  "minimum_should_match" : "1",
                                  "boost" : 1
                                }
                              }
                            ],
                            "adjust_pure_negative" : true,
                            "boost" : 1
                          }
                        }
                      ],
                      "adjust_pure_negative" : true,
                      "boost" : 1
                    }
                  }
                ],
                "adjust_pure_negative" : true,
                "boost" : 1
              }
            },
            {
              "range" : {
                "@timestamp" : {
                  "from" : "{{period_end}}||-1m",
                  "to" : "{{period_end}}",
                  "include_lower" : true,
                  "include_upper" : true,
                  "format" : "epoch_millis",
                  "boost" : 1
                }
              }
            }
          ],
          "adjust_pure_negative" : true,
          "boost" : 1
        }
      }
    }
  )
}


module "opensearch_alert_modsec_2" {

  source = "../"

  aws_opensearch_domain          = "cp-live-modsec-audit"
  aws_iam_role                   = "opensearch-access-role"
  index                          = ["live_k8s_modsec*", "live_k8s_modsec_ingress*"]

  secret_name                    = "live-test-development-014c5454b9aca2da"
  secret_key                     = "url"

  slack_channel_name             = "test-example-modsec-2"
  slack_channel_name_description = "slack-channel-description"

  environment_name               = var.environment
  opensearch_alert_name          = "test-example-modsec-2" #To main uniqueness, the actual alert will be in the format of "${var.environment_name}-${var.opensearch_alert_name}-${local.identifier}"
  opensearch_alert_enabled       = true
  monitor_period_interval        = "1"
  monitor_period_unit            = "MINUTES"

  trigger_name                   = "test-example-modsec-2"
  serverity                      = 1
  query_source                   = "ctx.results[0].hits.total.value > 100"
  action_name                    = "test-example-modsec-2"
  slack_message_subject          = "slack-message-subject"
  slack_message_template         = "Monitor {{ctx.monitor.name}} just entered alert status. Please investigate the issue.\n- Trigger: {{ctx.trigger.name}}\n- Severity: {{ctx.trigger.severity}}" 
  alert_throttle_enabled         = true
  throttle_value                 = 60
  throttle_unit                  = "MINUTES"
  alert_query = jsonencode(
    {
      "size" : 0,
      "query" : {
        "bool" : {
          "filter" : [
            {
              "bool" : {
                "filter" : [
                  {
                    "bool" : {
                      "should" : [
                        {
                          "match_phrase" : {
                            "kubernetes.namespace_name" : {
                              "query" : "kube-system",
                              "slop" : 0,
                              "zero_terms_query" : "NONE",
                              "boost" : 1
                            }
                          }
                        }
                      ],
                      "adjust_pure_negative" : true,
                      "minimum_should_match" : "1",
                      "boost" : 1
                    }
                  },
                  {
                    "bool" : {
                      "filter" : [
                        {
                          "bool" : {
                            "should" : [
                              {
                                "match_phrase" : {
                                  "kubernetes.pod_name" : {
                                    "query" : "external-dns-*",
                                    "slop" : 0,
                                    "zero_terms_query" : "NONE",
                                    "boost" : 1
                                  }
                                }
                              }
                            ],
                            "adjust_pure_negative" : true,
                            "minimum_should_match" : "1",
                            "boost" : 1
                          }
                        },
                        {
                          "bool" : {
                            "filter" : [
                              {
                                "bool" : {
                                  "should" : [
                                    {
                                      "match_phrase" : {
                                        "log" : {
                                          "query" : "level=error",
                                          "slop" : 0,
                                          "zero_terms_query" : "NONE",
                                          "boost" : 1
                                        }
                                      }
                                    }
                                  ],
                                  "adjust_pure_negative" : true,
                                  "minimum_should_match" : "1",
                                  "boost" : 1
                                }
                              },
                              {
                                "bool" : {
                                  "should" : [
                                    {
                                      "match_phrase" : {
                                        "log" : {
                                          "query" : "Throttling: Rate exceeded",
                                          "slop" : 0,
                                          "zero_terms_query" : "NONE",
                                          "boost" : 1
                                        }
                                      }
                                    }
                                  ],
                                  "adjust_pure_negative" : true,
                                  "minimum_should_match" : "1",
                                  "boost" : 1
                                }
                              }
                            ],
                            "adjust_pure_negative" : true,
                            "boost" : 1
                          }
                        }
                      ],
                      "adjust_pure_negative" : true,
                      "boost" : 1
                    }
                  }
                ],
                "adjust_pure_negative" : true,
                "boost" : 1
              }
            },
            {
              "range" : {
                "@timestamp" : {
                  "from" : "{{period_end}}||-1m",
                  "to" : "{{period_end}}",
                  "include_lower" : true,
                  "include_upper" : true,
                  "format" : "epoch_millis",
                  "boost" : 1
                }
              }
            }
          ],
          "adjust_pure_negative" : true,
          "boost" : 1
        }
      }
    }
  )
}