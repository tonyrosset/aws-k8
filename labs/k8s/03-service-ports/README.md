# Lab 03 — healthy Pod, Service endpoint, but connection refused

**Observed:** `kubectl get endpoints` showed `health-lab 192.168.1.74:8080`. Curl resolved `health-lab` to ClusterIP `10.107.100.216` but returned `curl: (7) ... Connection refused`.

The Service's `targetPort: 8080` forwarded TCP to a port not used by the default nginx server (listening on 80). This is different from a DNS failure or an empty Service selector.

## Reproduce

```bash
kubectl create namespace interview-labs --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f labs/k8s/01-health-probes/fixed.yaml
kubectl rollout status deployment/health-lab -n interview-labs
kubectl apply -f labs/k8s/03-service-ports/broken-service.yaml
kubectl get pods,svc,endpoints -n interview-labs
kubectl run port-check -n interview-labs --image=curlimages/curl:8.12.1 --restart=Never --rm -i -- curl -v --max-time 10 http://health-lab:80/
```

Expected: DNS resolution succeeds; endpoint shows `:8080`; curl gets connection refused. The precise error depends on cluster networking.

## Investigate

```bash
kubectl describe svc health-lab -n interview-labs
kubectl get endpoints health-lab -n interview-labs
kubectl get pods -n interview-labs
```

The Service `port` is its client-facing port; `targetPort` is the Pod's actual listening port. A `containerPort` declaration does not configure the application listener.

## Fix + verify

```bash
kubectl apply -f labs/k8s/03-service-ports/fixed-service.yaml
kubectl get endpoints health-lab -n interview-labs
kubectl delete pod port-check -n interview-labs --ignore-not-found --wait=true
kubectl run port-check -n interview-labs --image=curlimages/curl:8.12.1 --restart=Never --rm -i -- curl -i --max-time 10 http://health-lab:80/
```

Expected: endpoint `:80` and HTTP 200; **post-fix success has not yet been reported for this lab**.

### Interview takeaway

When a Service has endpoints but requests fail, I'd check DNS, the Service's `port`/`targetPort`, the application's actual listening socket, and possible NetworkPolicies, before assuming the Pod is unhealthy.
