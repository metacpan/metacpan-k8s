# MetaCPAN on Kubernetes

Welcome to kubernetes MetaCPAN!

This documents the kubernetes implementation for MetaCPAN. This is a work in
progress document, more details will be added to the document as required.

## Cluster deployment

- We deploy to DigitalOcean (DO)
- We use DO Postgres
- We use DO Volumes shared over [NFS](https://kubernetes-sigs.github.io/nfs-ganesha-server-and-external-provisioner/)

### Platform setup

Need to remember that secrets are signed to the cluster not globally. You can copy the signer from one cluster to another if needed.

```
kubectl apply -k sealdedsecreats/do
kubectl apply -k cert-manager/do
kubectl apply -k ingress-nginx
kubectl apply -k postgres
kubectl apply -k nfs-provisioner/volatile
kubectl apply -k argocd/do
```

(might need `kubectl kustomization --enable-helm | kubectl apply -f` for any helm based ones above )

### App setup

We deploy the `Argo Application` app which then pulls in the rest of the setup
```
kubectl apply -k web/argo
kubectl apply -k grep/argo
```

You may need to login to https://argocd.do.metacpan.org/ to then perform the
`sync` which will then match the deployed setup to the manifest.
