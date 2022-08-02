### 1.
![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen8.png)


### 2.
![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen9.png)


### 3.
```
vagrant@vagrant:~$ sudo systemctl status apache2
● apache2.service - The Apache HTTP Server
     Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2022-07-18 19:26:56 UTC; 23s ago
       Docs: https://httpd.apache.org/docs/2.4/
   Main PID: 20082 (apache2)
      Tasks: 55 (limit: 1071)
     Memory: 5.6M
     CGroup: /system.slice/apache2.service
             ├─20082 /usr/sbin/apache2 -k start
             ├─20083 /usr/sbin/apache2 -k start
             └─20084 /usr/sbin/apache2 -k start
Jul 18 19:26:56 vagrant systemd[1]: Starting The Apache HTTP Server...
Jul 18 19:26:56 vagrant systemd[1]: Started The Apache HTTP Server.
```
```
vagrant@vagrant:~$ sudo a2enmod ssl
Considering dependency setenvif for ssl:
Module setenvif already enabled
Considering dependency mime for ssl:
Module mime already enabled
Considering dependency socache_shmcb for ssl:
Enabling module socache_shmcb.
Enabling module ssl.
See /usr/share/doc/apache2/README.Debian.gz on how to configure SSL and create self-signed certificates.
To activate the new configuration, you need to run:
  systemctl restart apache2
```
```
vagrant@vagrant:~$ sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt
Generating a RSA private key
.....................................................+++++
.............+++++
writing new private key to '/etc/ssl/private/apache-selfsigned.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:RF
State or Province Name (full name) [Some-State]:RO
Locality Name (eg, city) []:Vlgd
Organization Name (eg, company) [Internet Widgits Pty Ltd]:MyCompany
Organizational Unit Name (eg, section) []:Management
Common Name (e.g. server FQDN or YOUR name) []:www.MyCompany.com
Email Address []:inbox@mycompany.com
```
```
vagrant@vagrant:~$ sudo mkdir -p /var/www/mycompany.com/public_html
```
```
vagrant@vagrant:~$ sudo nano /var/www/mycompany.com/public_html/index.html
<html>
  <head>
    <title>Welcome to MyCompany.com!</title>
  </head>
  <body>
    <h1>Success!  The MyCompany.com virtual host is working!</h1>
  </body>
</html>
```
```
vagrant@vagrant:~$ sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/mycompany.com.conf
```
```
vagrant@vagrant:~$ sudo nano /etc/apache2/sites-available/mycompany.com.conf
<VirtualHost *:443>
        ServerName mycompany.com
        ServerAlias www.mycompany.com
        ServerAdmin admin@mycompany.com
        DocumentRoot /var/www/mycompany.com/public_html
	DirectoryIndex index.html
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
	SSLEngine on   
	SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt   
	SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>
```
```
vagrant@vagrant:~$ sudo a2dissite 000-default.conf
Site 000-default disabled.
To activate the new configuration, you need to run:
  systemctl reload apache2
vagrant@vagrant:~$ sudo a2ensite mycompany.com.conf
Enabling site mycompany.com.
To activate the new configuration, you need to run:
  systemctl reload apache2
vagrant@vagrant:~$ sudo systemctl reload apache2
```
В файл ```hosts``` на локальной машине добавил строку ```127.0.0.1 mycompany.com```
  
Результат: ![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen10.png)


### 4.  
```
vagrant@vagrant:~$ git clone --depth 1 https://github.com/drwetter/testssl.sh.git
Cloning into 'testssl.sh'...
remote: Enumerating objects: 104, done.
remote: Counting objects: 100% (104/104), done.
remote: Compressing objects: 100% (97/97), done.
remote: Total 104 (delta 15), reused 32 (delta 6), pack-reused 0
Receiving objects: 100% (104/104), 8.57 MiB | 2.65 MiB/s, done.
Resolving deltas: 100% (15/15), done.
vagrant@vagrant:~$ cd testssl.sh
```
```
vagrant@vagrant:~/testssl.sh$ ./testssl.sh -e --fast --parallel https://www.yandex.ru/
```
Результат: ![Result](https://github.com/ASlob/devops-netology/tree/main/txt/result1.txt)
```
vagrant@vagrant:~/testssl.sh$ ./testssl.sh -U --sneaky https://www.yandex.ru/
```
Результат: ![Result](https://github.com/ASlob/devops-netology/tree/main/txt/result2.txt)


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
