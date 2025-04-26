# VS Code Confluent Extension

Just a basic first intro to VS Code Confluent Extension: https://docs.confluent.io/cloud/current/client-apps/vs-code-extension.html

- [VS Code Confluent Extension](#vs-code-confluent-extension)
  - [Disclaimer](#disclaimer)
  - [Setup](#setup)
  - [VS Code Confluent Extension](#vs-code-confluent-extension-1)
  - [Destroy Resources](#destroy-resources)

## Disclaimer

The code and/or instructions here available are **NOT** intended for production usage. 
It's only meant to serve as an example or reference and does not replace the need to follow actual and official documentation of referenced products.

## Setup

- User account on [Confluent Cloud](https://www.confluent.io/confluent-cloud/tryfree)
- Local install of [Terraform](https://www.terraform.io) (details below)
- Local install of [jq](https://jqlang.github.io/jq/download) (details below)
- Local install Confluent CLI, [install the cli](https://docs.confluent.io/confluent-cli/current/install.html) 
- Gradle [Installed](https://gradle.org/install/)

```shell
echo "Enter a prefix value as 'rfernandes-':"
read prefix_value
confluent login
CC_API_KEY_SECRET=`confluent api-key create --resource cloud --description "API for terraform"`
CC_API_KEY=`echo "$CC_API_KEY_SECRET"| grep 'API Key'|sed s/'.*| '//g|sed s/' .*'//g`
CC_API_SECRET=`echo "$CC_API_KEY_SECRET"| grep 'API Secret'|sed s/'.*| '//g|sed s/' .*'//g`
cat > $PWD/terraform/terraform.tfvars <<EOF
confluent_cloud_api_key = "$CC_API_KEY"
confluent_cloud_api_secret = "$CC_API_SECRET"
use_prefix = "$prefix_value"
EOF
cd ./terraform
terraform init -upgrade
terraform plan
terraform apply -auto-approve
CC_KAFKA_CLUSTER=`terraform output -json | jq -r .cc_kafka_bootstrap_public_endpoint.value`
KAFKA_CLUSTER_API_KEY=`terraform output -json | jq -r .ClientKey.value`
KAFKA_CLUSTER_API_SECRET=`terraform output -json | jq -r .ClientSecret.value`
cd ..
echo "Kafka Bootstrap Server=$CC_KAFKA_CLUSTER"
echo "Kafka Cluster API Key=$KAFKA_CLUSTER_API_KEY"
echo "Kafka Cluster API Secret=$KAFKA_CLUSTER_API_SECRET"
echo "Input Topic=shoe_products"
echo "Output Topic=shoe_orders"
```

## VS Code Confluent Extension

In VS Code navigate to Confluent extension and connect to Confluent Cloud. 

Consume from topic `shoe_products`.

Take a look at the schema.

Generate a Kafka Streams Application project from template. Filling out the input parameters displayed at the end of the terraform script creation of the environment:
- Kafka Bootstrap Server
- Kafka Cluster API Key
- Kafka Cluster API Secret
- Input Topic
- Output Topic

Save it in a folder called `example1` and open in it a new window. Open class file `kafka-streams-simple-example/src/main/java/examples/KafkaStreamsApplication.java` and check it should be writing an "enriched" entry into the Output Topic `shoe_orders` for every message in the Input Topic `shoe_products`.

Run:

```shell
cd example1/kafka-streams-simple-example
gradle build
gradle shadowJar
java -jar build/libs/kafka-streams-simple-0.0.1.jar
```

Check back on the VS Code Confluent Extension and consume the messages arriving from our Kafka Streams application.
You can also do that from the CC UI.
And if you navigate to the Kafka Streams CC UI you should be able to see the entry for your Kafka Streams application and navigate to the consumer group.

You can cancel now the Kafka Streams application execution and return to root of the project.

```shell
cd ../..
```

## Destroy Resources

```bash
cd terraform
terraform destroy -auto-approve
cd ..
rm -fr example1
```