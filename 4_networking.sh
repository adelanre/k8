#!/bin/bash

# Create VPC Network
NETWORK_NAME="test1"
SUBNET_NAME="kubernetes"
gcloud compute networks create "${NETWORK_NAME}" --subnet-mode custom

gcloud compute networks subnets create "${SUBNET_NAME}" \
  --network "${NETWORK_NAME}" \
  --range 10.240.0.0/24

gcloud compute firewall-rules create "${NETWORK_NAME}"-allow-internal \
  --allow tcp,udp,icmp \
  --network "${NETWORK_NAME}" \
  --source-ranges 10.240.0.0/24,10.200.0.0/16

gcloud compute firewall-rules create "${NETWORK_NAME}"-allow-external \
  --allow tcp:22,tcp:6443,icmp \
  --network "${NETWORK_NAME}" \
  --source-ranges 0.0.0.0/0

gcloud compute firewall-rules list --filter="network:"${NETWORK_NAME}""

gcloud compute addresses create "${NETWORK_NAME}" \
  --region $(gcloud config get-value compute/region)

gcloud compute addresses list --filter="name=('"${NETWORK_NAME}"')"
