# /bin/bash

export access_key=$(< output.json jq -r '.  "yandex_container_registry_access_key"  | .value')
export secret_key=$(< output.json jq -r '.  "yandex_container_registry_secret_key"  | .value')

envsubst '${access_key},${secret_key}' < provider.j2 > ../terraform/provider.tf
