output "yandex_container_registry_access_key" {
  value = "${yandex_iam_service_account_static_access_key.sa-static-key.access_key}"
}

output "yandex_container_registry_secret_key" {
  value = "${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}"
  sensitive = true
}