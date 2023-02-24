resource "yandex_compute_instance" "worker01" {
  name                      = "worker01"
  zone                      = "ru-central1-b"
  hostname                  = "worker01.sarajkins.space"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id    = "fd8snjpoq85qqv0mk9gi"
      name        = "worker01"
      type        = "network-hdd"
      size        = "100"     
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.net-102.id}"
    nat       = false
  }

  metadata = {
    user-data = "${file("meta")}"
  }
}