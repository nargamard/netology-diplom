# /bin/bash

## Удаляем всю созданную в Яндекс Облаке инфраструктуру
echo "Удаляем инфраструктуру с помощью Terraform..."
cd terraform
terraform destroy --auto-approve