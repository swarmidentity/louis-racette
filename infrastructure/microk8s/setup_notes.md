I used microk8s for hosting, minikube is fine if you're running locally but microk8s provides better options for running a production site.

https://microk8s.io/docs/getting-started

```
microk8s enable helm3 dns ingress
```

Make sure that ingresses have the annotation:
```
 kubernetes.io/ingress.class: public 
```
