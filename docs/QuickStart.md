# Quick Start

This document gets you up and communicating with the k8s cluster quickly, as such it's light on details.

## Access

Download the cluster config file from https://cloud.digitalocean.com/kubernetes/clusters/490ad197-959c-4024-945b-547fc99415ef?i=5289ac to `$HOME/.kube/config` 

## Browsing the cluster, looking at logs, accessing the container
Use: https://argocd.do.metacpan.org/ with your github account

Or:

1. [Install k9s](https://k9scli.io/topics/install/)
2. Run `k9s` from the command line
3. Browse the cluster

## Deploying applications

1. [Install kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
2. Use the `kubectl apply -k <directory path>` ( e.g. `kubectl apply -k apps/web/argo` ) command to deploy an application
   to a cluster. Use the appropriate directory structure to deploy the
   application to the intended environment.

## Connecting to containers

1. Run `k9s`
2. Find container
3. Click `s` to get a shell!

## Restarting (to upgrade to latest image)

Connect, as above

NOTE: you can use `killall5` which will kill off the container and then if `imagePullPolicy: Always` is set it will pull the image and start a new container from there.
