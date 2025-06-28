# Secrets

## Creating a secret which can be committed into public repo

```
kubectl create secret generic <secret-name> --from-file=<key>=<path-to-file> -o yaml --dry-run=client | kubeseal --format yaml > sealed-secret.yaml
```

With namespace added example:

```
kubectl create secret generic docker-local-yaml \
  --from-file=./docker_local.yaml -o yaml --dry-run=client \
  | \
  kubeseal --format yaml -n apps--testsmoke > sealed-secret.yaml
```

Working example....
```
kubectl create secret generic \
  metacpan-server-local \
  --from-file=../metacpan-conf-private/metacpan-api/metacpan_server_local.conf \
  -n apps--mc-api -o yaml --dry-run=client \
  | kubeseal --format yaml \
  -n apps--mc-api > apps/api/environments/prod/prod_sealedsecret.yaml
```