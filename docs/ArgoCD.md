# Argo CD

ArgoCD automatically deploys applications based on a git repo. When ArgoCD
detects a change in the repo ArgoCD applies the manifests to the cluster,
updating the state described within.

## Applications

Argo CD includes a definition of for what an application is:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: apps--web
  namespace: argocd
spec:
  project: apps--web
  source:
    repoURL: https://github.com/metacpan/metacpan-k8s
    targetRevision: HEAD
    path: apps/web/environments/prod
  destination:
    server: https://kubernetes.default.svc
    namespace: apps--web
```

The configuration defines the production version of the MetaCPAN web application.
The repository monitored is the `metacpan-k8s` repository. When a developer pushes
application changes to a release branch Tekton CI will create a commit that
updates the image tag in the metacpan-k8s repository. This change will trigger the
deployment of the affected application.

## Argo CD UI

Argo CD provides a web based UI to monitor application status, and view the
kubernetes resources that the application utilizes.

Authentication uses the Dex application which provides access to
various authentication mechanisms, including OAUTH2, that allows GitHub authentication.
The Argo CD ConfigMap (`argocd-cm`) manages the Dex configuration as part of the
`data` attribute as such:

```yaml
data:
  dex.config: |
    connectors:
      - type: github
        id: github
        name: GitHub
        config:
          clientID: $argocd-github-secret:clientId
          clientSecret: $argocd-github-secret:clientSecret
          orgs:
          - name: metacpan
            teams:
              - ADMINS
          loadAllGroups: false
```

The above example uses GitHub authentication for the `metacpan` group, and
specifically allows access to the `ADMINS` team. The GitHub Web UI manages
membership to the organization and the team.

GitHub authentication uses tokens stored in the `argocd-github-secret`.

### Secret Management

A kubernetes SealedSecret contains the GitHub Token and client ID.
Before sealing the kubernetes Secret is in the form:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: argocd-github-secret
  namespace: argocd
  labels:
    app.kubernetes.io/name: argocd-secret
    app.kubernetes.io/part-of: argocd
data:
  clientId: <base64 encoded GitHub Client ID>
  clientSecret: <base64 encoded GitHub Access Token>
type: Opaque
```

Create a SealedSecret from the kubernetes Secret with the following command:

```bash
kubeseal -o yaml \
    < ../metacpan-credentials/k8s/secrets/argocd_github_hz.yaml \
    > platform/argocd/hz/github_auth_secret.yaml
```
