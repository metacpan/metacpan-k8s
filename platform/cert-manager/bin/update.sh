#!/usr/bin/env bash

VERSION="v1.13.3"
URL="https://github.com/jetstack/cert-manager/releases/download/$VERSION/cert-manager.yaml"

wget -O base/deploy.yaml $URL
