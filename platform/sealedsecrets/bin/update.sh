#!/usr/bin/env bash

VERSION="v0.20.5"
# VERSION="v0.16.0"
URL="https://github.com/bitnami-labs/sealed-secrets/releases/download/$VERSION/controller.yaml"

wget -O base/deploy.yaml $URL
