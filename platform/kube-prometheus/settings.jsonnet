local kp =
  (import 'kube-prometheus/main.libsonnet') +
  // Uncomment the following imports to enable its patches
  // (import 'kube-prometheus/addons/anti-affinity.libsonnet') +
  // (import 'kube-prometheus/addons/managed-cluster.libsonnet') +
  // (import 'kube-prometheus/addons/node-ports.libsonnet') +
  // (import 'kube-prometheus/addons/static-etcd.libsonnet') +
  // (import 'kube-prometheus/addons/custom-metrics.libsonnet') +
  // (import 'kube-prometheus/addons/external-metrics.libsonnet') +
  // (import 'kube-prometheus/addons/pyrra.libsonnet') +
  (import 'kube-prometheus/addons/strip-limits.libsonnet') +
  (import 'kube-prometheus/addons/all-namespaces.libsonnet')
  {
    values+:: {
      common+: {
        namespace: 'monitoring',
      },
      prometheus+: {
        thanos: {
          version: '0.36.1',
          image: 'quay.io/thanos/thanos:v0.36.1',
          objectStorageConfig: {
            key: 'thanos.yaml',  // How the file inside the secret is called
            name: 'thanos-objectstorage',  // This is the name of your Kubernetes secret with the config
          },
        },
      },
      grafana+: {
        config+: {
          sections: {
            server: {
              root_url: 'https://grafana.example.com',
              enable_gzip: true,
            },
            auth: {
              oauth_auto_login: true,
              disable_login_form: true,
            },
            'auth.anonymous': {
              enabled: false,
            },
            'auth.basic': {
              enabled: false,
            },
            'auth.github': {
              enabled: true,
              allow_sign_up: true,
              client_id: 'GITHUB_CLIENT_ID',
              client_secret: 'GITHUB_CLIENT_SECRET',
              scopes: 'user:email,read:org',
              auth_url: 'https://github.com/login/oauth/authorize',
              token_url: 'https://github.com/login/oauth/access_token',
              api_url: 'https://api.github.com/user',
              allowed_organizations: ['GITHUB_ORGANIZATION'],
              role_attribute_path: "contains(groups[*], '@metacpan/admin') && 'Editor' || 'None'",
            },
          },
        },
        datasources: [
          {
            name: 'thanos',
            type: 'prometheus',
            access: 'proxy',
            orgId: 1,
            url: 'http://thanos-query.thanos.svc:9090',
            version: 1,
            editable: false,
          },
          {
            name: 'prometheus',
            type: 'prometheus',
            access: 'proxy',
            orgId: 1,
            url: 'http://prometheus-k8s.monitoring.svc:9090',
            version: 1,
            editable: false,
          },
          {
            name: 'loki',
            type: 'loki',
            access: 'proxy',
            orgId: 1,
            url: 'http://loki-read.loki.svc:3100',
            version: 1,
            editable: false,
          },
        ],
      },
    },
    prometheus+: {
      prometheus+: {
        spec+: {
          retention: '1d',
          storage: {
            volumeClaimTemplate: {
              apiVersion: 'v1',
              kind: 'PersistentVolumeClaim',
              spec: {
                accessModes: ['ReadWriteOnce'],
                resources: {
                  requests: {
                    storage: '10Gi',
                  },
                },
                storageClassName: 'do-block-storage',
              },
            },
          },
        },
      },
      namespaces: [],
      networkPolicy+: {
        spec+: {
          ingress+: [
            {
              from: [{
                namespaceSelector: {
                  matchLabels: {
                    'kubernetes.io/metadata.name': 'kube-system',
                  },
                },
              }],
              ports: [{
                port: 9090,
                protocol: 'TCP',
              }],
            },
            {
              from: [{
                namespaceSelector: {
                  matchLabels: {
                    'kubernetes.io/metadata.name': 'thanos',
                  },
                },
              }],
              ports: [{
                port: 10901,
                protocol: 'TCP',
              }],
            },
          ],
        },
      },
    },
    grafana+: {
      networkPolicy+: {
        spec+: {
          ingress+: [{
            from: [{
              namespaceSelector: {
                matchLabels: {
                  'kubernetes.io/metadata.name': 'ingress-nginx',
                },
              },
            }],
            ports: [{
              port: 3000,
              protocol: 'TCP',
            }],
          }],
        },
      },
    },
  };

{ 'setup/0namespace-namespace': kp.kubePrometheus.namespace } +
{ ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{
  ['setup/prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor' && name != 'prometheusRule'), std.objectFields(kp.prometheusOperator))
} +
// { 'setup/pyrra-slo-CustomResourceDefinition': kp.pyrra.crd } +
// serviceMonitor and prometheusRule are separated so that they can be created after the CRDs are ready
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ 'prometheus-operator-prometheusRule': kp.prometheusOperator.prometheusRule } +
{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['blackbox-exporter-' + name]: kp.blackboxExporter[name] for name in std.objectFields(kp.blackboxExporter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) } +
// { ['pyrra-' + name]: kp.pyrra[name] for name in std.objectFields(kp.pyrra) if name != 'crd' } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['kubernetes-' + name]: kp.kubernetesControlPlane[name] for name in std.objectFields(kp.kubernetesControlPlane) }
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) }
