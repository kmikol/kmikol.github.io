---
layout: page
title: MLOps System
description: End-to-end machine learning platform with event-driven retraining and canary deployments
img: /assets/projects/ml-system/ml-system_grafana_thumbnail.png
importance: 1
category: work
giscus_comments: false
---

A production-grade MLOps platform built to demonstrate end-to-end machine learning infrastructure
patterns: model serving, continuous retraining, and safe canary deployments — all running locally
on Kubernetes.

**[View on GitHub](https://github.com/kmikol/ml-system) · [Full Documentation](https://kmikol.github.io/ml-system/architecture/)**

---

## Overview

Most ML projects stop at training a model. This system builds everything around it: the infrastructure
to serve predictions reliably, detect when the model degrades, retrain automatically, and promote new
models safely without downtime.

The current implementation runs MNIST classification end-to-end, but the architecture is intentionally
domain-agnostic — designed to be extended to any classification task with minimal changes.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ml-system-c4-l1.jpg" title="System context diagram" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    <!-- PLACEHOLDER: export the C4 Level 1 diagram from the docs as an image. It is available as an SVG at https://kmikol.github.io/ml-system/architecture/c4-level-1/ -->
    System context: external actors, system boundaries, and high-level information flows.
</div>

---

## Architecture

The system is built around three core principles, each of which drove concrete design decisions.

### Separation of Concerns

Online serving, offline retraining, and observability are fully decoupled. Serving responds to
live prediction requests without any knowledge of ongoing retraining. Retraining runs in the
background, triggered by data quality signals. Neither subsystem can break the other.

### Facade-Based Storage

Application code never talks directly to Postgres, MinIO, or MLflow. Instead, two facade services
— the Data Controller and the Model Artifact Controller — own all storage interactions. Swapping
a backend (e.g. MinIO to S3) requires no changes to any business logic.

### Safe Model Promotion

New models are never promoted directly to production. Argo Rollouts gradually shifts traffic from
the stable model to a candidate, running automated PSI drift analysis at each step. A model that
introduces distribution shift is automatically rolled back before it reaches the full user base.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        <img
            loading="eager"
            src="{{ '/assets/projects/ml-system/ml-system.light.drawio.svg' | relative_url }}"
            alt="Container diagram"
            title="Container diagram"
            class="img-fluid rounded z-depth-1 only-light"
        >
        <img
            loading="eager"
            src="{{ '/assets/projects/ml-system/ml-system.dark.drawio.svg' | relative_url }}"
            alt="Container diagram"
            title="Container diagram"
            class="img-fluid rounded z-depth-1 only-dark"
        >
    </div>
</div>
<div class="caption">
    <!-- Theme-aware C4 Level 2 diagram using light/dark SVG variants. -->
    Container-level view: services, databases, and data flows organized by operational concern.
</div>

---

## System Components

The platform decomposes into four operational layers:

**Online Serving** — A FastAPI inference server runs ONNX model inference and persists prediction
records through the Data Controller facade. Serving pods are scaled horizontally by KEDA based on
live request-rate metrics from Prometheus, and deployed via Argo Rollouts for canary promotion.

**Offline Retraining Loop** — An Argo Workflows DAG orchestrates the full retraining pipeline:
sampling uncertain or drifted predictions, annotating them, retraining the model, evaluating against
a held-out test set, and producing a versioned candidate artifact in MLflow.

**Storage Layer** — Postgres holds prediction records and operational state. MinIO stores image
artifacts and model weights. MLflow handles experiment tracking and model versioning. All three are
accessed exclusively through facade services.

**Monitoring & Observability** — Prometheus scrapes metrics from all services. Grafana provides
operational and model-quality dashboards. Loki aggregates structured logs. Alloy runs as a
collection agent routing telemetry from pods to the appropriate backends.

<div class="row">
    <div class="col-sm-6 mt-3 mt-md-0">
        <img
            loading="lazy"
            src="https://kmikol.github.io/ml-system/fig/ml-system-production%20load%20test.png"
            alt="Production load test dashboard showing request volume, error rate, active pods, latency percentiles, PSI, and class-frequency drift"
            title="Production load test dashboard"
            class="img-fluid rounded z-depth-1"
        >
    </div>
    <div class="col-sm-6 mt-3 mt-md-0">
        <img
            loading="lazy"
            src="https://kmikol.github.io/ml-system/fig/ml-system-canary%20rollout.png"
            alt="Canary rollout dashboard showing traffic split, production and canary pod counts, request rate, latency, PSI, and confidence by stage"
            title="Canary rollout dashboard"
            class="img-fluid rounded z-depth-1"
        >
    </div>
</div>
<div class="caption">
    Left: Grafana dashboard from the published docs showing production load-test serving metrics,
    autoscaling behavior, latency, PSI, and class-frequency drift. Right: Grafana dashboard showing
    the canary rollout traffic split, pod counts, latency, PSI, and confidence by stage.
</div>

---

## Technology Stack

| Layer | Technology |
|---|---|
| Orchestration | Kubernetes (k3s), Helm |
| Serving | FastAPI, ONNX Runtime |
| Deployment | Argo Rollouts, NGINX Ingress |
| Retraining Pipeline | Argo Workflows |
| Autoscaling | KEDA |
| Model Registry | MLflow |
| Storage | Postgres, MinIO |
| Monitoring | Prometheus, Grafana, Loki, Alloy |

---

## Design Decisions

The project documents eight architectural decisions as ADRs (Architecture Decision Records),
capturing not just what was built but why — including alternatives considered and tradeoffs accepted.
Notable decisions include:

- [Event-Driven Retraining](https://kmikol.github.io/ml-system/adr/001-event-driven-retraining/) — why retraining is triggered by data signals rather than on a schedule
- [Canary Rollouts](https://kmikol.github.io/ml-system/adr/002-canary-rollouts/) — how traffic splitting and automated analysis gates promotion
- [Model Artifact Controller Abstraction](https://kmikol.github.io/ml-system/adr/007-model-artifact-controller-abstraction/) — the facade pattern for storage decoupling
- [ONNX Model Export](https://kmikol.github.io/ml-system/adr/008-onnx-model-export/) — why models are exported to ONNX for serving rather than using framework-native runtimes

**[Read all ADRs →](https://kmikol.github.io/ml-system/adr/)**

---

## What I Learned

<!-- PLACEHOLDER: 2-3 sentences in your own voice about what building this taught you.
     Good candidates: what surprised you about running ML in Kubernetes, something about
     canary rollouts that wasn't obvious until you implemented it, or a decision you'd
     make differently. This is the section that makes the project memorable. -->
