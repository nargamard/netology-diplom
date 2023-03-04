# /bin/bash
export internal_ip_address_proxy_wan_yandex_cloud=$(< output.json jq -r '.internal_ip_address_proxy_wan_yandex_cloud | .value')
export internal_ip_address_worker01_yandex_cloud=$(< output.json jq -r '.internal_ip_address_worker01_yandex_cloud | .value')
export internal_ip_address_worker02_yandex_cloud=$(< output.json jq -r '.internal_ip_address_worker02_yandex_cloud | .value')
export internal_ip_address_master_yandex_cloud=$(< output.json jq -r '.internal_ip_address_master_yandex_cloud | .value')

envsubst < hosts.j2 > ../ansible/inventory/hosts

envsubst < haproxy_config.j2 > ../ansible/playbooks/roles/setup-proxy/files/haproxy.cfg
