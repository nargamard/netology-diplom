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

output "internal_ip_address_runner_yandex_cloud" {
  value = "${yandex_compute_instance.runner.network_interface.0.ip_address}"
}

output "internal_ip_address_gitlab_yandex_cloud" {
  value = "${yandex_compute_instance.gitlab.network_interface.0.ip_address}"
}

output "yandex_container_registry_id" {
  value = "${yandex_container_registry.image-reg.id}"
}