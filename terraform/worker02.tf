resource "yandex_compute_instance" "worker02" {
  name                      = "worker02"
  zone                      = "ru-central1-c"
  hostname                  = "worker02.sarajkins.space"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id    = "fd8snjpoq85qqv0mk9gi"
      name        = "worker02"
      type        = "network-hdd"
      size        = "100"     
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.net-103.id}"
    nat       = false
  }

  metadata = {
    user-data = "${file("meta")}"
  }
}