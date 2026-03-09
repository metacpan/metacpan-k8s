# CloudFleet / Hetzner Platform Setup

Cluster: `cluster-1` (f18f55d8-98fb-496f-a209-a91c7f1b43ba)
Region: `europe-central-1a`
Tier: basic

## Prerequisites

1. Install the CloudFleet CLI: https://cloudfleet.ai/docs/introduction/install-cloudfleet-cli/
2. Authenticate: `cloudfleet auth add-profile`
3. Add kubeconfig: `cloudfleet clusters kubeconfig f18f55d8-98fb-496f-a209-a91c7f1b43ba --profile cloudfleet-cli`

## Install order

1. `kubectl apply -f nodeclass.yaml`
2. `kubectl apply -f nodepool.yaml`
3. `helm install contour bitnami/contour ...` or `kubectl apply -f https://projectcontour.io/quickstart/contour.yaml`
4. `helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set crds.enabled=true`
5. `kubectl apply -f clusterissuer.yaml`
