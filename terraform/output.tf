output "internal_ip_address_master_yandex_cloud" {
  value = "${yandex_compute_instance.master.network_interface.0.ip_address}"
}

output "internal_ip_address_worker01_yandex_cloud" {
  value = "${yandex_compute_instance.worker01.network_interface.0.ip_address}"
}

output "internal_ip_address_worker02_yandex_cloud" {
  value = "${yandex_compute_instance.worker02.network_interface.0.ip_address}"
}

output "internal_ip_address_proxy_wan_yandex_cloud" {
  value = "${yandex_compute_instance.proxy.network_interface.0.nat_ip_address}"
}