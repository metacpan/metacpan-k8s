# Quick Start

This document gets you up and communicating with the k8s cluster quickly as such
it's light on details.

## Browsing the cluster, looking at logs, accessing the container

The easiest method to access containers running in the cluster is using the k9s
kubernetes client.

1. [Install k9s](https://k9scli.io/topics/install/)
1. Copy k8s configuration from the metacpan-credentials repository
   `k8s/kubeconfig` and copy it to `$HOME/.kube/config`
1. Run `k9s` from the command line
1. Browse the cluster

## Deploying applications

1. [Install kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
1. Copy k8s configuration from the metacpan-credentials repository
   `k8s/kubeconfig` and copy it to `$HOME/.kube/config`. If you did this already
   for the k9s install you do not need to do it again.
1. Use the `kubectl apply -k <directory path>` command to deploy an application
   to a cluster. Use the appropriate directory structure to deploy the
   application to the intended environment.
