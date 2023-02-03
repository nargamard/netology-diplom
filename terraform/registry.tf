resource "yandex_container_registry" "image-reg" {
  name = "image-registry"
  folder_id = "${var.yandex_folder_id}"
  labels = {
    my-label = "my-image-value"
  }
}