---
layout: page
title: Personal RAG System
description: Architecture-first self-hosted RAG system being packaged for Kubernetes deployment
importance: 2
category: work
github: https://github.com/kmikol/rag
giscus_comments: false
---

A personal Retrieval-Augmented Generation system designed around self-hosting, local models,
and trustworthy answers over a private knowledge base.

**[View on GitHub](https://github.com/kmikol/rag)**

---

## Context

The project started as a local personal RAG application: ingest a private corpus, retrieve relevant
context, and answer questions with citations. The first local deployment path worked as a development
target, but it did not feel like the right end state. Running it on AWS or another managed cloud
provider would make the deployment cleaner, but would also introduce ongoing cost for a personal
system that is meant to run privately.

That changed the shape of the work. The RAG system is now being designed as an application that will
deploy onto a self-hosted Kubernetes [cluster](/projects/3_cluster/), with GitOps-style deployment and explicit operational
boundaries. The application implementation is deliberately behind the architecture and deployment
work for now: the platform is being built first so the system has a realistic target environment.

## System Direction

The intended system is single-user and self-hosted. Watch directories are the authoritative corpus
source, PostgreSQL stores document metadata and ingestion state, Qdrant provides vector retrieval,
and a dedicated embedding service keeps model-serving concerns separate from the API and ingestion
worker.

The retrieval design favors trust over coverage. Dense retrieval alone is not enough for personal
documents, where exact filenames, acronyms, dates, and quoted phrases often matter. The planned
retrieval path combines dense and sparse search, carries source metadata through the pipeline, and
uses answerability gates before generation. If retrieved context is weak, the system should refuse
to answer instead of inventing one.

## Architecture Principles

**Private by default** — The system is meant to run on owned hardware and be reachable through a
private network, not as a public web service.

**Deployment-aware design** — Services are split along operational boundaries: API, ingestion,
embedding, metadata storage, and vector storage. That separation matters because the target runtime
is Kubernetes, not a single local script.

**Cited, conservative answers** — Generated responses should be grounded in retrieved chunks with
document and chunk provenance. A refusal is preferable to a confident answer based on weak evidence.

**Movable model providers** — Local model serving is the default direction, but model and embedding
providers are configuration concerns rather than hardcoded assumptions.

## Current Status

RAG is currently in an architecture-first phase while the Kubernetes deployment path is being built.
The repository contains the service boundaries, ADRs, documentation structure, environment contract,
and implementation plan. The next major step is packaging the application for the homelab [cluster](/projects/3_cluster/):
container images, Helm chart, Argo CD deployment, secret handling, and smoke tests.

<!-- Future visual slot:
     Add a system diagram showing API service, ingestion worker, embedding service,
     PostgreSQL metadata store, Qdrant vector store, corpus watch directories, local model host,
     and Kubernetes deployment boundary. -->

---

## Technology Stack

| Layer | Technology |
|---|---|
| API & Workers | Python services |
| Retrieval | Qdrant, PostgreSQL full-text search |
| Metadata | PostgreSQL |
| Model Runtime | Local model providers, Ollama/Gemma direction |
| Packaging | Docker, Helm |
| Deployment Target | Self-hosted Kubernetes, Argo CD |
| Documentation | MkDocs Material, ADRs |

---

## Design Decisions

The repository is organized around explicit Architecture Decision Records. The most important
decisions define the system as a single-user, self-hosted tool; prefer no answer over a wrong answer;
split the API, ingestion, and embedding responsibilities; and use hybrid retrieval with citations
and configurable answerability gates.

Notable decisions include:

- [Problem Definition and Scope](https://github.com/kmikol/rag/blob/main/docs/adr/000-problem-definition-and-scope.md) — why the system is private, single-user, and local-model oriented
- [Service Boundaries](https://github.com/kmikol/rag/blob/main/docs/adr/003-service-boundaries.md) — why API and ingestion work are split from the start
- [Embedding Service](https://github.com/kmikol/rag/blob/main/docs/adr/004-embedding-service.md) — how embedding work is isolated from retrieval and ingestion
- [Retrieval and Answerability](https://github.com/kmikol/rag/blob/main/docs/adr/007-retrieval-and-answerability.md) — why hybrid retrieval, citations, and refusal gates are first-class behavior

**[View ADRs on GitHub](https://github.com/kmikol/rag/blob/main/docs/adr/index.md)**
