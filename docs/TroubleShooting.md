# Troubleshooting

## Useful commands:

Delete all evicted pods (make sure to update BOTH namespaces):

```
kubectl get pod -n apps--testsmoke| grep Evicted | awk '{print $1}' | xargs kubectl delete pod -n apps--testsmoke`
```

Delete all Completed pods 
```
kubectl delete pod -n apps--testsmoke $(kubectl get pods -n apps--testsmoke | grep Completed | awk '{print $1}')
```

## List all resources setup for a namespace

```
kubectl api-resources -n apps--testsmoke
```