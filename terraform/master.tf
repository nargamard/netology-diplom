resource "yandex_compute_instance" "master" {
  name                      = "master"
  zone                      = "ru-central1-a"
  hostname                  = "master.sarajkins.space"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = "fd8snjpoq85qqv0mk9gi"
      name        = "master"
      type        = "network-hdd"
      size        = "100"     
    }
  }

  #network_interface {
  #  subnet_id = "${yandex_vpc_subnet.default-1a.id}"
  #  nat       = true
  #}

  network_interface {
    subnet_id = "${yandex_vpc_subnet.net-101.id}"
    nat       = false
  }

  metadata = {
    user-data = "${file("meta")}"
  }
}