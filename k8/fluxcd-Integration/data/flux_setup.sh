#!/bin/bash

#Install Prometheus Stack
flux create source git flux-monitoring \
  --interval=30m \
  --url=https://github.com/fluxcd/flux2 \
  --branch=main

flux create kustomization kube-prometheus-stack \
  --interval=1h \
  --prune \
  --source=flux-monitoring \
  --path="./manifests/monitoring/kube-prometheus-stack" \
  --health-check-timeout=5m \
  --wait