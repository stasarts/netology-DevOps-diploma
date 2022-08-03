data "yandex_compute_image" "image" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "nginx" {
  count = "${terraform.workspace == "stage" ? 1 : 0}"
  name  = "nginx"
  hostname = "nginx"
  zone  = "${var.zone}a"
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      size     = 10
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.avt0m8-subnet-a.id
    ip_address = var.ingress_ip
    nat        = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "hosts" {
  for_each = var.hosts[terraform.workspace]
  name = each.value.name
  hostname = each.value.name
  allow_stopping_for_update = true

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      size     = 10
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }

  network_interface {
    subnet_id = "${each.value.name == "db02" ? yandex_vpc_subnet.avt0m8-subnet-b.id : yandex_vpc_subnet.avt0m8-subnet-a.id}"
  }

  zone = "${each.value.name == "db02" ? "${var.zone}b" : "${var.zone}a"}"

  scheduling_policy {
    preemptible = true
  }
  
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
