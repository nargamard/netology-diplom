output "external_ip_address_vm01_yandex_cloud" {
  value = "${yandex_compute_instance.vm1.network_interface.0.nat_ip_address}"
}

output "external_ip_address_vm02_yandex_cloud" {
  value = "${yandex_compute_instance.vm2.network_interface.0.nat_ip_address}"
}

output "external_ip_address_vm03_yandex_cloud" {
  value = "${yandex_compute_instance.vm3.network_interface.0.nat_ip_address}"
}