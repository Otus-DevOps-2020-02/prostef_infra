# prostef_infra
prostef Infra repository

## ProxyJump
### Используя ssh с флгагом -J можно сразу подключаться к приватной сети через публичный шлюз:
```
ssh -J username@host1:port username@host2:port
```

### В моем случае это будет:
```
ssh -i ~/.ssh/appuser -J appuser@34.65.214.231 appuser@10.172.0.3
```

### Но для более простого поключения по имени приватной сети, можно подправить ~/.ssh/config:
```
Host bastion
 User appuser
 PreferredAuthentications publickey
 IdentityFile ~/.ssh/apuser.key
 HostName 34.65.214.231

Host someinternalhost
 User appuser
 HostName 10.172.0.3
 ProxyJump bastion
```

### В этом случае можно будет подключаться прямо так:
```
ssh someinternalhost
```

## Данные для подключения:
```
bastion_IP = 34.65.214.231
someinternalhost_IP = 10.172.0.3
```

## ДЗ Деплой тестового приложения:
```
testapp_IP = 34.65.246.13
testapp_port = 9292
```

### Создание инстанса со стартап скриптом:
```
gcloud compute instances create reddit-app2 --boot-disk-size=10GB --image-family ubuntu-1604-lts --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --metadata-from-file startup-script=startup_script.sh
```

### Правило файрвола через консоль:
```
gcloud compute firewall-rules create default-puma-server --allow tcp:9292 --target-tags=puma-server
```

## Packer
- Создан шаблон для Packer с пользовательскими переменными
- Создан файл с пользовательскими переменными
- Создан скрипт packer/files/init_reddit.sh, который устанавливает сервис reddit и запускает его
- Создан файл packer/files/pumma.service сервиса reddit
- Создан новый шаблон с указанием в блоке провиженоров файла pumma.service, а так же нового скрита init_reddit.sh
- Создан новый скрипт config-scripts/create-reddit-vm.sh, который создает новый инстанс из созданного образа reddit-full
- Все протестировано

## Terraform-1
- Создан шаблон main.tf с кодом для разворачивания gcp сущностей
- Создан файл outputs.tf для выходных переменных
- Создан файл в variables.tf описанием входных переменных
- В файле terraform.tfvars заданы значения входным переменным
- Протестирована работа провиженоров
- Добавлены новые входные переменные и протестирована работа команды terraform fmt
- Выполнена команда terraform destroy

## Terraform-2
- Созданы отдельные локальные модули app, db, vps
- Протестирован вызов модулей из main.tf
- Созданы отдельные окружения stage и prod с разными настройками подключения
- Создан модуль stage-bucket.tf с подключением удаленного модуля из реестра модулей
- Протестировано создание Storage через выпшеписанный модуль
- Выполнена команда terraform fmt
- Выполнена команда terraform destroy

## Ansible-1
- Скачан и установлен Ansible
- Создан ansible.cfg с необходимыми параметрами
- Создан inventory.ylm с хостами
- Создан clone.yml - playbook клонирования репозитория и выполнен он командой " ansible-playbook clone.yml "
- Выполнена команда " ansible app -m command -a 'rm -rf ~/reddit' " - которая удалила репозиторий, был создан выше. Соотвественно при повторном выполнении playbook'a этот репозиторий склонируется заного

## Ansible-2
- Протестирован подход "Один playbook, один сценарий" в файле reddit_app_one_play.yml
- Протестирован подход "Один плейбук, несколько сценариев" в файле reddit_app_multiple_plays.yml
- Протестирован подход "Несколько плейбуков" в файле site.yml
- В Packer в файлах app.json и db.json изменен провижининг на ansible
- С помощью Packer пересобраны образы reddit-app-base и reddit-db-base
- С помощью Terraform перевыпущены инстансы из образов
- При помощи Ansible и плейбука site.yml выполнены все необходимые операции для свизи и работы приложения с БД
