############################################

####### Variable Import ##########

###########################################

variable "hcloud_token" {
  description = "Hetzner token"
  type        = string
  sensitive   = true
}
variable "admin_password" {
  description = "Administrator password for the server image"
  type        = string
  sensitive   = true
}

variable "hetznerDNS_Zone" {
  description = "Hetzner DNS Zone"
  type        = string
  sensitive   = true 
}

variable "hetznerDNS_APIKey" {
  description = "hetzner DNS API Key"
  type        = string
  sensitive   = true 
}

variable "Azure_DevOps_PAT" {
  description = "PAT for Azure DevOps"
  type        = string
  sensitive   = true 
}

variable "linux_image_id" {}

############################################

####### Providers ##########

###########################################


terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.32.1"
    }
    hetznerdns = {
      source = "timohirt/hetznerdns"
      version = "1.1.1"
    }
  }
}

############################################

####### Provider Configuration ##########

###########################################


provider "hcloud" {
  token = "${var.hcloud_token}"
}

provider "hetznerdns" {
  apitoken = "${var.hetznerDNS_APIKey}"
}

locals{
  desiredHetznerServers = csvdecode(file("${path.module}/ServerMasterList.csv"))
}

############################################

####### Hetzner Server Creation ##########

###########################################


data "hcloud_image" "linuxImage" {
  id = "${var.linux_image_id}"
}


resource "hcloud_server" "LouisRacetteLinuxServer" {
for_each = { for inst in local.desiredHetznerServers : inst.local_id => inst }
  name        = "LouisRacette-${each.value.ServerName}"
  server_type = "cx11"
  image       = "${data.hcloud_image.linuxImage.id}"
  labels      = tomap({"ServerName"="${lower(each.value.ServerName)}","URL"="${lower(each.value.DesiredURL)}"})
  ########### Provisioner and initial setup scripts ##########

  provisioner "remote-exec" {
    inline = [
    "export HISTIGNORE='*sudo -S*'",
# These scripts require a configured root password on the server and Azure DevOPS PAT
#	  "echo ${var.admin_password} | sudo -S apt-get update",
#    "echo ${var.admin_password} | mkdir azagent;cd azagent;curl -fkSL -o vstsagent.tar.gz https://vstsagentpackage.azureedge.net/agent/2.195.0/vsts-agent-linux-x64-2.195.0.tar.gz;tar -zxvf vstsagent.tar.gz; if [ -x \"$(command -v systemctl)\" ]; then ./config.sh --deploymentgroup --deploymentgroupname \"${each.value.AzureGroup}\" --acceptteeeula --agent $HOSTNAME --url https://dev.azure.com/swarmidentity/ --work _work --projectname 'LouisRacette' --auth PAT --token \"${var.Azure_DevOps_PAT}\" --runasservice;",
#    "echo ${var.admin_password} | sudo -S ./svc.sh install;",
#    "echo ${var.admin_password} | sudo -S ./svc.sh start; else ./config.sh --deploymentgroup --deploymentgroupname \"${each.value.AzureGroup}\" --acceptteeeula --agent $HOSTNAME --addDeploymentGroupTags --deploymentGroupTags \"web\" --url https://dev.azure.com/swarmidentity/ --work _work --projectname 'LouisRacette' --auth PAT --token ${var.Azure_DevOps_PAT}; ./run.sh; fi"
  ]
	  
	connection {
    type     = "ssh"
    user     = "louisracette-admin"
    password = "${var.admin_password}"
    host     = "${self.ipv4_address}"
	  timeout  = "2m"
    }
  }
}


resource "hcloud_volume" "LouisRacetteLinuxVolume" {
for_each = { for inst in hcloud_server.LouisRacetteLinuxServer : inst.id => inst }
 name = "Volume-${each.key}"
  size = 1            #Start with only a small volume, this may grow later
  server_id = "${each.key}"
  automount = true
  format = "xfs"
  depends_on = [ hcloud_server.LouisRacetteLinuxServer ]
}


############################################

####### DNS And Network Creation ##########

###########################################


data "hetznerdns_zone" "dns_zone" {
    name = "louisracette.com"
}

resource "hetznerdns_record" "louisracette_dns" {
  for_each = { for inst in hcloud_server.LouisRacetteLinuxServer : inst.id => inst }
    zone_id = data.hetznerdns_zone.dns_zone.id
    name = "${lower(lookup(each.value.labels,"URL","test"))}"
    value = "${each.value.ipv4_address}"
    type = "A"
    ttl= 86400
    depends_on = [ hcloud_server.LouisRacetteLinuxServer]
}


############################################

####### Output Variables ##########

###########################################


output "volume_specs" {
value = [for r in hcloud_volume.LouisRacetteLinuxVolume[*]: r]
}

output "server_specs" {
value = [for r in hcloud_server.LouisRacetteLinuxServer[*]: r]
}

