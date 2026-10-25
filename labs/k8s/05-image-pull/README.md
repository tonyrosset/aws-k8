# Lab 05 — ErrImagePull / ImagePullBackOff

**Observed:** Kubernetes successfully scheduled the Pod, but could not pull `docker.io/library/nginx:1.27-alpin` because the tag did not exist. Events included `ErrImagePull`, repeated `BackOff`, and `ImagePullBackOff`.

## Reproduce

```bash
kubectl create namespace interview-labs --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f labs/k8s/05-image-pull/broken.yaml
kubectl get pods -n interview-labs
kubectl describe pods -n interview-labs -l app=image-lab
kubectl get events -n interview-labs --sort-by=.lastTimestamp
```

Look for `not found` and the exact image tag. `ErrImagePull` is the pull error, while `ImagePullBackOff` indicates delay before the next retry. This is **not** `CrashLoopBackOff` because the application never started.

## Fix + verify

```bash
kubectl apply -f labs/k8s/05-image-pull/fixed.yaml
kubectl rollout status deployment/image-lab -n interview-labs --timeout=120s
kubectl get pods -n interview-labs -l app=image-lab
kubectl describe pods -n interview-labs -l app=image-lab
```

Expected: image successfully pulled and a new Pod reaches `1/1 Running`, but **post-fix success was not shared in the original session**.

## AWS ECR follow-up

For EKS + ECR, image pulls can also fail due to non-existent tags, missing registry credentials or IAM permissions, registry reachability, and network paths to ECR/S3. Investigate the actual event message before changing permissions. In an allowed AWS sandbox:

```bash
aws ecr describe-images --repository-name YOUR_REPOSITORY --image-ids imageTag=YOUR_TAG --region YOUR_REGION
```

Use placeholders; do not paste live credentials into shared sandboxes.
