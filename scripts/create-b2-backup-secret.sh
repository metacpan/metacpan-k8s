#!/usr/bin/env bash
set -euo pipefail

# Creates and seals the restic credentials secret for the monthly B2 backup CronJob.
#
# Prerequisites:
#   - kubectl access to the hz cluster
#   - kubeseal installed (https://github.com/bitnami-labs/sealed-secrets#kubeseal)
#
# Usage:
#   ./scripts/create-b2-backup-secret.sh <hz-context>
#
# Example:
#   ./scripts/create-b2-backup-secret.sh f18f55d8-98fb-496f-a209-a91c7f1b43ba/cloudfleet-cli

HZ_CONTEXT="${1:?Usage: $0 <hz-context>}"

read -rp "B2 Application Key ID: " b2_account_id
read -rsp "B2 Application Key: " b2_account_key
echo
read -rsp "Restic repository password (keep this safe — needed for restore): " restic_password
echo

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "Creating secret manifest..."
kubectl create secret generic restic-b2-backup \
  --from-literal=b2-account-id="${b2_account_id}" \
  --from-literal=b2-account-key="${b2_account_key}" \
  --from-literal=restic-password="${restic_password}" \
  --namespace=apps--backpan-syncer \
  --dry-run=client -o yaml > "$TMPDIR/secret.yaml"

OUTFILE="$(cd "$(dirname "$0")/.." && pwd)/apps/backpan-syncer/environments/hz/restic-b2-backup-sealedsecret.yaml"

echo "Sealing secret against hz cluster ($HZ_CONTEXT)..."
kubeseal --controller-namespace kube-system \
  --context "$HZ_CONTEXT" \
  --format yaml \
  < "$TMPDIR/secret.yaml" \
  > "$OUTFILE"

echo "Sealed secret written to: $OUTFILE"
echo "IMPORTANT: store the restic password somewhere safe (e.g. team password manager) — it is required to restore from backup"
