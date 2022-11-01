# Repository Directory Structure

## apps

MetaCPAN application manifests are contained in the `apps` directory. Each
application has its own subdirectory, within each application directory is a
`base/` directory to contain the application manifests. Each environment that
the application is deployed to is contained in a separate directory at the same
level as the `base/` directory. For example:

```ascii
apps/web
├── base
├── hc
└── stage
```

- `base/` the MetaCPAN web application manifests
- `hc/` kustomization manifests to apply to web manifests for the `hc`
  production environment
- `stage/` kustomization manifests to apply to web manifests for the `stage` environment

kustomization manifests are patch manifests that alter the `base/` manifests for
components like URLs, secrets (passwords), and configuration.

## db

Database applications are shared amongst all applications within the cluster.
Subdirectories within the db directory contain the manifests for these applcations.
The directory structure reflects the namespaces used for the
applications. For example, db/mongodb is namespace db--mongodb.

## docs

Directory containing the kubernetes environment documentation (like this document).

## platform

This directory contains the manifests (deployment and kustomization) for running
the kubernetes environment.
