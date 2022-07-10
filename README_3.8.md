### 1.
```
route-views>show ip route 109.165.21.232
Routing entry for 109.165.0.0/18
  Known via "bgp 6447", distance 20, metric 0
  Tag 2497, type external
  Last update from 202.232.0.2 7w0d ago
  Routing Descriptor Blocks:
  * 202.232.0.2, from 202.232.0.2, 7w0d ago
      Route metric is 0, traffic share count is 1
      AS Hops 2
      Route tag 2497
      MPLS label: none
```
```
route-views>show bgp 109.165.21.232
BGP routing table entry for 109.165.0.0/18, version 2284504698
Paths: (24 available, best #22, table default)
  Not advertised to any peer
  Refresh Epoch 1
   4901 6079 1299 12389
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE0DDA67E88 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
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

