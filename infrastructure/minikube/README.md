## Create a hetzner account + cloud account

## use Terraform or the console to setup a server

## SSH in and setup minikube

## Setup a non-root user

https://www.cyberciti.biz/faq/create-a-user-account-on-ubuntu-linux/

## Add this user to the sudoers file

https://linuxize.com/post/how-to-add-user-to-sudoers-in-ubuntu/

## Install Docker

https://docs.docker.com/engine/install/ubuntu/

## Install Minikube

https://minikube.sigs.k8s.io/docs/start/

## Setup Kubectl alias and bash autocomplete

https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-bash-linux/
```

```

## Copy the kube config files locally so you can use kubectl to access the cluster

```

```

## Setup NGINX with a reverse proxy to allow minikube admin access

## This is a hack and causes other problems, TODO: Revisit this

https://zepworks.com/posts/access-minikube-remotely-kvm/#5-remote-access

```
stream {
  server {
      listen 65.21.153.19:51999;
      #TCP traffic will be forwarded to the specified server
      proxy_pass 192.168.49.2:8443;       
  }
}
```

## Setup Lens if desired

## Setup an ingress rule for the site


https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/

## Setup a kubectl file

## Setup an Azure CI/CD pipeline + helm chart