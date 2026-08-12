# Book Commands

## Intro to Namespaces
``` bash
kubectl api-resources
```

## Default Namespaces
``` bash
kubectl get namespaces
kubectl describe ns default
kubectl get svc --namespace kube-system
kubectl get svc --all-namespaces
kubectl get svc -A
```

## Creating and Managing Namespaces
``` bash
kubectl create ns hydra
kubectl apply -f shield-ns.yaml
kubectl delete ns hydra
```

### Configure kubectl for a specific Namespace
``` bash
kubectl config set-context --current --namespace shield
cat ~/.kube/config
kubectl get pods
```

## Deploying objects to Namespace
``` bash
kubectl apply -f app.yaml
kubectl get pods -n shield
kubectl get svc -n shield
kubectl get all
curl 10.10.10.1:8080
```

## Clean up
``` bash
kubectl delete ns shield
kubectl config set-context --current --namespace default
```

# Personal Commands

## Imperative vs Declarative Namespace declaration
``` bash
kubectl apply -f app.yaml -n kubernetes-book
# If the namespace from the yaml doesn't match the CLI namespace, you will receive an error: "the namespace from the provided object "shield" does not match the namespace "kubernetes-book". You must pass '--namespace=shield' to perform this operation."
```