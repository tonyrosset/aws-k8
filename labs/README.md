# AWS & Kubernetes Troubleshooting Labs

Hands-on interview preparation for Infrastructure/Platform Engineering. These labs extend the existing `aws-k8` reference platform without changing its real AWS configuration.

## Environments

- **Kubernetes labs:** KodeKloud Kubernetes multi-node playground (or local kind/minikube). Use a real Kubernetes API server and `kubectl`.
- **AWS labs:** KodeKloud AWS Cloud Playground for IAM, EC2, VPC, CloudWatch, ECR and constrained EKS scenarios. Keep AWS resources within the playground's published quotas.
- **Local integration labs:** Floci at `http://localhost:4566` for selected AWS-compatible APIs and Terraform testing. This is **not** an actual AWS account.

> Do not `terraform apply` the existing `infra/environments/dev/core` to KodeKloud unchanged. The current configuration uses managed EKS node groups, an instance type outside KodeKloud's allowed list, account-specific resources and a persistent S3 backend. A separate sandbox configuration is needed first.

## Practical learning path

| Stage | Subject | Hands-on outcome |
| --- | --- | --- |
| 1 | Kubernetes fundamentals + debugging | Explain Pod lifecycle, probes, events, logs and restart behavior |
| 2 | Kubernetes networking | Diagnose Service selectors, DNS, ports and ingress |
| 3 | Deploying our FastAPI Helm chart | Diagnose images, Secrets, resource requirements and rollout |
| 4 | AWS identity and networking | Trace IAM errors, security groups, routing, public/private subnets |
| 5 | Terraform | Safely plan, validate and investigate state and drift |
| 6 | CI/CD + ECR | Diagnose failed image build/push and release workflows |
| 7 | EKS-specific operations | Troubleshoot node/Pod scheduling and AWS integration within sandbox restrictions |
| 8 | Observability + incident response | Practice triage, rollback and documenting a postmortem |

## Lab method

1. **Reproduce:** Apply the broken manifest/configuration to a disposable environment.
2. **Observe:** Record actual command output; distinguish symptoms from root causes.
3. **Hypothesize:** Identify likely causes and what evidence would confirm them.
4. **Fix:** Change only the necessary config.
5. **Verify:** Confirm readiness, restarts, logs and end-to-end traffic.
6. **Document:** Write a short incident record, including what you did yourself.

Record platform and boundaries truthfully: a KodeKloud lab is hands-on Kubernetes/AWS sandbox experience; Floci tests are emulated AWS; neither should be described as owning a company's production incident.

## First lab

Go to [Kubernetes Lab 01: Failing Health Probes](k8s/01-health-probes/README.md). Do the exercise before opening the solution file.
