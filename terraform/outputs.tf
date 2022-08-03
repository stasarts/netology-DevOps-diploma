# Вывод белого IP адреса

output "public-ip-for-ingress" {
  value = yandex_compute_instance.nginx[0].network_interface[0].nat_ip_address
}

