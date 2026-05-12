---
layout: page
title: Homelab Kubernetes Cluster
description: Bare-metal Kubernetes platform for self-hosted ML, RAG, and future projects
importance: 3
category: work
github: https://github.com/kmikol/cluster
giscus_comments: false
---

A bare-metal homelab Kubernetes cluster built as the deployment platform for personal projects.

**[View on GitHub](https://github.com/kmikol/cluster)**

---

## Context

This project grew out of the RAG deployment problem. A local laptop deployment was useful for
development, but it was not the right operational target for a private knowledge system. A managed
cloud deployment would solve some infrastructure problems, but it would also introduce recurring
costs for a personal project.

The more interesting answer was to self-host the platform. The cluster is both a practical deployment
target and a systems project in its own right: physical nodes, host bootstrap, Kubernetes, ingress,
storage, observability, private remote access, and application delivery all managed as code.

## Platform Scope

The repository owns the cluster layer rather than application internals. It defines node inventory,
host setup, K3s installation, networking, DNS, certificates, storage classes, monitoring, GitOps
integration, and verification workflows. Application repositories keep their own source code,
charts, images, migrations, and development workflows.

That boundary matters because the cluster is intended to host more than one project. RAG is the
immediate forcing function, but the same platform can host `ml-system` and future experiments without
copying application-specific details into the infrastructure repository.

## Architecture

The cluster runs on Ubuntu nodes managed with Ansible and forms a multi-server K3s cluster. Flannel
keeps the CNI simple. MetalLB and Traefik provide LAN ingress, with `cluster.home.arpa` as the local
entrypoint. cert-manager issues certificates from an internal CA for LAN HTTPS.

Remote access is handled through Tailscale and the Tailscale Kubernetes Operator. Persistent
workloads use Longhorn with explicit storage-class choices rather than relying on a default
StorageClass. Monitoring is built around kube-prometheus-stack and Grafana, and Ray/KubeRay are
included for compute experiments.

## Operational Model

Ansible owns bootstrap and platform setup: base host configuration, Tailscale, K3s, namespaces,
networking, certificates, DNS, Longhorn, monitoring, and compute services. Argo CD is being added
as the reconciliation layer for applications, while Ansible remains responsible for the underlying
cluster bootstrap.

The planned RAG deployment follows that split. The RAG repository will publish container images and
a reusable Helm chart. The cluster repository will own the homelab-specific deployment intent:
namespace, Argo CD application, chart version pin, sealed secrets, storage choices, ingress exposure,
resource limits, and verification.

---

## Technology Stack

| Layer | Technology |
|---|---|
| Host Automation | Ansible |
| Kubernetes | K3s |
| Networking | Flannel, MetalLB, Traefik |
| Private Access | Tailscale, Tailscale Kubernetes Operator |
| Certificates | cert-manager, internal CA |
| Storage | Longhorn |
| GitOps | Argo CD, Sealed Secrets |
| Observability | kube-prometheus-stack, Grafana |
| Compute Experiments | Ray, KubeRay |

---

## Design Decisions

The cluster is documented through ADRs, with emphasis on keeping the platform understandable and
recoverable. Decisions cover local DNS, explicit storage policy, namespace conventions, the boundary
between Ansible and GitOps, simple networking, LAN versus tailnet exposure, and how application
repositories integrate with the cluster.

Notable decisions include:

- [Cluster Domain and Local DNS](https://github.com/kmikol/cluster/blob/main/docs/adr/001-cluster-domain-and-dns.md) — why `cluster.home.arpa` is the LAN entrypoint
- [Explicit StorageClass Policy](https://github.com/kmikol/cluster/blob/main/docs/adr/002-storage-class-policy.md) — why workloads must choose storage durability explicitly
- [Ansible and GitOps Boundary](https://github.com/kmikol/cluster/blob/main/docs/adr/004-ansible-and-gitops-boundary.md) — how bootstrap and application reconciliation are separated
- [LAN and Tailnet Access Boundary](https://github.com/kmikol/cluster/blob/main/docs/adr/007-lan-and-tailnet-access-boundary.md) — how local and private remote access are kept distinct
- [RAG Application Deployment](https://github.com/kmikol/cluster/blob/main/docs/adr/010-rag-application-deployment.md) — how the RAG application will be consumed by the cluster

**[View ADRs on GitHub](https://github.com/kmikol/cluster/blob/main/docs/adr/index.md)**
