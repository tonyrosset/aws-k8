# Lab 07 — diagnose CPU throttling

**Status:** Both configurations were run in Killercoda; throttling before and absence of throttling in the first post-change snapshot were observed. The final repeated post-change reading and application latency comparison have **not** been provided.

## Reproduce

```bash
kubectl create namespace interview-labs --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f labs/k8s/07-cpu-throttling/broken.yaml
kubectl rollout status deployment/cpu-lab -n interview-labs
kubectl get pods -n interview-labs -l app=cpu-lab
kubectl exec -n interview-labs deployment/cpu-lab -- cat /sys/fs/cgroup/cpu.max
kubectl exec -n interview-labs deployment/cpu-lab -- cat /sys/fs/cgroup/cpu.stat
# Repeat cpu.stat after several seconds; compare deltas.
```

## Measurements from completed hands-on run

The Pod was `1/1 Running`, zero restarts. cgroups v2 reported CPU quota `10000 100000` (100m).

| Counter | Reading 1 | Reading 2 | Delta |
|---|---:|---:|---:|
| usage_usec | 3,036,796 | 5,488,430 | +2,451,634 |
| nr_periods | 303 | 548 | +245 |
| nr_throttled | 159 | 279 | +120 |
| throttled_usec | 8,221,896 | 14,428,516 | +6,206,620 |

Throttling occurred in **120 of 245 additional quota periods (about 49%)**. This is not the fraction of CPU time lost or throughput lost; it counts periods in which throttling occurred.

## Test higher limit

```bash
kubectl apply -f labs/k8s/07-cpu-throttling/fixed.yaml
kubectl rollout status deployment/cpu-lab -n interview-labs
kubectl exec -n interview-labs deployment/cpu-lab -- cat /sys/fs/cgroup/cpu.max
kubectl exec -n interview-labs deployment/cpu-lab -- cat /sys/fs/cgroup/cpu.stat
```

Observed: `cpu.max` was `100000 100000` (1000m). First new-container snapshot:

```text
usage_usec 118312299
nr_periods 1241
nr_throttled 0
throttled_usec 0
```

A subsequent reading would strengthen verification, but this snapshot already shows zero quota throttling through 1,241 CPU periods. We did **not** measure request latency or throughput.

## Interview explanation

"I created a CPU-bound Kubernetes test container and set its limit to 100m. The Pod was Ready but the cgroup CPU throttling counters increased. In two readings, 120 of 245 new CPU periods showed throttling. I raised the limit to 1000m in a controlled sandbox experiment, and the new container had no reported throttling in its first 1,241 periods. I'd confirm application latency, CPU utilization and node capacity before making such a change in production."

## Cleanup

```bash
kubectl delete deployment cpu-lab -n interview-labs
```
