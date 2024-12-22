# Loki

The [Loki](https://github.com/grafana/loki) project is a log aggregation system
designed to store and query logs from multiple sources. It's part of the
[Grafana](https://github.com/grafana/grafana) ecosystem and optimizing for
cost-effective and efficient log storage. Loki's design is to work seamlessly
with Grafana for visualization and Prometheus for metrics.

## Makefile Overview

This Makefile manages the Loki Helm chart, which simplifies the deployment and
management of Loki in a Kubernetes environment. The Makefile provides targets
to automate common tasks such as pulling the latest Loki YAML configuration,
upgrading Loki, and ensure required tools are present.

## Prerequisites

Before using the Makefile, ensure you have the following tools installed:

- `helm`

### Makefile Targets

- **all**: This is the default target that runs `check-tools`, `clean`, and
`manifests` targets in sequence.
- **init**: Adds the Grafana Helm repository and updates the Helm repository
index.
- **manifests**: Removes the previous Loki YAML file and pulls the latest Loki
YAML configuration from the Helm chart using the specified `values.yaml` file.
- **upgrade**: Removes the previous Loki YAML file and upgrades the Loki
deployment using the latest configuration from the Helm chart.
- **check-tools**: Ensures that the required tools (e.g., Helm) are available
on the system.
- **help**: Displays usage information for the Makefile targets.

### Usage

1. **Initialize Helm Repository**

   Before using the Makefile, you need to initialize the Helm repository:

   ```sh
   make init
   ```

2. **Generate Loki Manifests**

   To generate the Loki YAML configuration file, run:

   ```sh
   make manifests
   ```

   This will remove the previous `loki.yaml` file and pull the latest
   configuration from the Helm chart.

3. **Upgrade Loki**

   To upgrade the Loki deployment with the latest configuration, run:

   ```sh
   make upgrade
   ```

   This will remove the previous `loki.yaml` file and upgrade the Loki deployment.

4. **Check Required Tools**

   Ensure the installation of required tools by running:

   ```sh
   make check-tools
   ```

   This will check that Helm is available on your system.

5. **Display Help**

   To display the help message with information about the Makefile targets, run:

   ```sh
   make help
   ```

### Default Variables

- **DEFAULT_VERSION**: The default version of Loki to use (e.g., `6.22.0`).
- **LOKI_VERSION**: The version of Loki to use, which can be overridden by
setting this variable.
- **LOKI_OUTPUT_YAML**: The output file for the Loki YAML configuration
(default: `vendor/loki.yaml`).
- **VALUES_FILE**: The path to the `values.yaml` file used for Helm configuration.

### Example

To generate the Loki manifests using a specific version and values file, you
can run:

```sh
make LOKI_VERSION=2.4.1 VALUES_FILE=/path/to/your/values.yaml manifests
```

This will pull the specified version of Loki and use the provided `values.yaml`
file for configuration.
