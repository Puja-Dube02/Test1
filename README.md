# Helm Charts — devops-e2e-app

A Helm chart for the [devops-e2e-pipeline](https://github.com/Puja-Dube02/devops-e2e-pipeline) task API, with per-environment values files (dev/qa/uat) and optional HPA-based autoscaling — a GitOps-friendly alternative to applying the raw manifests in that repo's `k8s/` directory directly.

## Layout

```
charts/devops-e2e-app/
  Chart.yaml
  values.yaml           # base defaults
  values-dev.yaml        # 1 replica, no autoscaling, small resource footprint
  values-qa.yaml         # 2 replicas, no autoscaling
  values-uat.yaml        # 3 replicas, HorizontalPodAutoscaler enabled (3-6 replicas @ 70% CPU)
  templates/
    deployment.yaml
    service.yaml
    hpa.yaml             # rendered only when .Values.autoscaling.enabled is true
    _helpers.tpl
    NOTES.txt
```

## Installing

```bash
# Requires a pull secret for the private GHCR image the deployment references:
kubectl create namespace devops-e2e
kubectl create secret docker-registry ghcr-pull-secret \
  --docker-server=ghcr.io \
  --docker-username=<your-gh-username> \
  --docker-password=<a-ghcr-read-token> \
  -n devops-e2e

helm install devops-e2e-app charts/devops-e2e-app -f charts/devops-e2e-app/values-dev.yaml -n devops-e2e
```

Swap in `values-qa.yaml` or `values-uat.yaml` for the other environments.

## Verifying locally

```bash
cd charts/devops-e2e-app
helm lint .
helm template test-release .
helm template test-release . -f values-uat.yaml   # shows the HPA resource
```

## CI

`.github/workflows/ci.yml`:

1. `helm lint` and `helm template` against the base values and each environment's values file.
2. Spins up an ephemeral kind cluster, installs the chart with `values-uat.yaml`, waits for the rollout, and smoke-tests `/health` through a port-forward.
