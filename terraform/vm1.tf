resource "yandex_compute_instance" "vm1" {
  name = "instance1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8snjpoq85qqv0mk9gi"
      name        = "root-vm1"
      type        = "network-hdd"
      size        = "100"     
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.default-1a.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}