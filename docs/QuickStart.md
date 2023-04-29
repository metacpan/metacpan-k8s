# Quick Start

This document gets you up and communicating with the k8s cluster quickly as such
it's light on details.

## Access

Copy the relevant cluster config e.g [hz-mc.kubeconfig](https://github.com/metacpan/metacpan-credentials/blob/master/k8s/hz-mc.kubeconfig) or [https://github.com/metacpan/metacpan-credentials/blob/master/k8s/hc-mc.kubeconfig](hc-mc.kubeconfig) to `$HOME/.kube/config` (note those are in a private repo for mc admins only).

```sh
mkdir $HOME/.kube
cd $HOME/.kube
cp ~/git/metacpan-credentials/k8s/hz-mc.kubeconfig ./config
```

## Browsing the cluster, looking at logs, accessing the container
1. [Install k9s](https://k9scli.io/topics/install/)
2. Run `k9s` from the command line
3. Browse the cluster

## Deploying applications

1. [Install kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
2. Use the `kubectl apply -k <directory path>` ( e.g. `kubectl apply -k apps/web/hz` ) command to deploy an application
   to a cluster. Use the appropriate directory structure to deploy the
   application to the intended environment.
