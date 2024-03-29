# /bin/bash

##
echo -e "\033[32m РАЗВОРАЧИВАЕМ ВСЁ ХОЗЯЙСТВО В ЯНДЕКС ОБЛАКЕ"
tput sgr0

## Убираем всё из known_hosts, потому что не получилось сделать так,
## чтобы при выполнении ansible-playbook known_hosts не проверялся 
echo "" > ~/.ssh/known_hosts 

## Создаём инфраструктуру с помощью Terraform
echo "[                  (0/9)] Создаём инфраструктуру с помощью Terraform... "
cd terraform
terraform apply --auto-approve > /dev/null

## Формируем inventory для ansible
echo "[##                (1/9)] Формируем inventory для ansible..."
sleep 60 
terraform output -json > output.json 
sleep 1 && 
./fill_temlates.sh 

## Готовим Прокси-ноду 
echo "[####              (2/9)] Готовим Прокси-ноду..."
cd ../ansible 
ansible-playbook playbooks/install-proxy.yaml -i inventory/hosts -b  #> /dev/null

## Устанавливаем кластер Kubernetes 
echo "[######            (3/9)] Устанавливаем кластер Kubernetes..."
ansible-playbook playbooks/install-kuber.yaml -i inventory/hosts -b #> /dev/null

## Инициализируем Control-plane 
echo "[########          (4/9)] Инициализируем Control-plane..."
ansible-playbook playbooks/init-control-plane.yaml -i inventory/hosts -b #> /dev/null
scp -P 2222  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@master.sarajkins.space:/home/ubuntu/.kube/config $HOME/.kube/config_tmp
awk '{ if (NR == 5) print "    server: https://master.sarajkins.space:6443"; else print $0}' $HOME/.kube/config_tmp > $HOME/.kube/config && rm -f $HOME/.kube/config_tmp

## Подключаем Workers 
echo "[##########        (5/9)] Подключаем Workers..."
ansible-playbook playbooks/init-workers.yaml -i inventory/hosts -b #> /dev/null

## Устанавливаем мониторинг в кластер 
echo "[############      (6/9)] Устанавливаем мониторинг в кластер..."
ansible-playbook playbooks/install-kluster.yaml -i inventory/hosts -b #> /dev/null

scp -P 2222  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r /home/andrej/.ssh/id_rsa ubuntu@master.sarajkins.space:/home/ubuntu/.ssh/
scp -P 2223  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r /home/andrej/.ssh/id_rsa ubuntu@runner.sarajkins.space:/home/ubuntu/.ssh/

## Устанавливаем GitLab
echo "[##############    (7/9)] Устанавливаем GitLab..."
ansible-playbook playbooks/install-gitlab.yaml -i inventory/hosts -b #> /dev/null

## Устанавливаем Runner... 
echo "[################  (8/9)] Устанавливаем Runner..."
ansible-playbook playbooks/install-runner.yaml -i inventory/hosts -b #> /dev/null
scp -P 2223  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -r $HOME/.kube/ ubuntu@runner.sarajkins.space:/home/ubuntu/.kube
ansible-playbook playbooks/reconfig-runner.yaml -i inventory/hosts -b #> /dev/null

echo -e "\033[32m [##################(9/9)] ЗАВЕРШЕНО"
tput sgr0