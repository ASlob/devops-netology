### 1.
Установка node_exporter, настройка прав

```
user@linserv:~$ wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
user@linserv:~$ tar zxvf node_exporter-1.3.1.linux-amd64.tar.gz
user@linserv:~$ cd node_exporter-1.3.1.linux-amd64/
user@linserv:~/node_exporter-1.3.1.linux-amd64$ ls
LICENSE  node_exporter  NOTICE
user@linserv:~/node_exporter-1.3.1.linux-amd64$ sudo cp node_exporter /usr/local/bin/
[sudo] password for user:
user@linserv:~/node_exporter-1.3.1.linux-amd64$ sudo useradd --no-create-home --shell /bin/false nodeusr
user@linserv:~/node_exporter-1.3.1.linux-amd64$ sudo chown -R nodeusr:nodeusr /usr/local/bin/node_exporter
user@linserv:~/node_exporter-1.3.1.linux-amd64$ sudo nano /etc/systemd/system/node_exporter.service
```

Создаём юнит
```
[Unit]
Description=Node Exporter Service
After=network.target

[Service]
User=nodeusr
Group=nodeusr
Type=simple
ExecStart=/usr/local/bin/node_exporter
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Настройка автозагрузки. Проверка.
```
user@linserv:~/node_exporter-1.3.1.linux-amd64$ sudo systemctl enable node_exporter
Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service → /etc/systemd/system/node_exporter.service.
user@linserv:~/sudo reboot
user@linserv:~/sudo systemctl status node_exporter
● node_exporter.service - Node Exporter Service
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2022-06-30 16:25:36 UTC; 3h 9min ago
   Main PID: 2122 (node_exporter)
      Tasks: 5 (limit: 1071)
     Memory: 4.6M
     CGroup: /system.slice/node_exporter.service
             └─2122 /usr/local/bin/node_exporter
```

Результат в браузере: ![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen.png)


### 2.
```
--collector.cpu
--collector.diskstats
--collector.meminfo
--collector.netstat
```


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
```:(){ :|:& };:``` - команда является логической бомбой. Она оперирует определением функции с именем ‘:‘, которая вызывает сама себя дважды: один раз на переднем плане и один раз в фоне. Она продолжает своё выполнение снова и снова, пока система не зависнет.

Примерно, на третьей секунде виртуальная машина остановила работу, выдав критическую ошибку (![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen3.png)) и никакой механизм не помог автоматической стабилизации.
