resource "yandex_compute_instance" "runner" {

  name                      = "runner"
  zone                      = "ru-central1-b"
  hostname                  = "runner.sarajkins.space"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 4
#    core_fraction = 20
  }

  boot_disk {
    initialize_params {
#      image_id    = "${var.ubuntu-base}"
      image_id    = "fd8snjpoq85qqv0mk9gi"      
      type        = "network-nvme"
      size        = "10"
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