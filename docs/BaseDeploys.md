# Basic things which need deploying / secrets making

# Manually duplicate `hc` -> `NEW_WORKSPACE` as needed
# FOLDER structure, so far it's only the `sealedsecret.yaml` that will need 
# recreating

## Change based on the cluser
export MCCLUSTER=hz

# Setup the platform features

kubectl apply -k platform/sealedsecrets/${MCCLUSTER}/
kubectl apply -f platform/traefik/redirect-https.yaml
kubectl apply -f platform/kilo/

### Cert manager: secret and apply

cat ../metacpan-credentials/k8s/secrets/cert-manager.yaml \
| kubeseal -o yaml -n cert-manager > platform/cert-manager/${MCCLUSTER}/sealedsecret.yaml

kubectl apply -k platform/cert-manager/${MCCLUSTER}/

## NOTE: Only after creating mount points at /mnt/cluster_data (see docs/ServersDisksEtc.md)
kubectl apply -f platform/local-path-provisioner/configmap.yaml

# Now individual applications

### metacpan-web : secret and apply

cat ../metacpan-conf-private/metacpan-web/secret.yaml \
| kubeseal -o yaml -n apps--web > apps/web/${MCCLUSTER}/sealedsecret.yaml

kubectl apply -k apps/web/${MCCLUSTER}/

### grep-metacpan: apply

kubectl apply -k apps/grep/${MCCLUSTER}/
