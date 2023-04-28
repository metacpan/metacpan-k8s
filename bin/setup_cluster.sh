#!/bin/bash

### RUN as ./bin/setup_cluster.sh
### Think we can run this multiple times

### NOTES

# Manually duplicate `hc` -> `NEW_WORKSPACE` as needed
# FOLDER structure

## Change based on the cluser
export MCCLUSTER=hz
export EXPORT_CMD="kubectl create secret generic"
export EXPORT_CMD_ARGS="--dry-run=client -o yaml"
export KUBESEAL_CMD="kubeseal -o yaml"

# Setup the platform features

kubectl apply -k platform/sealedsecrets/${MCCLUSTER}/
kubectl apply -f platform/traefik/redirect-https.yaml

## FIXME what about kilo ?

### Cert manager: secret and apply

cat ../metacpan-credentials/k8s/secrets/cert-manager.yaml \
| ${EXPORT_CMD} cloudflare-api-token-secret --from-file=api-token=/dev/stdin ${EXPORT_CMD_ARGS} \
| ${KUBESEAL_CMD} --namespace cert-manager > platform/cert-manager/${MCCLUSTER}/sealedsecret.yaml

kubectl apply -k platform/cert-manager/${MCCLUSTER}/

# Ran and got this.. but running again works ok, think just timing
#mutatingwebhookconfiguration.admissionregistration.k8s.io/cert-manager-webhook created
#validatingwebhookconfiguration.admissionregistration.k8s.io/cert-manager-webhook created
#unable to recognize "platform/cert-manager/hz/": no matches for kind "ClusterIssuer" in version "cert-manager.io/v1"
#unable to recognize "platform/cert-manager/hz/": no matches for kind "ClusterIssuer" in version "cert-manager.io/v1"
#unable to recognize "platform/cert-manager/hz/": no matches for kind "ClusterIssuer" in version "cert-manager.io/v1"

### metacpan-web : secret and apply

cat ../metacpan-conf-private/metacpan-web/metacpan_web_local.conf \
| ${EXPORT_CMD} metacpan-web-local --from-file=metacpan_web_local.conf=/dev/stdin ${EXPORT_CMD_ARGS} \
| ${KUBESEAL_CMD} --namespace apps--web > apps/web/${MCCLUSTER}/sealedsecret.yaml

kubectl apply -k apps/web/${MCCLUSTER}/

 server (NotFound): error when creating "apps/grep/ingress.yaml": namespaces "apps--grep" not found

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
