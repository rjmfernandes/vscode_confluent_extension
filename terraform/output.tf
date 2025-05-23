
output "cc_hands_env" {
  description = "Confluent Cloud Environment ID"
  value       = resource.confluent_environment.cc_handson_env.id
}

output "cc_handson_sr" {
  description = "CC Schema Registry Region"
  value       = data.confluent_schema_registry_cluster.cc_sr_cluster.region
}

output "cc_sr_cluster" {
  description = "CC SR Cluster ID"
  value       = data.confluent_schema_registry_cluster.cc_sr_cluster.id
}

output "cc_kafka_cluster" {
  description = "CC Kafka Cluster ID"
  value       = resource.confluent_kafka_cluster.cc_kafka_cluster.id
}

output "cc_kafka_bootstrap_public_endpoint" {
  description = "CC Kafka Bootstrap Public Endpoint"
  value       = resource.confluent_kafka_cluster.cc_kafka_cluster.bootstrap_endpoint
}

output "datagen_products" {
  description = "CC Datagen Products Connector ID"
  value       = resource.confluent_connector.datagen_products.id
}

output "SRKey" {
  description = "CC SR Key"
  value       = confluent_api_key.sr_cluster_key.id
}
output "SRSecret" {
  description = "CC SR Secret"
  value       = confluent_api_key.sr_cluster_key.secret
  sensitive = true
}

output "AppManagerKey" {
  description = "CC AppManager Key"
  value       = confluent_api_key.app_manager_kafka_cluster_key.id
}
output "AppManagerSecret" {
  description = "CC AppManager Secret"
  value       = confluent_api_key.app_manager_kafka_cluster_key.secret
  sensitive = true
}

output "ClientKey" {
  description = "CC clients Key"
  value       = confluent_api_key.clients_kafka_cluster_key.id
}
output "ClientSecret" {
  description = "CC Client Secret"
  value       = confluent_api_key.clients_kafka_cluster_key.secret
  sensitive = true
}

