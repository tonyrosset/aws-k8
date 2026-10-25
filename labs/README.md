# AWS + Kubernetes Interview Troubleshooting Labs

Practical exercises for Infrastructure / Platform Engineering interviews, based on the existing `aws-k8` repository. Work in disposable namespaces on Killercoda, a local kind cluster, or an appropriate training environment.

**Never run the existing `infra/environments/dev/core` Terraform configuration against a temporary playground without adapting it.** It references an account-specific S3 backend, managed EKS, IAM and network resources. No real AWS infrastructure is required for Kubernetes Labs 01–06.

## Progress recorded from our conversation (25 October 2026)

| Lab | Topic | Evidence observed | Status |
|---|---|---|---|
| 01 | Health probes | 404 on both probes, kubelet restarts; subsequently `1/1 Running`, zero restarts and HTTP 200 through the Service | **Fixed and verified** |
| 02 | Service selectors | Pod `app=health-lab`; Service `app=wrong-lab`; endpoints `<none>` | **Root cause verified; corrected state not confirmed** |
| 03 | Service targetPort | Endpoints `192.168.1.74:8080`; DNS resolved but curl returned `Connection refused` | **Root cause verified; post-fix HTTP 200 not confirmed** |
| 04 | Cross-namespace DNS | `curl: (6) Could not resolve host: health-lab` from `client-lab`; namespace-qualified Service hostname worked | **Fixed and user-reported successful** |
| 05 | ImagePullBackOff | Registry reported `nginx:1.27-alpin: not found` and `ImagePullBackOff` | **Root cause verified; corrected rollout not confirmed** |
| 06 | OOMKilled | Prepared reproducible memory-limit scenario | **Not yet run** |

The statuses distinguish what was demonstrated in the playground from what remains to be checked. These are **sandbox exercises, not incidents in an employer's production environment**.

## Resume after a Killercoda session expires

Open a fresh Kubernetes playground, then execute:

```bash
git clone -b interview-labs https://github.com/tonyrosset/aws-k8.git
cd aws-k8
kubectl config current-context
kubectl get nodes
kubectl create namespace interview-labs --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f labs/k8s/01-health-probes/fixed.yaml
kubectl rollout status deployment/health-lab -n interview-labs --timeout=120s
kubectl get pods,svc,endpoints -n interview-labs
```

To start Lab 06, the namespace is enough; you do not need to redeploy the Nginx baseline. See [Lab 06](k8s/06-oomkilled/README.md).

## Exercise index

1. [Lab 01 — failing health probes](k8s/01-health-probes/README.md): readiness, liveness and restarts.
2. [Lab 02 — mismatched Service selector](k8s/02-service-selectors/README.md): healthy Pod, zero endpoints.
3. [Lab 03 — incorrect Service targetPort](k8s/03-service-ports/README.md): valid endpoints, TCP connection refused.
4. [Lab 04 — cross-namespace DNS](k8s/04-cross-namespace-dns/README.md): short hostname versus namespace-qualified Service name.
5. [Lab 05 — ImagePullBackOff](k8s/05-image-pull/README.md): typo in image tag, registry NotFound and retries.
6. [Lab 06 — OOMKilled](k8s/06-oomkilled/README.md): memory limits, exit code 137 and resource diagnosis.

## Our method

1. Reproduce the error.
2. Inspect `kubectl get`, `kubectl describe`, events and logs.
3. Form a hypothesis and confirm the root cause.
4. Modify a *copy* of the YAML (or use the provided fixed example).
5. Verify rollout and end-to-end behavior.
6. Document what actually happened, including any unverified steps.

Avoid entering credentials in shared playgrounds: session terminal output may be recorded. Local YAML changes in an expired playground are not automatically committed to this repository.

## Labs 07–08

- [Lab 07 — CPU throttling](k8s/07-cpu-throttling/README.md): measured 49% of quota periods throttled at 100m; no throttling reported across 1,241 periods at 1000m, pending final repeat snapshot.
- [Lab 08 — AWS VPC routing](aws/08-vpc-routing/README.md): inspect our Terraform's public/private route tables, EKS subnet choice and egress design. Read-only, no AWS provisioning.

