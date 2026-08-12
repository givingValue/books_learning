# Book Commands

## Create a Deployment
``` bash
kubectl apply -f deploy.yaml -n kubernetes-book
```

### Inspecting Deployments
``` bash
kubectl get deploy hello-deploy -n kubernetes-book
kubectl describe deploy hello-deploy -n kubernetes-book
kubectl get rs -n kubernetes-book
kubectl describe rs hello-deploy-6f4cfbc5b4 -n kubernetes-book
```

### Accessing the app
``` bash
kubectl apply -f lb.yaml -n kubernetes-book
kubectl get svc lb-svc -n kubernetes-book
```

## Manually scale the app
``` bash
kubectl get deploy hello-deploy -n kubernetes-book
kubectl scale deploy hello-deploy --replicas 5 -n kubernetes-book
kubectl describe rs hello-deploy-6f4cfbc5b4 -n kubernetes-book
kubectl get deploy hello-deploy -n kubernetes-book
kubectl apply -f deploy.yaml -n kubernetes-book
kubectl describe rs hello-deploy-6f4cfbc5b4 -n kubernetes-book
kubectl get deploy hello-deploy -n kubernetes-book
```

## Perform a rolling update
``` bash
kubectl apply -f deploy-v2.yaml -n kubernetes-book
kubectl rollout status deployment hello-deploy -n kubernetes-book
kubectl get deploy hello-deploy -n kubernetes-book
```

### Pausing and resuming rollouts
``` bash
kubectl rollout pause deploy hello-deploy -n kubernetes-book
kubectl describe deploy hello-deploy -n kubernetes-book
kubectl rollout resume deploy hello-deploy -n kubernetes-book
kubectl get deploy hello-deploy -n kubernetes-book
```

## Perform a rollback
``` bash
kubectl rollout history deployment hello-deploy -n kubernetes-book
kubectl get rs -n kubernetes-book
kubectl describe rs hello-deploy-6f4cfbc5b4 -n kubernetes-book
kubectl rollout undo deployment hello-deploy --to-revision 1 -n kubernetes-book
kubectl get deploy hello-deploy -n kubernetes-book
kubectl rollout status deployment hello-deploy -n kubernetes-book
kubectl describe deploy hello-deploy -n kubernetes-book
```

### Rollouts and labels
``` bash
kubectl describe deploy hello-deploy -n kubernetes-book
kubectl describe rs hello-deploy-6f4cfbc5b4 -n kubernetes-book
kubectl get pods --show-labels -n kubernetes-book
```

## Clean up
``` bash
kubectl delete -f deploy.yaml -f lb.yaml -n kubernetes-book
```