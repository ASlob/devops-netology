### 1.
**Windows**
```
PS C:\Users\Artem> ipconfig

Настройка протокола IP для Windows


Адаптер Ethernet Ethernet:

   DNS-суффикс подключения . . . . . :
   Локальный IPv6-адрес канала . . . : fe80::b0c7:ed24:17c1:9a82%20
   IPv4-адрес. . . . . . . . . . . . : 192.168.1.4
   Маска подсети . . . . . . . . . . : 255.255.255.0
   Основной шлюз. . . . . . . . . : 192.168.1.1

Адаптер Ethernet VirtualBox Host-Only Network:

   DNS-суффикс подключения . . . . . :
   Локальный IPv6-адрес канала . . . : fe80::a545:3230:8cbf:a08a%7
   IPv4-адрес. . . . . . . . . . . . : 192.168.1.23
   Маска подсети . . . . . . . . . . : 255.255.255.0
   Основной шлюз. . . . . . . . . :

Адаптер Ethernet VMware Network Adapter VMnet1:

   DNS-суффикс подключения . . . . . :
   Локальный IPv6-адрес канала . . . : fe80::b853:e9:29ba:f446%15
   IPv4-адрес. . . . . . . . . . . . : 192.168.6.1
   Маска подсети . . . . . . . . . . : 255.255.255.0
   Основной шлюз. . . . . . . . . :

Адаптер Ethernet VMware Network Adapter VMnet8:

   DNS-суффикс подключения . . . . . :
   Локальный IPv6-адрес канала . . . : fe80::8d1e:c413:8edf:67e4%13
   IPv4-адрес. . . . . . . . . . . . : 192.168.111.1
   Маска подсети . . . . . . . . . . : 255.255.255.0
   Основной шлюз. . . . . . . . . :
```
**Linux**
```
vagrant@vagrant:~$ ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
        inet6 fe80::a00:27ff:fe73:60cf  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:73:60:cf  txqueuelen 1000  (Ethernet)
        RX packets 33450  bytes 42299871 (42.2 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 17332  bytes 1309522 (1.3 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 78  bytes 8138 (8.1 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 78  bytes 8138 (8.1 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```
```
vagrant@vagrant:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 53873sec preferred_lft 53873sec
    inet6 fe80::a00:27ff:fe73:60cf/64 scope link
       valid_lft forever preferred_lft forever
```


### 2.
Протокол LLDP. Команда ```lldpctl``` в составе пакета ```lldpd```


### 3.
Настройки подинтерфейсов VLAN'ов необходимо добавить в файл /etc/network/interfaces.  
Пример конфигурации:
```
auto vlan1400
iface vlan1400 inet static
        address 192.168.1.1
        netmask 255.255.255.0
        vlan_raw_device eth0
```
Или, если хочется использовать названия интерфейсов вида eth0.1400:
```
auto eth0.1400
iface eth0.1400 inet static
        address 192.168.1.1
        netmask 255.255.255.0
        vlan_raw_device eth0
```
Параметр ```vlan_raw_device``` указывает, на каком сетевом интерфейсе должен создаваться новый интерфейс vlan1400.  
Номер ```1400``` в данном случае указывает на то, какой VLAN ID должен использоваться.  
Настройка VLAN выполняется с помощью программы ```vconfig```  
Использование VLAN требует установленного пакета ```vlan```

### 4.  
BONDING - объединение сетевых интерфейсов для повышения отказоустойчивости и увеличения пропускной способности.  
Опции для балансировки нагрузки:  
```balance-rr```  
```balance-xor```  
```balance-tlb```  
```balance-alb```  
Настройки подинтерфейсов BOND'ов необходимо добавить в файл /etc/network/interfaces.  
Пример конфигурации:
```
auto bond0
iface bond0 inet static
        address 192.168.0.2
        netmask 255.255.255.0
        network 192.168.0.0
        broadcast 192.168.0.255
        gateway 192.168.0.1
        up /sbin/ifenslave bond0 eth0 eth1
        down /sbin/ifenslave -d bond0 eth0 eth1
```

### 5.  
Сеть с маской /29; Всего адресов 8, узловых 6
```
vagrant@vagrant:~$ ipcalc 10.10.10.0/29
Address:   10.10.10.0           00001010.00001010.00001010.00000 000
Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
=>
Network:   10.10.10.0/29        00001010.00001010.00001010.00000 000
HostMin:   10.10.10.1           00001010.00001010.00001010.00000 001
HostMax:   10.10.10.6           00001010.00001010.00001010.00000 110
Broadcast: 10.10.10.7           00001010.00001010.00001010.00000 111
Hosts/Net: 6                     Class A, Private Internet
```
Сеть с маской /24; Всего адресов 256, узловых 254
```
vagrant@vagrant:~$ ipcalc 10.10.10.0/24
Address:   10.10.10.0           00001010.00001010.00001010. 00000000
Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
=>
Network:   10.10.10.0/24        00001010.00001010.00001010. 00000000
HostMin:   10.10.10.1           00001010.00001010.00001010. 00000001
HostMax:   10.10.10.254         00001010.00001010.00001010. 11111110
Broadcast: 10.10.10.255         00001010.00001010.00001010. 11111111
Hosts/Net: 254                   Class A, Private Internet
```
Сеть с маской /24 можно разбить на 32 подсети с маской /29
Примеры:
```
vagrant@vagrant:~$ ipcalc 10.10.10.50/29
Address:   10.10.10.50          00001010.00001010.00001010.00110 010
Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
=>
Network:   10.10.10.48/29       00001010.00001010.00001010.00110 000
HostMin:   10.10.10.49          00001010.00001010.00001010.00110 001
HostMax:   10.10.10.54          00001010.00001010.00001010.00110 110
Broadcast: 10.10.10.55          00001010.00001010.00001010.00110 111
Hosts/Net: 6                     Class A, Private Internet
```
```
vagrant@vagrant:~$ ipcalc 10.10.10.100/29
Address:   10.10.10.100         00001010.00001010.00001010.01100 100
Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
=>
Network:   10.10.10.96/29       00001010.00001010.00001010.01100 000
HostMin:   10.10.10.97          00001010.00001010.00001010.01100 001
HostMax:   10.10.10.102         00001010.00001010.00001010.01100 110
Broadcast: 10.10.10.103         00001010.00001010.00001010.01100 111
Hosts/Net: 6                     Class A, Private Internet
```

### 6.  
Частные IP адреса берём из сети 100.64.0.0/10  
Маска диапазонов будет /26  
```
vagrant@vagrant:~$ ipcalc -b 100.64.0.0/10 -s 50
Address:   100.64.0.0
Netmask:   255.192.0.0 = 10
Wildcard:  0.63.255.255
=>
Network:   100.64.0.0/10
HostMin:   100.64.0.1
HostMax:   100.127.255.254
Broadcast: 100.127.255.255
Hosts/Net: 4194302               Class A

1. Requested size: 50 hosts
Netmask:   255.255.255.192 = 26
Network:   100.64.0.0/26
HostMin:   100.64.0.1
HostMax:   100.64.0.62
Broadcast: 100.64.0.63
Hosts/Net: 62                    Class A
...
```


### 7.
**Linux**
ARP таблица: ```arp -n```
Очистить ARP кэш: ```ip neigh flush all```
Удалить одну ARP кэш запись: ```arp -d <IP>```

**Windows**
ARP таблица: ```arp -a```
Очистить ARP кэш: ```netsh interface ip delete arpcache```
Удалить одну ARP кэш запись: ```arp -d <IP>```

