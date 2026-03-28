# Cloudfleet Migration Notes

For cluster setup docs, see `platform/cloudfleet/README.md`.

## Migration status

| App | Hz deployed | Hz healthy | Production-ready | Notes |
|-----|-------------|------------|------------------|-------|
| api-v0-shim | yes | yes | — | |
| backpan-syncer | yes | yes | blocked | DO is primary until initial sync completes |
| grep | yes | progressing | — | |
| sco-redirect | yes | yes | — | |
| test-smoke | yes | progressing | — | |
| web | yes | yes | — | |
| mc-api | scaffolded | — | blocked | app itself is broken (CrashLoopBackOff on DO too), WIP |
| mc-api (staging) | no | — | — | not yet ported |

## Cluster details

- DO cluster: `do-mc-cluster` in `fra1` (context: `do-fra1-do-mc-cluster`)
- Hz cluster context: `f18f55d8-98fb-496f-a209-a91c7f1b43ba/cloudfleet-cli`

## backpan-syncer: DO → Hetzner

### What was done

Created hz environment for backpan-syncer:

- `apps/backpan-syncer/environments/hz/kustomization.yaml` — patches PVCs to use hcloud-volumes
- `apps/backpan-syncer/environments/hz/namespace.yaml`
- `apps/backpan-syncer/environments/hz/rclone-conf-sealedsecret.yaml` — sealed rclone secret
- `apps/backpan-syncer/argo/hz_application.yaml` — ArgoCD app targeting `cloudfleet` branch
- Updated `apps/backpan-syncer/argo/kustomization.yaml` to include hz application

### Storage class mapping

| PVC | DO | Hz | Size |
|-----|----|----|------|
| backpan | do-block-storage | hcloud-volumes | 165Gi |
| backpan-obj-store-cache | do-block-storage | hcloud-volumes | 115Gi |

### rclone secret — done (sealed)

Sealed secret is deployed and managed by the sealed-secrets controller. The secret is in git (encrypted) and survives namespace wipes.

To re-seal if needed (e.g. credentials change):

```bash
./scripts/seal-rclone-secret-for-hz.sh do-fra1-do-mc-cluster f18f55d8-98fb-496f-a209-a91c7f1b43ba/cloudfleet-cli
```

### Data flow

1. **rrr-client** (RR watcher) mirrors recent CPAN uploads **→ `/mnt/backpan`** using RECENT files published by PAUSE. This volume is the "true source".
2. `/mnt/backpan` syncs **→ Fastly Object Storage** via rclone FUSE mount at `/mnt/backpan-obj-store`
3. The cache volume (`backpan-obj-store-cache`) speeds up the rsync to Fastly — can be recreated if lost

### Backup — done (B2 rclone)

On DO, volume snapshots of `/mnt/backpan` served as backups. Hetzner doesn't support volume snapshots ([hetznercloud/csi-driver#849](https://github.com/hetznercloud/csi-driver/issues/849)).

A monthly restic CronJob backs up `/mnt/backpan` to Backblaze B2 (`mc-backpan-restic` bucket, `eu-central-003`). Restic preserves filesystem metadata including symlinks. The PVC is mounted read-only; a pod affinity rule ensures the job runs on the same node as the backpan-syncer pod (required for hcloud-volumes RWO).

- Monthly backup on the 1st at 3 AM UTC, 3 monthly snapshots retained
- B2 and restic credentials stored in `restic-b2-backup` sealed secret
- BackPAN includes files deleted from CPAN — the volume is the only complete source, so B2 is the DR copy
- Restore: `restic -r s3:https://s3.eu-central-003.backblazeb2.com/mc-backpan-restic restore latest --target /mnt/backpan`

### Other considerations

- The backpan-syncer container runs **privileged** (needs FUSE for rclone) — confirmed working on Hz
- Deployment uses `Recreate` strategy (single replica, avoids dual volume access)
- DO remains the primary until the Hz volume has completed its initial sync

## mc-api: DO → Hetzner

### What was done

Hz environment scaffolded but not activated (ArgoCD app not applied to cluster):

- `apps/api/environments/hz/kustomization.yaml` — strips secret volumes/env, scales api-search to 0
- `apps/api/environments/hz/namespace.yaml`
- `apps/api/environments/hz/ingress.yaml` — contour ingress, `api.hz.metacpan.org`
- `apps/api/argo/hz_application.yaml`

### Blocking

The mc-api app itself is not working — both `api` and `api-search` pods are in CrashLoopBackOff on DO. This is a WIP and needs to be fixed before Hz deployment makes sense.

## Sealed secrets — done

Sealed-secrets controller installed on Hz via Helm in `kube-system`. The prior CRD conflict was already cleaned up.

```bash
helm install sealed-secrets sealed-secrets/sealed-secrets \
  --namespace kube-system \
  --set-string fullnameOverride=sealed-secrets-controller
```

## B2 backup — done

Monthly rclone CronJob syncing `/mnt/backpan` → Backblaze B2 (`mc-backpan` bucket).

- CronJob: `apps/backpan-syncer/environments/hz/b2-backup-cronjob.yaml`
- Credentials: `restic-b2-backup` sealed secret (use `scripts/create-b2-backup-secret.sh` to generate)
- Velero has been removed — delete the `hz--velero` ArgoCD application from the cluster if still present

## Scripts

- `scripts/install-kubectl.sh` — installs kubectl on Debian/Ubuntu (accepts optional version arg, defaults to v1.32)
- `scripts/seal-rclone-secret-for-hz.sh` — extracts rclone secret from DO and seals it for Hz
- `scripts/create-b2-backup-secret.sh` — creates and seals the B2 backup rclone secret for Hz

## DO access

- DO API tokens: https://cloud.digitalocean.com/account/api/tokens
- `doctl auth init --context do-temp` to add a temporary token
- `doctl auth remove --context do-temp` to clean up after
- Kubeconfig save requires a **full access** token (custom scoped with Kubernetes write was not sufficient)
