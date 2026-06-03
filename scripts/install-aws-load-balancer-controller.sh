#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="ingress"

echo "Assing Helm rep..."
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks

echo "Make sure the namespace exists..."
kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

echo "installing AWS Load Balancer Controller..."
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n "${NAMESPACE}" \
  --values platform/helm-values/aws-load-balancer-controller/values.yaml

echo "AWS Load Balancer Controller installed successfully!"  