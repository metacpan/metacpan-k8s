# kube-thanos

[Thanos](https://github.com/thanos-io/thanos) is a highly available Prometheus
setup with long-term storage capabilities. This project automates the
deployment and management of these Thanos components using Kubernetes and
jsonnet.

## Makefile Overview

This project's design is to pull and manage the
[kube-thanos](https://github.com/thanos-io/kube-thanos) YAML configurations
using jsonnet from the upstream project. The Makefile provided in this project
helps automate tasks such as initializing dependencies, generating manifests,
cleaning up, and ensure required tools are present.

## Prerequisites

Before using the Makefile, ensure you have the following tools installed:

- `jb` (jsonnet Bundler)
- `jsonnet`
- `gojsontoyaml`

## Makefile Targets

The Makefile includes targets to help manage the project:

### `all`

Runs the `check-tools`, `clean`, and `manifests` targets in sequence. This is
the default target.

### `init`

Initializes the jsonnet vendor packages by running `jb init` and installs the
kube-thanos jsonnet library.

### `manifests`

Generates the kube-thanos YAML files from the specified `settings.jsonnet`
file. It converts the Jsonnet output to YAML and places the files in the `base`
directory. Removal of non-YAML files in the `base` directory, and the
`kustomization` file.

### `clean`

Removes the `base` directory and its contents.

### `upgrade`

Updates the kube-thanos jsonnet library to the latest version.

### `check-tools`

Checks if the installation of required tools (`jb`, `jsonnet`, and
`gojsontoyaml`). If any of the tools are missing, the target will abort with an
error message.

### `help`

Displays a help message with a brief description of each target.

## Usage

To use the Makefile, run the following commands in your terminal:

1. **Initialize the project:**

   ```sh
   make init
   ```

2. **Generate the manifests:**

   ```sh
   make manifests
   ```

3. **Clean up the generated files:**

   ```sh
   make clean
   ```

4. **Upgrade the kube-prometheus library:**

   ```sh
   make upgrade
   ```

5. **Check if required tools are installed:**

   ```sh
   make check-tools
   ```

6. **Display the help message:**

   ```sh
   make help
   ```

By following these steps, you can manage the kube-thanos YAML
configurations efficiently using the provided Makefile.
