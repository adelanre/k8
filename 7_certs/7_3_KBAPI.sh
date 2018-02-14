#!/bin/bash
# The Kubernetes API Server Certificate
NETWORK_NAME="test1"

KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe "${NETWORK_NAME}" \
  --region $(gcloud config get-value compute/region) \
  --format 'value(address)')

echo "${KUBERNETES_PUBLIC_ADDRESS}"

HOST_IP=$(for instance in controller-0 controller-1 controller-2; do
 (gcloud compute instances describe ${instance} \
  --format 'value(networkInterfaces[0].networkIP)')
done)

echo "${HOST_IP}"

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=10.32.0.1,10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes
