# /bin/bash

##
echo -e "\033[32m СОЗДАЁМ БАКЕТ В ЯНДЕКС ОБЛАКЕ"
tput sgr0

## Убираем всё из known_hosts, потому что не получилось сделать так,
## чтобы при выполнении ansible-playbook known_hosts не проверялся 
echo "" > ~/.ssh/known_hosts 

## Создаём инфраструктуру с помощью Terraform
echo "[    (0/2)] Создаём Бакет с помощью Terraform... "
cd terraform_backet
terraform apply --auto-approve #> /dev/null

## Создаём файл provider.tf для дальнейшего использования бакета при создании инфраструктуры
echo "[##  (1/2)] Создаём файл provider.tf для дальнейшего использования бакета при создании инфраструктуры"
sleep 5
terraform output -json > output.json 
sleep 1 && 
./set_backend_vars.sh 

echo -e "\033[32m [####(2/9)] ЗАВЕРШЕНО"
tput sgr0