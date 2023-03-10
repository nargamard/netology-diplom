resource "yandex_compute_instance" "gitlab" {

  name                      = "gitlab"
  zone                      = "ru-central1-b"
  hostname                  = "gitlab.sarajkins.space"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 4
    core_fraction = "${var.core_fraction}"
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.ubuntu-20}"
      type        = "network-nvme"
      size        = "40"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.net-102.id}"
    nat       = false
  }

  metadata = {
    user-data = "${file("meta")}"
  }

  scheduling_policy {
    preemptible = "${var.scheduling_policy}"
  }

}