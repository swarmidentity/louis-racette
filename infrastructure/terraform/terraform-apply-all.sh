terraform apply -target="hcloud_server.WatchdogLinuxServer" -var-file="hetznerConfig.tfvars"  
terraform apply -target="hcloud_volume.WatchdogLinuxVolume" -var-file="hetznerConfig.tfvars"  
terraform apply -target="hetznerdns_record.watchdog_dns" -var-file="hetznerConfig.tfvars"  