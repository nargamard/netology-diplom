# /bin/bash
export internal_ip_address_proxy_wan_yandex_cloud=$(< output.json jq -r '.internal_ip_address_proxy_wan_yandex_cloud | .value')
export internal_ip_address_worker01_yandex_cloud=$(< output.json jq -r '.internal_ip_address_worker01_yandex_cloud | .value')
export internal_ip_address_worker02_yandex_cloud=$(< output.json jq -r '.internal_ip_address_worker02_yandex_cloud | .value')
export internal_ip_address_master_yandex_cloud=$(< output.json jq -r '.internal_ip_address_master_yandex_cloud | .value')
export internal_ip_address_runner_yandex_cloud=$(< output.json jq -r '.internal_ip_address_runner_yandex_cloud | .value')
export internal_ip_address_gitlab_yandex_cloud=$(< output.json jq -r '.internal_ip_address_gitlab_yandex_cloud | .value')
export yandex_container_registry_id=$(< output.json jq -r '.yandex_container_registry_id | .value')

envsubst < templates/hosts.j2 > ../ansible/inventory/hosts

envsubst < templates/haproxy_config.j2 > ../ansible/playbooks/roles/install-proxy/files/haproxy.cfg

export kindapp=test-app
export namespace=stage
envsubst < templates/deployment.j2 > ../application/deployment-stage.yaml
envsubst < templates/service.j2 > ../application/service-stage.yaml
envsubst < templates/ingress-myapp.j2 > ../application/ingress-myapp-stage.yaml

export kindapp=app
export namespace=prod
envsubst < templates/deployment.j2 > ../application/deployment-prod.yaml
envsubst < templates/service.j2 > ../application/service-prod.yaml
envsubst < templates/ingress-myapp.j2 > ../application/ingress-myapp-prod.yaml

envsubst '${yandex_container_registry_id}' < templates/gitlab-ci.j2 > ../application/.gitlab-ci.yml
