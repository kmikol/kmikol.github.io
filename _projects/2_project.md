---
layout: page
title: mytorch
description: C++ implementation of PyTorch core functionality from scratch
img: assets/projects/mytorch/mytorch_computation_graph.svg
importance: 2
category: work
giscus_comments: false
---

The fastest way to understand a tool is to build it yourself. mytorch is a from-scratch C++ implementation of the core machinery behind PyTorch — tensors, autograd, layers, and an optimizer — built to develop a ground-level understanding of how modern deep learning frameworks actually work.

**[View on GitHub](https://github.com/kmikol/mytorch)**

---

## What is implemented

The library implements a complete training loop with no external ML dependencies:

**Autograd engine** — a dynamic computation graph that tracks operations on tensors and propagates gradients backward through the network via reverse-mode automatic differentiation. This is the core of the project: every operation registers its backward function at the time of the forward pass, and `backward()` walks the graph to accumulate gradients.

**Layers** — `Conv2d` with configurable kernel size, stride, and padding; `Linear` (fully connected); both with learnable weight and bias tensors that accumulate gradients during backprop.

**Activations and ops** — `ReLU` with mask-gated backward pass; `Reshape` for flattening feature maps before fully connected layers; and a library of additional ops in `src/ops/`.

**Loss** — `CrossEntropy` implemented as fused log-softmax and NLL, which gives a clean closed-form gradient `(p - y) / batch_size` at the logit layer.

**Optimizer** — SGD with a straightforward weight update step and `zero_grad()` to clear accumulated gradients between batches.

**Data pipeline** — MNIST dataset loader with binary file parsing, one-hot encoding, and a `DataLoader` with shuffle and batching.

<div class="row justify-content-sm-center">
    <div class="col-sm-8 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/projects/mytorch/mytorch_computation_graph.svg" title="mytorch computation graph" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Computation graph for a forward and backward pass through the CNN. Purple nodes have learnable parameters that accumulate weight and bias gradients. The backward pass (amber) propagates ∂L/∂W and ∂L/∂b through each layer for the SGD update.
</div>

---

## Architecture

The system trains a small CNN on MNIST end-to-end:

```
Input (1×28×28) → Conv2d 3×3 (8 ch) → ReLU → Reshape → Linear (5408→10) → CrossEntropy
```

The design follows PyTorch's API closely enough that the concepts transfer directly, while the implementation exposes everything that PyTorch abstracts away — memory layout, gradient accumulation, the backward graph construction, and numerical stability in the loss function.

---

## Why C++

Python with NumPy would have been faster to write. C++ was the point. Working at this level forces decisions that Python hides: memory ownership of tensors and gradient buffers, how operator overloading interacts with the computation graph, and where numerical precision actually matters. The build system uses CMake with a Dockerfile for reproducible environments.

---

## What I learned

<!-- PLACEHOLDER: 2-3 sentences in your own voice. Good candidates:
     - Something that surprised you about implementing autograd
     - A numerical issue you hit (e.g. softmax overflow before adding max subtraction)
     - What the implementation taught you about how PyTorch actually behaves
     - What you would extend next (transformer? GPU kernels?) -->
