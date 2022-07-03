### 1.
```HTTP/1.1 301 Moved Permanently``` - Код состояния HTTP 301 или Moved Permanently (с англ. — «Перемещено навсегда») — стандартный код ответа HTTP, получаемый в ответ от сервера в ситуации, когда запрошенный ресурс был на постоянной основе перемещён в новое месторасположение, и указывающий на то, что текущие ссылки, использующие данный URL, должны быть обновлены


### 2.
```
Request URL: http://stackoverflow.com/
Request Method: GET
Status Code: 301 Moved Permanently
Remote Address: 151.101.1.69:80
Referrer Policy: strict-origin-when-cross-origin
```
Самый долгий запрос обрабатывался 397 мс. - ![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen4.png)
### 3.
```
vagrant@vagrant:~$ sudo lsof -i :19999
COMMAND PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
netdata 664 netdata    4u  IPv4  24589      0t0  TCP *:19999 (LISTEN)
netdata 664 netdata   22u  IPv4  28988      0t0  TCP vagrant:19999->_gateway:49462 (ESTABLISHED)
netdata 664 netdata   26u  IPv4  29973      0t0  TCP vagrant:19999->_gateway:49463 (ESTABLISHED)
netdata 664 netdata   32u  IPv4  29974      0t0  TCP vagrant:19999->_gateway:49464 (ESTABLISHED)
netdata 664 netdata   34u  IPv4  29975      0t0  TCP vagrant:19999->_gateway:49465 (ESTABLISHED)
netdata 664 netdata   52u  IPv4  29977      0t0  TCP vagrant:19999->_gateway:49470 (ESTABLISHED)
netdata 664 netdata   53u  IPv4  29978      0t0  TCP vagrant:19999->_gateway:49471 (ESTABLISHED)
```
Результат в браузере: ![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen2.png)


### 4.  
```
vagrant@vagrant:~$ sudo dmesg | grep "Hypervisor detected"
[    0.000000] Hypervisor detected: KVM
```
Если система физическая, выходных данных не будет.


### 5.  
```
vagrant@vagrant:~$ sysctl fs.nr_open
fs.nr_open = 1048576
```
Значение по умолчанию - 1024*1024 (1048576)

```
vagrant@vagrant:~$ ulimit -Hn
1048576
vagrant@vagrant:~$ ulimit -Sn
1024
```
'S' обозначает мягкие ограничения, изменяется приложениями динамически, в т.ч. и за пределы ограничения, но не более чем 'H'   
'H' обозначает жесткие ограничения, задается корневым пользователем   
'n' обозначает мсимальное количество открытых файловых дескрипторов   

Значения приводятся с шагом 1024 байта, за исключением -t, который выражается в секундах, -p, который находится с шагом 512 байт, и -u, который представляет собой немасштабированное число процессов.


### 6.  
```
vagrant@vagrant:~$ sudo -i
root@vagrant:~# unshare --fork --pid --mount-proc sleep 1h
bg
^Z
[1]+  Stopped                 unshare -f --pid --mount-proc sleep 1h
root@vagrant:~# ps aux | grep sleep
root       17815  0.0  0.0   8080   596 pts/0    T    21:23   0:00 unshare -f --pid --mount-proc sleep 1h
root       17816  0.0  0.0   8076   580 pts/0    S    21:23   0:00 sleep 1h
root       17822  0.0  0.0   8900   724 pts/0    S+   21:23   0:00 grep --color=auto sleep
root@vagrant:~# nsenter -t 17816 -p -m
root@vagrant:/# ps
    PID TTY          TIME CMD
      1 pts/0    00:00:00 sleep
      2 pts/0    00:00:00 bash
     11 pts/0    00:00:00 ps
```


### 7.
:(){ :|:& };: - команда является логической бомбой. Она оперирует определением функции с именем ‘:‘, которая вызывает сама себя дважды: один раз на переднем плане и один раз в фоне. Она продолжает своё выполнение снова и снова, пока система не зависнет.

Примерно, на третьей секунде виртуальная машина остановила работу, выдав критическую ошибку (![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen3.png)) и никакой механизм автоматической стабилизации не помог.   
После перезагрузки компьютера при запуске vagrant компьютер повис и только после второй перезагрузки всё получилось, и механизм всё-таки сработал  

```
vagrant@vagrant:~$ :(){ :|:& };:
...
...
...
-bash: fork: Resource temporarily unavailable
^C
[1]+  Done                    : | :
vagrant@vagrant:~$ dmesg
...
...
...
[  659.252236] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-1.scope
```
Cработал механизм сgroups, ограничив ресурсы внутри конкретной контрольной группы процессов.   
Чтобы временно изменить ограничение (в рамках данной сессии): ```ulimit -u <значение>```   
Чтобы ввести постоянное ограничение: ```/etc/security/limits.conf```


