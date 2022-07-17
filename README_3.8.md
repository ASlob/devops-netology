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
```
vagrant@vagrant:~$ sudo modprobe -v dummy numdummies=1
insmod /lib/modules/5.4.0-80-generic/kernel/drivers/net/dummy.ko numdummies=0 numdummies=1
```
```
vagrant@vagrant:~$ ifconfig -a | grep dummy
dummy0: flags=130<BROADCAST,NOARP>  mtu 1500
```
```
vagrant@vagrant:~$ sudo ip addr add 192.168.1.50/24 dev dummy0
vagrant@vagrant:~$ sudo ip addr add 192.168.1.100/24 dev dummy0
```
```
vagrant@vagrant:~$ ip a | grep dummy
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
    inet 192.168.1.50/24 scope global dummy0
    inet 192.168.1.100/24 scope global secondary dummy0
```


### 3.
```
vagrant@vagrant:~$ sudo netstat -ntlp | grep LISTEN
tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      1/init
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      612/systemd-resolve
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1404/sshd: /usr/sbi
tcp6       0      0 :::111                  :::*                    LISTEN      1/init
tcp6       0      0 :::22                   :::*                    LISTEN      1404/sshd: /usr/sbi
```
53 порт использует systemd-resolve (DNS)  
22 порт использует sshd  


### 4.  
```
vagrant@vagrant:~$ sudo ss -lupn
State       Recv-Q      Send-Q            Local Address:Port           Peer Address:Port      Process
UNCONN      0           0                 127.0.0.53%lo:53                  0.0.0.0:*          users:(("systemd-resolve",pid=612,fd=12))
UNCONN      0           0                10.0.2.15%eth0:68                  0.0.0.0:*          users:(("systemd-network",pid=410,fd=19))
UNCONN      0           0                       0.0.0.0:111                 0.0.0.0:*          users:(("rpcbind",pid=611,fd=5),("systemd",pid=1,fd=96))
UNCONN      0           0                          [::]:111                    [::]:*          users:(("rpcbind",pid=611,fd=7),("systemd",pid=1,fd=98))
```
53 порт использует systemd-resolve (DNS)  
68 порт использует systemd-network (DHCP)  


### 5.  

![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/MyNet.png)
