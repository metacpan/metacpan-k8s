# Velero — Volume Backups

Backs up PVs via filesystem-level backup (Kopia) to Hetzner Object Storage.
Needed because Hetzner CSI doesn't support volume snapshots.

## Setup

1. Create an S3 bucket in Hetzner Cloud Console (Object Storage, fsn1 region)
2. Generate S3 credentials (Security > API Tokens > S3 credentials)
3. Update `values-hz.yaml` with the actual bucket name
4. Create the credentials secret on the cluster:

```bash
kubectl --context f18f55d8-98fb-496f-a209-a91c7f1b43ba/cloudfleet-cli \
  create namespace velero

kubectl --context f18f55d8-98fb-496f-a209-a91c7f1b43ba/cloudfleet-cli \
  -n velero create secret generic velero-s3-credentials \
  --from-literal=cloud="$(cat <<'EOF'
[default]
aws_access_key_id = <YOUR_ACCESS_KEY>
aws_secret_access_key = <YOUR_SECRET_KEY>
EOF
)"
```

5. Apply the ArgoCD application:

```bash
kubectl --context f18f55d8-98fb-496f-a209-a91c7f1b43ba/cloudfleet-cli \
  apply -f platform/velero/hz_application.yaml
```

6. After Velero is running, apply the backup schedule:

```bash
kubectl --context f18f55d8-98fb-496f-a209-a91c7f1b43ba/cloudfleet-cli \
  apply -f platform/velero/schedules/backpan-daily.yaml
```

7. Add this annotation to the backpan-syncer Deployment pod template to
   skip backing up the cache volume (it's recreatable):

```yaml
backup.velero.io/backup-volumes-excludes: backpan-obj-store-cache
```

## Restoring

```bash
velero restore create --from-backup <backup-name>
```
