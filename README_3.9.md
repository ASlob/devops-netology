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
```
vagrant@VM1:~$ sudo systemctl status sshd.service
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2022-07-31 05:47:36 UTC; 5h 45min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 803 (sshd)
      Tasks: 1 (limit: 1071)
     Memory: 6.8M
     CGroup: /system.slice/ssh.service
             └─803 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
....
```
```
vagrant@VM1:~$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/vagrant/.ssh/id_rsa): key
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in key
Your public key has been saved in key.pub
....
```
```
vagrant@VM1:~$ ssh-copy-id -i ~/key.pub vagrant@192.168.1.27
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/key.pub"
The authenticity of host '192.168.1.27 (192.168.1.27)' can't be established.
ECDSA key fingerprint is SHA256:wSHl+h4vAtTT7mbkj2lbGyxWXWTUf6VUliwpncjwLPM.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
vagrant@192.168.1.27's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'vagrant@192.168.1.27'"
and check to make sure that only the key(s) you wanted were added.
```
```
vagrant@VM1:~$ ssh vagrant@192.168.1.27
vagrant@192.168.1.27's password:
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)
....
vagrant@VM2:~$
```
```
vagrant@VM2:~$ logout
Connection to 192.168.1.27 closed.
```
```
vagrant@VM1:~$ ssh -i ~/key vagrant@192.168.1.27
Enter passphrase for key '/home/vagrant/key':
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)
...
vagrant@VM2:~$
```


### 6.
```
vagrant@VM1:~$ mv key newkey
vagrant@VM1:~$ mv key.pub newkey.pub
```
```
vagrant@VM1:~$ nano ~/.ssh/config
```
```
Host VM2
    Hostname 192.168.1.27
    IdentityFile ~/newkey
```
```
vagrant@VM1:~$ ssh VM2
Enter passphrase for key '/home/vagrant/newkey':
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)
...
vagrant@VM2:~$
```


### 7.
```
vagrant@VM1:~$ sudo tcpdump -i eth1 -c 100 -w dump.pcap
tcpdump: listening on eth1, link-type EN10MB (Ethernet), capture size 262144 bytes
100 packets captured
104 packets received by filter
0 packets dropped by kernel
vagrant@VM1:~$ ls
dump.pcap  newkey  newkey.pub
```
![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen11.png)
