# Book Commands

## Authentication

### Checking your current authentication setup
```bash
cat ~/.kube/config
```

## Auhorization (RBAC)

### User and Permissions
```bash
# Looking closer at rules
kubectl api-resources --sort-by name -o wide
```

### Real-world example
```bash
kubectl config view
kubectl config view --raw -o json \
    | jq '.users[] | select(.name=="default")' \
    | jq -r '.user["client-certificate-data"]' \
    | base64 -d | openssl x509 -text | grep "Subject:"
kubectl describe clusterrole cluster-admin
kubectl get clusterrolebindings | grep cluster-admin
kubectl describe clusterrolebindings cluster-admin
```