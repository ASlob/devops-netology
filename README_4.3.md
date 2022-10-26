# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

Ответ:
```
    { "info": "Sample JSON output from our service\t",
        "elements": [
            { 
	      "name": "first",
              "type": "server",
              "ip": 7175 
            },
            { 
	      "name": "second",
              "type": "proxy",
              "ip": 71.78.22.43
            }
        ]
    }
```




## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import time
import json
import yaml

hosts = {'drive.google.com':'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0'}

while True :
    for host in hosts :
        ip = socket.gethostbyname(host)
        if ip != hosts[host] :
            print(' [ERROR] ' + str(host) +' IP mistmatch: '+hosts[host]+' '+ip)
            hosts[host]=ip
            with open("./file.json", 'w+') as write_json, open("./file.yaml", 'w+') as write_yaml:
                write_json.write(json.dumps(hosts, indent=4))
                write_yaml.write(yaml.dump(hosts, indent=4))
        else :
            print(str(host) + ' ' + ip)
    time.sleep(2)
```

### Вывод скрипта при запуске при тестировании:
```
root@vps17920:~# ./script4_3.py
 [ERROR] drive.google.com IP mistmatch: 0.0.0.0 172.217.5.14
 [ERROR] mail.google.com IP mistmatch: 0.0.0.0 172.217.1.101
 [ERROR] google.com IP mistmatch: 0.0.0.0 142.250.191.238
drive.google.com 172.217.5.14
mail.google.com 172.217.1.101
google.com 142.250.191.238
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{
    "drive.google.com": "142.251.1.194",
    "mail.google.com": "142.250.74.165",
    "google.com": "142.250.74.174"
}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
drive.google.com: 142.251.1.194
google.com: 142.250.74.174
mail.google.com: 142.250.74.165
```
