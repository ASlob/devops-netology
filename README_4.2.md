# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Ошибка при сложении разных типов данных int и str  |
| Как получить для переменной `c` значение 12?  | c = str(a) + b  |
| Как получить для переменной `c` значение 3?  | c = a + int(b)  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/gitproject/netology", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(os.path.abspath(prepare_result))
```

### Вывод скрипта при запуске при тестировании:
```
user@linserv:~/gitproject/netology$ ./script1.py
/home/user/gitproject/netology/README_4.2.md
/home/user/gitproject/netology/newdir/new_file.txt
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3
print("Введите путь репозитория в формате 'path/':")
path = input()

import os

os.chdir(path)
bash_command = ["git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path+prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
user@linserv:~$ ./script3.py
Введите путь репозитория в формате 'path/':
gitproject/netology/
gitproject/netology/README_4.2.md
gitproject/netology/newdir/new_file.txt
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import socket
import time

hosts = {'drive.google.com':'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0'}
while 1 == 1 :
  for host in hosts :
    ip = socket.gethostbyname(host)
    if ip != hosts[host] :
      print(' [ERROR] ' + str(host) +' IP mistmatch: '+hosts[host]+' '+ip)
      hosts[host]=ip
    else :
        print(str(host) + ' ' + ip)
    time.sleep(2)
```

### Вывод скрипта при запуске при тестировании:
```
user@linserv:~$ ./script4.py
 [ERROR] drive.google.com IP mistmatch: 0.0.0.0 64.233.165.194
 [ERROR] mail.google.com IP mistmatch: 0.0.0.0 64.233.161.83
 [ERROR] google.com IP mistmatch: 0.0.0.0 173.194.222.102
drive.google.com 64.233.165.194
 [ERROR] mail.google.com IP mistmatch: 64.233.161.83 64.233.161.17
 [ERROR] google.com IP mistmatch: 173.194.222.102 173.194.222.113
drive.google.com 64.233.165.194
mail.google.com 64.233.161.17
google.com 173.194.222.113
...
```
