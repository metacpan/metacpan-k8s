
# Digital Ocean Setup

[Best practices](https://docs.digitalocean.com/developer-center/digitalocean-kubernetes-infrastructure-best-practices/)

## Network setup

```mermaid
graph TD
    Fastly --> DOCluster
    subgraph DOCluster
        DO_Loadbalancer --> Nginx_LB
        Nginx_LB --> Node1
        Nginx_LB --> Node2
        Nginx_LB --> Node3
    end
    subgraph Node1
        Node1_Service1[Node 1 Services]
    end
    subgraph Node2
        Node2_Service1[Node 2 Services]
    end
    subgraph Node3
        Node3_Service1[Node 3 Services]
    end
```
We run 3 Nginx Ingress Load balancers, and will eventually setup so one per node, but they will load balance across all 3 nodes. 

## Database

- [Database Operator docs](https://docs.digitalocean.com/products/kubernetes/how-to/use-operator/)
- [Our deployment manifests](../platform/postgres/)

## Disk volumes

- [Volume Docs](https://docs.digitalocean.com/products/kubernetes/how-to/add-volumes/)
- [Sharing with NFS](
https://github.com/kubernetes-sigs/nfs-ganesha-server-and-external-provisioner)
- [Our deployment manifests](../platform/nfs-provisioner/)
