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


