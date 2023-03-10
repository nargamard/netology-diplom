# Идентификатор облака
variable "yandex_cloud_id" {
  default = "b1gi491ooe67mld8atql"
}

# Идентификатор каталога (Folder) в облаке
variable "yandex_folder_id" {
  default = "b1gbdtedb4koa56sb2rr"
}

# Зона по умолчанию
variable "yandex_compute_default_zone" {
  default = "ru-central1-a"
}

# Бакет для backend
variable "backet_for_backend" {
  default = "terraform-object-storage-nargamard"
}

# Идентификатор статического ключа
#variable "static_key_id" {
#  default = "YCAJEntHHcZBjW-INoc391fhj"
#}

# Секретный ключ
#variable "secret_key" {
#  default = "YCPot7CRiAGcvB69CWu2lF-JNsZUDBVB__OBS51f"
#}

variable "lan_proxy_ip" {
  default = "192.168.101.100"
}

# https://cloud.yandex.ru/marketplace/products/yc/nat-instance-ubuntu-18-04-lts
variable "ubuntu-proxy" {
 # default = "fd83slullt763d3lo57m"
  default = "fd8o8aph4t4pdisf1fio"
}

# ID yc compute image list Ubuntu 22.04 LTS
variable "ubuntu-base" {
#  default = "fd8uoiksr520scs811jl"
  default = "fd8snjpoq85qqv0mk9gi"
}

# ID yc compute image list Ubuntu 20.04 LTS
variable "ubuntu-20" {
  default = "fd8kdq6d0p8sij7h5qe3"
}

# Прерываемая виртуальная машина или нет
variable "scheduling_policy" {
  default = "true"
}

# Значение core_fraction
variable "core_fraction" {
  default = "20"
}