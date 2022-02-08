### How to host this on minikube

## Create a hetzner account + cloud account

## use Terraform or the console to setup a server (see terraform folder, you'll need an API Key)

## SSH in, change the root password and setup minikube

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

## Copy the kube config files locally so you can use kubectl to access the cluster

```
minikube start --apiserver-ips=(your IP)



scp minikube-admin@(your IP):.kube/config .
scp minikube-admin@(your IP):.minikube/ca.crt .
scp minikube-admin@(your IP):.minikube/profiles/minikube/client.crt .
scp minikube-admin@(your IP):.minikube/profiles/minikube/client.key .
```

## Setup NGINX with a reverse proxy to allow minikube admin + application access 

https://zepworks.com/posts/access-minikube-remotely-kvm/#5-remote-access

https://ubiq.co/tech-blog/change-nginx-port-number-ubuntu/

NOTE: This isn't something you'd want to do on prodution, for prod you'd want a real load balancer instead of running everything on one server.

```
# Alter /etc/nginx/nginx.conf

stream {
  server {
      listen (your IP):51999;
      #TCP traffic will be forwarded to the specified server
      proxy_pass 192.168.49.2:8443;       
  }
  server {
      listen (your IP):88;
      #Hack: forward from non-standard port to nodeport
      proxy_pass 192.168.49.2:30110;       
  }
}

# Alter /etc/nginx/sites-enabled/default
```

## Setup Lens (locally) if desired

https://k8slens.dev/

## Install helm

https://helm.sh/docs/intro/install/

## Setup an ingress rule for the site

https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/

## Setup an Azure CI/CD pipeline for build and release