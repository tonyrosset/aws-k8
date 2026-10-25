# Lab 02 — a healthy Pod but no Service endpoints

**Observed in our Killercoda session:** A healthy `health-lab` Pod had `app=health-lab`, while the Service selector was `app=wrong-lab`. `kubectl get endpoints` showed `<none>`. We established the mismatch, but no post-fix verification was shared.

## Reproduce on a disposable cluster

```bash
kubectl create namespace interview-labs --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f labs/k8s/01-health-probes/fixed.yaml
kubectl rollout status deployment/health-lab -n interview-labs
kubectl apply -f labs/k8s/02-service-selectors/broken-service.yaml
kubectl get pods -n interview-labs --show-labels
kubectl describe svc health-lab -n interview-labs
kubectl get endpoints health-lab -n interview-labs
```

Expected symptom: Ready Pod exists but Service has no endpoints. Confirm labels and selector before revealing the solution.

## Fix and verify

```bash
kubectl apply -f labs/k8s/02-service-selectors/fixed-service.yaml
kubectl get endpoints health-lab -n interview-labs
kubectl get pods -n interview-labs --show-labels
kubectl run selector-check -n interview-labs --image=curlimages/curl:8.12.1 --restart=Never --rm -i -- curl -i --max-time 10 http://health-lab:80/
```

Expected: endpoint IP with port 80, HTTP 200. If `selector-check` already exists, delete that *test Pod only* and retry.

## Interview explanation

A Service routes to ready Pods that match its selector. I would compare the Service selector against Pod labels and check Endpoints/EndpointSlices. A valid ClusterIP alone doesn't mean the Service has healthy backends. Document verification once completed.

### Incident notes
- Symptom: `Endpoints: <none>`.
- Root cause: Pod `app=health-lab`, Service `app=wrong-lab`.
- Fix: match the Service selector to existing Pod labels.
- Post-fix HTTP 200: **not yet recorded**.
