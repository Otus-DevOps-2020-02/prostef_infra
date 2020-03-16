## prostef_infra
prostef Infra repository

## ProxyJump
Используя ssh с флгагом -J можно сразу подключаться к приватной сети через публичный шлюз:
```
ssh -J username@host1:port username@host2:port
```

В моем случае это будет:
```
ssh -i ~/.ssh/appuser -J appuser@34.65.214.231 appuser@10.172.0.3
```

Но для более простого поключения по имени приватной сети, можно подправить ~/.ssh/config:
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

В этом случае можно будет подключаться прямо так:
```
ssh someinternalhost
```
