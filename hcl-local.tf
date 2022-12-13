terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
  }
}

provider "local" {
  # Configuration options
}

locals {
  serverconfig = [
    for srv in var.configuration : [
      for i in range(1, srv.no_of_instances+1) : {
        instance_name = "${srv.application_name}-${i}"
        instance_type = srv.instance_type
        subnet_id   = srv.subnet_id
        ami = srv.ami
        security_groups = srv.vpc_security_group_ids
      }
    ]
  ]
}

locals {
  instances = flatten(local.serverconfig)
}

output "instances" {
  value       = {
    for server in local.instances: server.instance_name =>  server
  }
}