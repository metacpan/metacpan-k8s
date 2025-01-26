.DEFAULT_GOAL := help

SHELL := /bin/bash
PATH := $(PWD)/tmp/bin:${PATH}
JSONNET_FILE := settings.jsonnet

.PHONY: all clean manifests check-tools

all: check-tools clean manifests

.PHONY: init
	jb init
	jb install github.com/thanos-io/kube-thanos/jsonnet/kube-thanos@main

.PHONY: manifests
manifests:
	mkdir -p base
	jsonnet -J vendor -m base $(JSONNET_FILE) | xargs -I{} sh -c 'cat {} | gojsontoyaml > {}.yaml' -- {}
	find base -type f ! -name '*.yaml' -delete

.PHONY: clean
clean:
	rm -rf base

.PHONY: upgrade
upgrade:
	jb update github.com/thanos-io/kube-thanos/jsonnet/kube-thanos@main

.PHONY: check-tools
check-tools:
	@command -v jb >/dev/null 2>&1 || { echo >&2 "jb is not installed. Aborting."; exit 1; }
	@command -v jsonnet >/dev/null 2>&1 || { echo >&2 "jsonnet is not installed. Aborting."; exit 1; }
	@command -v gojsontoyaml >/dev/null 2>&1 || { echo >&2 "gojsontoyaml is not installed. Aborting."; exit 1; }

.PHONY: help
help:
	@echo "Makefile for pulling kube-thanos YAML"
	@echo ""
	@echo "Targets:"
	@echo "  manifests   : extract kube-thanos YAML from jssonet with specified settings.jsonnet"
	@echo "  upgrade     : update kube-thanos from jssonet with specified settings.jsonnet"
	@echo "  init        : initialize jsonnet vendor packages"
	@echo "  check-tools : ensure required tools are installed"
	@echo "  help        : Display this help message"
