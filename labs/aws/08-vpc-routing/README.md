# Lab 08 — AWS VPC routing: private EKS nodes cannot reach image registries

**Status:** Prepared from the existing repository's Terraform; static investigation only. No live AWS test has been run, and no AWS resources should be provisioned without cost and permission review.

## Scenario

An EKS node group is migrated from the existing public subnets to private subnets. After the change, Pods may get stuck pulling ECR images and nodes may lose outbound internet reachability. Investigate the VPC networking setup before changing IAM.

This is a **hypothetical migration failure**, not a confirmed incident in the existing deployment.

## Explore the existing Terraform configuration

```bash
git checkout interview-labs
sed -n '1,240p' infra/modules/vpc/main.tf
sed -n '1,110p' infra/environments/dev/core/main.tf
grep -R -n -E 'aws_nat_gateway|aws_route|aws_vpc_endpoint|private_subnet_ids' infra/modules infra/environments/dev/core
```

Find:
1. VPC CIDR range and the two public/private subnet CIDR ranges.
2. The Internet Gateway.
3. The `0.0.0.0/0` public route and which route tables are associated with public subnets.
4. The private route tables and what, if any, outbound routes they contain.
5. The subnet IDs fed into the EKS module by `infra/environments/dev/core/main.tf`.

### Investigation questions

- What determines whether a subnet is public or private? Does `map_public_ip_on_launch` *alone* make it public?
- Do the private route tables in this module allow an instance to reach the public internet over IPv4? Why?
- If nodes were moved into private subnets, how could they access Amazon ECR image endpoints, S3 image layers, AWS STS and the EKS control plane as needed?
- What is the difference between an Internet Gateway, NAT Gateway and an interface/gateway VPC endpoint?
- Why are security groups only one part of connectivity troubleshooting?
- If you set `private_subnet_ids = module.vpc.private_subnet_ids`, what other prerequisites would you review **before** applying Terraform?

## Grounded observations (open only after trying yourself)

In `infra/modules/vpc/main.tf`, the **public** route table has `aws_route.public_internet_access` setting `0.0.0.0/0` to `aws_internet_gateway.main.id`. Public subnets are associated with this route table.

The **private** route tables are created and associated with private subnets, but the module contains no NAT Gateway, `0.0.0.0/0` private route, or VPC endpoints. The implicit VPC-local route allows local traffic only, not general public internet egress. As defined by this module, instances in those private subnets would require additional egress architecture to reach public IPv4 destinations.

In `infra/environments/dev/core/main.tf`, the EKS module currently gets `module.vpc.public_subnet_ids` in a variable named `private_subnet_ids`, with a comment to switch later. Do not assume this is an accidental production failure: it may be a temporary development choice. The EKS cluster and node group both use this passed list in the existing EKS module.

## Safe remediation planning — without provisioning

Option A: NAT Gateway(s) in public subnets, and a private subnet default route to NAT. Review high-availability needs, monthly/per-GB cost, and egress controls.

Option B: Suitable VPC endpoints for required AWS services (e.g., ECR API/DKR interface endpoints and S3 gateway endpoint), plus required security groups, private DNS and routing. Consider STS, CloudWatch and other dependencies as the workload requires. This is not automatically a full replacement for general internet egress.

Also confirm the EKS API endpoint access mode, node group prerequisites, cluster security groups, private DNS resolution, subnet IP capacity and IAM policies.

**Do not copy a NAT Gateway Terraform snippet into your real account without checking costs.** This lab is intentionally a read-only code investigation first.

## Real-AWS diagnostic commands (only in an authorized AWS environment)

```bash
aws sts get-caller-identity
aws ec2 describe-route-tables --region YOUR_REGION --filters Name=vpc-id,Values=YOUR_VPC_ID
aws ec2 describe-nat-gateways --region YOUR_REGION --filter Name=vpc-id,Values=YOUR_VPC_ID
aws ec2 describe-vpc-endpoints --region YOUR_REGION --filters Name=vpc-id,Values=YOUR_VPC_ID
aws eks describe-cluster --region YOUR_REGION --name YOUR_CLUSTER --query 'cluster.resourcesVpcConfig'
```

Replace placeholders; these are read-only API calls and are **not** expected to work in Killercoda's Kubernetes-only playground.

## Interview explanation target

"I reviewed the Terraform VPC module, traced the public route through the Internet Gateway, and noticed the private route tables had no outbound route or AWS service endpoints defined. I explained why migrating EKS worker nodes into those subnets requires NAT or carefully selected VPC endpoints, depending on dependencies. This was a repository-based architecture review rather than a live AWS production incident."
