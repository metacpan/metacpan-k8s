#!/usr/bin/env bash

URL="https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"

wget -O base/deploy.yaml $URL
