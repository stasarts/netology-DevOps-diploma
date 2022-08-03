data "yandex_client_config" "me" {}

resource "yandex_vpc_network" "avt0m8-net" {
  name = "avt0m8"
}

resource "yandex_vpc_route_table" "nat-int" {
  network_id = "${yandex_vpc_network.avt0m8-net.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.ingress_ip
  }
}

resource "yandex_vpc_subnet" "avt0m8-subnet-a" {
  v4_cidr_blocks = ["172.16.0.0/24"]
  zone           = "${var.zone}a"
  network_id     = "${yandex_vpc_network.avt0m8-net.id}"
  route_table_id = "${yandex_vpc_route_table.nat-int.id}"
}

resource "yandex_vpc_subnet" "avt0m8-subnet-b" {
  v4_cidr_blocks = ["172.16.1.0/24"]
  zone           = "${var.zone}b"
  network_id     = "${yandex_vpc_network.avt0m8-net.id}"
  route_table_id = "${yandex_vpc_route_table.nat-int.id}"
}

