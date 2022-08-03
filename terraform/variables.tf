variable "token" {
  type      = string
  sensitive = true
}

variable "cloud_id" {
  type    = string
  default = "<cloud_id>"
}

variable "folder_id" {
  type    = string
  default = "<folder_id>"
}

variable "zone" {
  type    = string
  default = "ru-central1-"
}

variable "fqdn" {
  type    = string
  default = "<domain_name>"
}

variable "ingress_ip" {
  type    = string
  default = "172.16.0.200"
}

variable "hosts" {
  type = map(map(map(string)))
  default = {
    stage = {
      vm1 = {
        name = "db01"
        cores = "2"
        memory = "2"
        core_fraction = "20"
      }
      vm2 = {
        name = "db02"
        cores = "2"
        memory = "2"
        core_fraction = "20"
      }
      vm3 = {
        name = "app"
        cores = "2"
        memory = "2"
        core_fraction = "20"
      }
      vm4 = {
        name = "gitlab"
        cores = "2"
        memory = "8"
        core_fraction = "20"
      }
      vm5 = {
        name = "runner"
        cores = "2"
        memory = "8"
        core_fraction = "20"
      }
      vm6 = {
        name = "monitoring"
        cores = "2"
        memory = "2"
        core_fraction = "20"
      }
    }
  }
}
