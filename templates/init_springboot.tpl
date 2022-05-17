#!/bin/bash
#######################PreWork, Git & Java
sudo yum update -y
sudo yum install git -y
sudo amazon-linux-extras install java-openjdk11 -y


######################################### Download components
cd /opt/
git clone https://github.com/chrisp1982/SpringBoot.git
wget https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar
cd SpringBoot
git pull
########################################## Install Component Pet Clinic based on SpringBoot
./mvnw package

######################################### Start OpenTelemetry sigNoz Agent and Pet Clinic
java -javaagent:/opt/opentelemetry-javaagent.jar \
     -Dotel.metrics.exporter=none \
     -Dotel.exporter.otlp.endpoint=http://${signoz_host}:4317 \
     -Dotel.resource.attributes="service.name=Pet_Clinic_$HOSTNAME" \
     -jar target/*.jar


