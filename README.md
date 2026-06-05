# nuvlabs Helm Charts

Helm chart repository for [nuvlabs](https://github.com/nuvlabs) open-source projects,
published to GitHub Pages.

## Add the repository

```bash
helm repo add nuvlabs https://nuvlabs.github.io/helm-charts
helm repo update
```

## Charts

| Chart | Version | App Version | Description |
|-------|---------|-------------|-------------|
| [pixflow](charts/pixflow) | 0.1.0 | latest | Self-hosted image and video processing |

---

## pixflow

**Self-hosted, open-source image and video processing service.**
[Source code →](https://github.com/nuvlabs/pixflow)

### Quick install

```bash
helm install pixflow nuvlabs/pixflow \
  --set config.signingKey=$(openssl rand -hex 32) \
  --set config.signingSalt=$(openssl rand -hex 32)
```

### Install with a pre-existing Secret

```bash
# Create the Secret outside Helm (External Secrets Operator, Vault Agent, etc.)
kubectl create secret generic pixflow-credentials \
  --from-literal=PIXFLOW_KEY=$(openssl rand -hex 32) \
  --from-literal=PIXFLOW_SALT=$(openssl rand -hex 32)

helm install pixflow nuvlabs/pixflow \
  --set existingSecret=pixflow-credentials
```

### Install with local media volume

```bash
helm install pixflow nuvlabs/pixflow \
  --set existingSecret=pixflow-credentials \
  --set persistence.enabled=true \
  --set persistence.existingClaim=my-media-pvc
```

### Enable autoscaling + PDB for production

```bash
helm install pixflow nuvlabs/pixflow \
  --set existingSecret=pixflow-credentials \
  --set autoscaling.enabled=true \
  --set autoscaling.minReplicas=2 \
  --set autoscaling.maxReplicas=8 \
  --set podDisruptionBudget.enabled=true
```

### Upgrade

```bash
helm repo update
helm upgrade pixflow nuvlabs/pixflow
```

### Uninstall

```bash
helm uninstall pixflow
```

> **Note:** Secrets and PVCs created by this chart carry `helm.sh/resource-policy: keep`
> so they are NOT deleted on uninstall. Remove them manually when you no longer need them.

### Full values reference

See [charts/pixflow/values.yaml](charts/pixflow/values.yaml) for every available
option with inline documentation.

---

## Releasing a new chart version

1. Update `version` (and `appVersion` if the Docker image changed) in
   `charts/pixflow/Chart.yaml`.
2. Open a pull request — the lint workflow validates the chart.
3. Merge to `main` — the release workflow packages the chart, creates a GitHub
   Release, and updates `index.yaml` on the `gh-pages` branch automatically.

---

## License

[MIT](https://github.com/nuvlabs/helm-charts/blob/main/LICENSE)
