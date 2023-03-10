# Дипломная работа
## Деплой приложения в кластер Kubernetes в Яндекс.Облаке

---

## Общее описание
Задача состоит в том, что требуется:
1. Создать инфраструктуру в Яндекс.Облаке;
2. Установить на неё кластер Kubernetes;
3. Установить систему мониторинга (Prometheus+Grafana+NodeExporter+AlertManager);
4. Создать реестр для хранения образов приложения;
5. Настроить автоматический деплой приложения в кластер при изменениях прилдожения в репозитории

Для решения этих задач решено использовать такие инструменты, как:
- Terraform для создания инфраструктуры;
- Ansible для установки приложения и настройки узлов
- GitLab для автоматизации деплоя приложения
 
Для автоматизации самого процесса создания указанной инфраструктуры принято решения создать два скрипта на `bash`:
- [`deploy.sh`](./deploy.sh) для создания инфраструктуры
- [`destroy.sh`](./destroy.sh) для уничтожения инфраструктуры

Такое решение проще, чем создавать роль для Ansible, и правильнее, чем писать `playbook`, состоящий в основном из вызовов `shell:`. Сложность состоит в том, что надо последовательно выполнять команды как на локальной машине, так и в `Яндекс.Облаке`.

---
## ЭТАП I
## Создание инфраструктуры

### Создание Бакета (папка `terraform_backet`)
По условиям задания следует хранить `backend` Терраформа в Бакете в облаке. То есть, рядом с остальной инфраструктурой. Оказалось, что нельзя единовременно создать с помощью Терраформа `Бакет` в `Облаке` и сразу же его использовать. 
Поэтому принято решение создать два отдельных каталога с конфигурациями Терраформ:
- `terraform_backet` для создания `Бакета`
- `terraform` для создания инфраструктуры

Создание Бакета на этом этапе не включено в скрипт [`deploy.sh`](./deploy.sh), поскольку эта инфраструктура не требует значимых расходов и в процессе подготовки остального проекта не удаляется.

### Создание облачной инфраструктуры (папка `terraform`)

Создаются следующие виртуальные машины:
1. [`proxy.tf`](/terraform/proxy.tf) - единственная машина с внешним ip адресом для доступа через неё к остальной инфраструктуре;
2. [`master.tf`](/terraform/master.tf)- для настройки как `control-plane` кластера `Kubernetes`
3. [`worker01.tf`](/terraform/worker01.tf) - для настройки как `worker-node` кластера `Kubernetes`
4. [`worker02.tf`](/terraform/worker02.tf) - для настройки как `worker-node` кластера `Kubernetes`
5. [`gitlab.tf`](/terraform/gitlab.tf) - для установки GitLab
6. [`runner.tf`](/terraform/runner.tf) - для установки Runner

Причём ноды `worker01` и `worker02` находятся в разных подсетях.

Создаётся ода сеть и три подсети в разных зонах доступности ([`network.tf`](/terraform/network.tf)):
- ru-central1-a
- ru-central1-b
- ru-central1-c

Создаётся `yandex_dns_zone` и А-записи в ней ([`dns.tf`](/terraform/dns.tf)).

Создаётся реестр ([`registry.tf`](/terraform/registry.tf)).

Файл [`output.tf`](/terraform/output.tf) определяет, что будут выведены ip адреса, которые понадобятся для формирования `hosts` для `Ansible`.

В файле [`provider.tf`](/terraform/provider.tf) содержится указание на то, что следует использовать `Бакет` для `Backend` и данные для доступа к `Бакету` и Облаку. Кроме ключа сервисного аккаунта. `service_account_key_file` хранится на локальной машине. 

Насколько это всё правильно с точки зрения безопасности?

Файлы [`hosts.j2`](/terraform/hosts.j2) и [`haproxy_config.j2`](/terraform/haproxy_config.j2) - шаблоны для создания [`hosts`](/ansible/inventory/hosts) для `Ansible` и [`haproxy.cfg`](/ansible/playbooks/roles/setup-proxy/files/haproxy.cfg) для настройки `Haproxy`.
Эти файлы собирает по шаблонам скрипт [`hosts.sh`](/terraform/hosts.sh) при помощи `envsubst`.

   В файле [`meta`](/terraform/meta) хранятся данные для настройки доступа к создаваемым виртуальным машинам.

---
## ЭТАП II 
## Настройка Прокси

На этом этапе запускается `роль setup-proxy`, которая на ноду `proxy` устанавливает пакет `haproxy` и копирует файл конфигруации, подготовленный на предыдущем этапе.
И перезапускает сервис.

Настройка на этом этапе простая: слушается порт 80, ACL grafana.sarajkins.space перенаправляется на ноду `master`, ACL gitlab.sarajkins.space перенаправляется на ноду `gitlab`.

Доступ `Ansible` к другим нодам осуществляется с помощью команды вида `ansible_ssh_common_args='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q ubuntu@master.sarajkins.space -o StrictHostKeyChecking=no "'`, которая для каждого узла содержится в файле `hosts`

---
## ЭТАП III 
## Установка кластера Kubernetes

Кластер устанавливается на ноды `master`, `worker01` и `worker02`. 
В файле `hosts` добавлены группировки:
Группа `workers` включает в себя обе ноды `worker*`;
Группа `kluster` включает в себя группы `workers` и `master`;

Установка происходит в следующем порядке:
1. Против группы `kluster` запускается роль `install-kuber`, которая устанавливает пакеты Kubernetes на все ноды. После чего отдельно устанавливается `containerd` из репозитория с `docker.com`, удаляется файл `/etc/containerd/config.toml` и перезапускается служба.
Без этого клстер нельзя было инициализировать.
2. Против группы `master` запускается роль `control-plane`, которая
   - Инициализиирует кластер
   - Копирует `.kube` в домашнюю директорию
   - Устанавливает сетевой плагин `flannel`
   - Выводит команду для подключения рабочих нод.
  Здесь все таски вызывают `shell`. Так работает, но как будет правильно?
3. Против группы `workers` запускается роль `init-workers`, которая:
   - Получает команду для подключения к кластеру из перменной join_command_raw, к которой можно обратить через hostvars группы `kluster`;
   - Подключает ноды к кластеру при помощи этой команды.
   
---
## ЭТАП IV 
## Установка мониторинга
Против группы `master` запускается роль `install-monitoring`, которая:
1. Устанавливет стек мониторинга в `namespace "monitoring"` при помощи `helm`
2. Устанавливает `ingress-nginx` при помощи `helm`.
3. Устанавливает `ingress` для `grafana` чтобы обеспечить доступ к сервису.

---
## ЭТАП V 
## Установка GitLab
Запускается роль `gitlab`, которая устанавливает `gitlab` на одноименную ноду. Прокси для доступа к веб-интерфейсу настроен ранее.

---
## ЭТАП VI 
## Установка runner
Запускается роль `runner`, которая устанавливает `runner` на одноименную ноду.

## ЭТАП VII 
## Деплой приложения
В папке `application` есть каталог `html`, который содержит сайт.
Также создан `Dockerfile`, который на основе образа `altcloud/nginx` позводяет собрать контейнер nginx с приложением.

На этом этапе пока остановился.
Сейчас по плану разобраться, как пользоваться gitlab. Пересмотрю лекцию и попробую розобраться с примерами.

---
## Вопросы:
1. Какую информацию из конфигурационных файлов Терраформа следует спрятать? Сейчас там только ключ сервисного аккаунта на локальной машине хранится. Остальное явным образом написано.
2. Как в ролях `control-plane`, `install-monitoring` уменьшить использование `shell`?

---
## Скриншоты
Ниже скриншоты результата. Домен sarajkins.space арендовал заранее. 

Виртуальные машины
![Виртушки](tmp/img/%D0%92%D0%B8%D1%80%D1%82%D1%83%D1%88%D0%BA%D0%B8.png)
Сети
![Сети](tmp/img/%D0%A1%D0%B5%D1%82%D0%B8.png)
DNS
![DNS](tmp/img/DNS.png)
Бакет
![Бакет](tmp/img/%D0%91%D0%B0%D0%BA%D0%B5%D1%82.png)
Grafana
![Графана](tmp/img/%D0%93%D1%80%D0%B0%D1%84%D0%B0%D0%BD%D0%B0.png)
GitLab
![GitLab](tmp/img/GitLab.png)
Вывод `kubectl get pods --all-namespaces`
![Alt text](tmp/img/get_pods.png)