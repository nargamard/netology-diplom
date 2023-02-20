resource "yandex_dns_zone" "diplom" {
  name        = "my-diplom-netology-zone"
  description = "Diplom Netology public zone"

  labels = {
    label1 = "diplom-public"
  }

  zone    = "sarajkins.space."
  public  = true

  depends_on = [
    yandex_vpc_subnet.net-101,yandex_vpc_subnet.net-102,yandex_vpc_subnet.net-103
  ]
}

resource "yandex_dns_recordset" "def" {
  zone_id = yandex_dns_zone.diplom.id
  name    = "@.sarajkins.space."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "gitlab" {
  zone_id = yandex_dns_zone.diplom.id
  name    = "gitlab.sarajkins.space."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "alertmanager" {
  zone_id = yandex_dns_zone.diplom.id
  name    = "alertmanager.sarajkins.space."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "grafana" {
  zone_id = yandex_dns_zone.diplom.id
  name    = "grafana.sarajkins.space."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "prometheus" {
  zone_id = yandex_dns_zone.diplom.id
  name    = "prometheus.sarajkins.space."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "www" {
  zone_id = yandex_dns_zone.diplom.id
  name    = "www.sarajkins.space."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "master" {
  zone_id = yandex_dns_zone.diplom.id
  name    = "master.sarajkins.space."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "worker01" {
  zone_id = yandex_dns_zone.diplom.id
  name    = "worker01.sarajkins.space."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "worker02" {
  zone_id = yandex_dns_zone.diplom.id
  name    = "worker02.sarajkins.space."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}