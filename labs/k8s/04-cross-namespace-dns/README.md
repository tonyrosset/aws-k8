# Lab 04 — cross-namespace Service DNS

**Observed and user-confirmed:** Curl from `client-lab` to `http://health-lab:80/` failed with `curl: (6) Could not resolve host: health-lab`. Switching to the Service's namespace-qualified DNS name worked.

## Reproduce in a fresh playground

```bash
kubectl create namespace interview-labs --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f labs/k8s/01-health-probes/fixed.yaml
kubectl rollout status deployment/health-lab -n interview-labs
kubectl create namespace client-lab --dry-run=client -o yaml | kubectl apply -f -
kubectl get svc -n interview-labs
kubectl run dns-bad -n client-lab --image=curlimages/curl:8.12.1 --restart=Never --rm -i -- curl -v --max-time 10 http://health-lab:80/
```

Expected: name resolution fails from a different namespace, because an unqualified name is resolved using the client's DNS search paths.

## Fix without changing the Service

```bash
kubectl run dns-good -n client-lab --image=curlimages/curl:8.12.1 --restart=Never --rm -i -- curl -i --max-time 10 http://health-lab.interview-labs.svc.cluster.local:80/
```

For most clusters, the short cross-namespace name `health-lab.interview-labs` also works. `cluster.local` is the typical, but configurable, cluster DNS suffix.

## Investigate deeper (optional)

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns
kubectl get service kube-dns -n kube-system
kubectl get svc health-lab -n interview-labs
```

A DNS failure is not proof that CoreDNS is down: first confirm hostname, namespace, search domains, and Service existence.

### Interview explanation (after completing the exercise)

"I had a client Pod in another namespace that couldn't resolve a Service's bare name. I checked the client's namespace and used the fully qualified Kubernetes Service DNS name; connectivity then succeeded. This was a controlled Kubernetes sandbox exercise."
