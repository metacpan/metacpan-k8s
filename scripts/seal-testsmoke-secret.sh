#!/usr/bin/env bash
set -euo pipefail

# Seals the docker_local.yaml config secret for test-smoke on Hz.
#
# Prerequisites:
#   - kubectl access to the hz cluster
#   - kubeseal installed
#   - metacpan-conf-private checked out beside this repo
#
# Usage:
#   ./scripts/seal-testsmoke-secret.sh <hz-context>
#
# Example:
#   ./scripts/seal-testsmoke-secret.sh f18f55d8-98fb-496f-a209-a91c7f1b43ba/cloudfleet-cli

HZ_CONTEXT="${1:?Usage: $0 <hz-context>}"

CONF_PRIVATE="$(cd "$(dirname "$0")/../../metacpan-conf-private" && pwd)"
SOURCE="$CONF_PRIVATE/test-smoke/docker_local.yaml"
OUTFILE="$(cd "$(dirname "$0")/.." && pwd)/apps/test-smoke/environments/hz/docker-local-sealedsecret.yaml"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

echo "Creating secret manifest..."
kubectl create secret generic docker-local-yaml \
  --from-file=docker_local.yaml="$SOURCE" \
  --namespace=apps--testsmoke \
  --dry-run=client -o yaml > "$WORKDIR/secret.yaml"

echo "Sealing secret against hz cluster ($HZ_CONTEXT)..."
kubeseal --controller-namespace kube-system \
  --context "$HZ_CONTEXT" \
  --format yaml \
  < "$WORKDIR/secret.yaml" \
  > "$OUTFILE"

echo "Sealed secret written to: $OUTFILE"
