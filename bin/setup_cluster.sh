#!/bin/bash

echo "You really need to run these manually step by step";
exit(1);

### NOTES

# Manually duplicate `hc` -> `NEW_WORKSPACE` as needed
# FOLDER structure, so far it's only the `sealedsecret.yaml` that will need 
# recreating

## Change based on the cluser
export MCCLUSTER=hz

# Setup the platform features

kubectl apply -k platform/sealedsecrets/${MCCLUSTER}/
kubectl apply -f platform/traefik/redirect-https.yaml
kubectl apply -f platform/kilo/

## After creating mount points at /mnt/cluster_data (see docs/ServersDisksEtc.md)
kubectl apply -f platform/local-path-provisioner/configmap.yaml

### Cert manager: secret and apply

cat ../metacpan-credentials/k8s/secrets/cert-manager.yaml \
| kubeseal -o yaml -n cert-manager > platform/cert-manager/${MCCLUSTER}/sealedsecret.yaml

kubectl apply -k platform/cert-manager/${MCCLUSTER}/

### metacpan-web : secret and apply

cat ../metacpan-conf-private/metacpan-web/secret.yaml \
| kubeseal -o yaml -n apps--web > apps/web/${MCCLUSTER}/sealedsecret.yaml

kubectl apply -k apps/web/${MCCLUSTER}/

### grep-metacpan: apply

kubectl apply -f apps/grep

## Again running the apply 2nd time ok, so just think it's timing
# ➜  metacpan-k8s git:(leo/hetzner_and_notes) ✗ kubectl apply -f apps/grep
# namespace/apps--grep created
# persistentvolumeclaim/gitrepo created
# service/grep created
# Error from server (NotFound): error when creating "apps/grep/configmap.yaml": namespaces "apps--grep" not found
# Error from server (NotFound): error when creating "apps/grep/cronjob.yaml": namespaces "apps--grep" not found
# Error from server (NotFound): error when creating "apps/grep/deployment.yaml": namespaces "apps--grep" not found
# Error from
