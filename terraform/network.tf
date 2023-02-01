# Network
resource "yandex_vpc_network" "default" {
  name = "net"
}

resource "yandex_vpc_subnet" "default-1a" {
  name = "subnet-1a"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.101.0/24"]
}

resource "yandex_vpc_subnet" "default-1b" {
  name = "subnet-1b"
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.102.0/24"]
}

resource "yandex_vpc_subnet" "default-1c" {
  name = "subnet-1c"
  zone           = "ru-central1-c"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.103.0/24"]
}