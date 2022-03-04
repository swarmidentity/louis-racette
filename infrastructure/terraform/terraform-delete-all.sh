
terraform destroy -target="hetznerdns_record.louisracette_dns" -var-file="hetznerConfig.tfvars" 
terraform destroy -target="hcloud_volume.LouisRacetteLinuxVolume" -var-file="hetznerConfig.tfvars" 
terraform destroy -target="hcloud_server.LouisRacetteLinuxServer" -var-file="hetznerConfig.tfvars"  