# Lab 06 — OOMKilled and memory limits

**Status:** Prepared; **not yet executed**. Designed for disposable Killercoda/Kubernetes playground. Uses a small memory limit so it cannot consume unlimited node memory. Do not deploy to production.

## Interview scenario

A developer reports: "The Pod starts but repeatedly restarts. The logs show a Python application allocating memory. Is it a bug, a Kubernetes probe issue, or a resource limit?"

## 1. Bootstrap after a Killercoda restart

```bash
git clone -b interview-labs https://github.com/tonyrosset/aws-k8.git
cd aws-k8
kubectl config current-context
kubectl get nodes
kubectl create namespace interview-labs --dry-run=client -o yaml | kubectl apply -f -
```

No Nginx baseline is required for this lab.

## 2. Reproduce the failure

```bash
kubectl apply -f labs/k8s/06-oomkilled/broken.yaml
kubectl get pods -n interview-labs -l app=memory-lab -w
```

Stop the watch with Ctrl+C after a restart or waiting/backoff status. Then inspect:

```bash
kubectl describe pods -n interview-labs -l app=memory-lab
kubectl get pods -n interview-labs -l app=memory-lab -o wide
kubectl logs -n interview-labs deployment/memory-lab --previous --tail=30
kubectl get events -n interview-labs --sort-by=.lastTimestamp
```

Expected clues: termination `Reason: OOMKilled`, frequently `Exit Code: 137` and repeated restarts / `CrashLoopBackOff`. Logs may end abruptly or previous logs may be unavailable. Distinguish a terminated **container** from a failed **readiness** probe; no probes are configured in this exercise.

If you do not see the expected reason, paste the actual `describe` output; do not assert OOMKilled based on exit code 137 alone.

### Questions before looking at the fix

1. What are memory `requests` vs `limits`, and what does the scheduler use?
2. What does `OOMKilled` tell you? What does exit code 137 alone **not** prove?
3. Why is this different from `ErrImagePull` or a probe-driven restart?
4. Which memory measurements, application profiles and deployment changes would you check in production?
5. When might raising the memory limit be appropriate versus fixing a memory leak?

## 3. Apply bounded-memory fix

This solution changes the *application's consumption* (allocates only 16Mi of bytearrays) while preserving the 48Mi limit. It is not a recommendation to suppress production OOM issues by blindly increasing limits.

```bash
kubectl diff -f labs/k8s/06-oomkilled/fixed.yaml || true
kubectl apply -f labs/k8s/06-oomkilled/fixed.yaml
kubectl rollout status deployment/memory-lab -n interview-labs --timeout=120s
kubectl get pods -n interview-labs -l app=memory-lab
kubectl logs -n interview-labs deployment/memory-lab --tail=30
```

Expected: new Pod stays `1/1 Running` with zero restarts; application logs show bounded allocation. Observe for long enough to see stability.

## 4. Cleanup (optional)

```bash
kubectl delete deployment memory-lab -n interview-labs
```

## Interview answer (only after you run it)

"In a Kubernetes sandbox lab I diagnosed a container restarting due to a memory-limit breach. I used `kubectl describe` to inspect the terminated container state and checked previous logs. I compared memory requests and limits with the application's consumption, reduced the artificial memory growth, then verified the replacement Pod stayed healthy. In production I'd check working-set metrics and profiles and decide whether the issue was a leak, a burst, or an incorrectly sized limit."

### Personal run record
- Date / environment:
- `kubectl describe` reason + exit code:
- Logs observed:
- Root cause:
- Fix applied:
- Healthy Pod and restart count:
- Improvements for production:
