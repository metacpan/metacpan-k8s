# Manually Updating Application Images

## Overview

GitHub Action workflows create and push docker images to Docker Hub when PRs
merges to their main branch. The images have tags with the git commit sha for
the merge.

You can view all available docker images on docker hub:
[https://hub.docker.com/r/metacpan/metacpan-web/tags](https://hub.docker.com/r/metacpan/metacpan-web/tags)

## What is running?

The kubernetes manifests maintain what image is running as part of the
deployment. We use an application called kustomize that patches the base
manifests, to make changes. In the manifest repo (this one), you can view the
contents of the kustomization.yaml for the application in each environment.

Using the web application as an example:

```console
$ cat apps/web/environments/prod/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- ../../base/
images:
- name: metacpan/metacpan-web
  newTag: dfae65b61899cfe8e9e6a8d7d39eb437849e6629
```

Shows that the web application in the production environment (we only have one
but can support more!), we're using the `metacpan/metacpan-web` image with the
tag (at the time of this writing) `dfae65b61899cfe8e9e6a8d7d39eb437849e6629`.

## Updating to a newer image

[Kustomize](https://kustomize.io) can automatically update the image in the
appropriate `kustomization.yaml`. This update must occur in the directory for
the environment. Using the web application production environment again as the
example:

Visit
[https://hub.docker.com/r/metacpan/metacpan-web/tags](https://hub.docker.com/r/metacpan/metacpan-web/tags)
and find the latest sha tagged image. The images are listed in order they were
pushed, usually the first image is the `latest` tag, and the second image is
the sha tag for the same image.

Within an up to date metacpan-k8s repository, on a new branch:

```shell
cd apps/web/environments/prod
kustomize edit set image "metacpan/metacpan-web:latest" "metacpan/metacpan-web:dfae65b61899cfe8e9e6a8d7d39eb437849e6629"
git add -u
git commit -m "Update to latest metacpan-web"
```

Where `dfae65b61899cfe8e9e6a8d7d39eb437849e6629` represents
the latest sha image.

Push the branch to GitHub and open a PR. When approved and merged, the
application will automatically deploy. Monitor the deployment status in Argo CD
by visiting [https://argocd.hz.metacpan.org](https://argocd.hz.metacpan.org)
