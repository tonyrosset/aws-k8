# Lab 01: Kubernetes probes and restart loops

**Goal:** Distinguish readiness vs liveness probe failures; identify why a seemingly healthy nginx process is restarted.

**Environment:** KodeKloud Kubernetes Playground (or local kind/minikube), with a working `kubectl` context. No AWS account needed. **This lab has not yet been executed.**

## 1. Prepare and reproduce

Run from the repository root:

```bash
kubectl config current-context
kubectl create namespace interview-labs --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f labs/k8s/01-health-probes/broken.yaml
kubectl get pods -n interview-labs -w
```

After a little while, the Pod will be marked unready and may eventually show `CrashLoopBackOff` because the liveness probe repeatedly receives HTTP 404. A failed readiness probe **does not restart a container**; the failing liveness probe causes the restart.

## 2. Investigate before inspecting the fix

```bash
kubectl get deploy,po,svc,endpoints -n interview-labs
kubectl describe pod -l app=health-lab -n interview-labs
kubectl logs -l app=health-lab -n interview-labs --tail=50
kubectl get events -n interview-labs --sort-by=.lastTimestamp
```

Look for `Readiness probe failed`, `Liveness probe failed`, HTTP 404, and `Killing` events. The nginx logs may still show valid startup; that is the point of this investigation.

Questions to explain aloud:

1. Is the container process failing, or is Kubernetes killing it? How can you tell?
2. What does readiness control versus liveness?
3. What changes if only readiness fails?
4. Why might a liveness probe that is too aggressive create an outage?
5. How would you safely patch a service with a real `/health` endpoint instead of changing it to `/`?

## 3. Apply a fix and verify

Only after you have a hypothesis, compare `fixed.yaml` to `broken.yaml`.

```bash
kubectl diff -f labs/k8s/01-health-probes/fixed.yaml || true
kubectl apply -f labs/k8s/01-health-probes/fixed.yaml
kubectl rollout status deployment/health-lab -n interview-labs --timeout=120s
kubectl get pods -n interview-labs
kubectl describe pod -l app=health-lab -n interview-labs
kubectl port-forward -n interview-labs service/health-lab 8080:80
# From a second terminal, on your own machine:
curl -i http://localhost:8080/
```

Expected: nginx returns HTTP 200, Deployment becomes available, and new Pod stays Ready without further probe-triggered restarts. Verify with **actual output**: do not report this lab as completed until you've run it.

## 4. Cleanup

```bash
kubectl delete namespace interview-labs
```

## 5. Interview explanation

> I reproduced a health-probe incident in a disposable Kubernetes environment. I noticed the container was starting normally, but Kubernetes reported HTTP 404 responses on the liveness and readiness probes. By inspecting Pod events and comparing the probe paths against the actual endpoint, I identified a configuration mistake. I corrected the probes, watched the rollout complete, and confirmed HTTP 200 through the Service. This was a hands-on sandbox troubleshooting exercise, not a production incident.

Use this answer **only after actually completing and verifying the lab**.

### Notes from my run

- Date and environment:
- Symptoms and exact event text:
- First hypothesis:
- Root cause:
- Changes made:
- Verification output:
- Follow-up improvement:
