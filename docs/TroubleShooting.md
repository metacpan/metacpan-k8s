# Troubleshooting

## Useful commands:

Delete all evicted pods (make sure to update BOTH namespaces):

```
kubectl get pod -n apps--testsmoke| grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n apps--testsmoke`
```