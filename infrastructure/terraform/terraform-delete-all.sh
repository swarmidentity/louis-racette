
terraform destroy -target="hetznerdns_record.watchdog_dns" -var-file="hetznerConfig.tfvars" 
terraform destroy -target="hcloud_volume.WatchdogLinuxVolume" -var-file="hetznerConfig.tfvars" 
terraform destroy -target="hcloud_server.WatchdogLinuxServer" -var-file="hetznerConfig.tfvars"  