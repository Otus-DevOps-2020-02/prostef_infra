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
