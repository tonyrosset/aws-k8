#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="gitops"

echo "Adding ArgoCD Helm repo..."
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update argo

echo "Ensuring the namespace exists..."
kubectl create namespace "${NAMESPACE}" --dry-run=client -o yaml | kubectl apply -f -

echo "Installing ArgoCD..."
helm upgrade --install argocd argo/argo-cd \
  -n "${NAMESPACE}" \
  --values platform/helm-values/argocd-apps/values.yaml

echo "waiting for ArgoCD to be ready..."
kubectl rollout status deployment/argocd-server -n "${NAMESPACE}"

echo "ArgoCD installed successfully!"