# Terraform setup scripts for hosting this personal site
Terraform and Infrastructure Scripts

Terraform scripts require a backup image that has a configured password if you want to run any startup commands.

```
#Setup servers
terraform init
bash ./terraform-apply-all.sh
```



Add these configs to servers:


https://docs.docker.com/engine/install/linux-postinstall/