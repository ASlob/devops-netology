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
Результат в браузере: ![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen5.png)


### 4.  
Мой IP:  109.165.47.19, провайдер Ростелеком ![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen6.png)
AS12389 ![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen6.png)


### 5.  
```
vagrant@vagrant:~$ traceroute -IAn 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  10.0.2.2 [*]  0.260 ms  0.260 ms  0.252 ms
 2  192.168.1.1 [*]  1.036 ms  0.742 ms  0.562 ms
 3  178.34.128.50 [AS12389]  5.904 ms  5.998 ms  5.707 ms
 4  178.34.129.237 [AS12389]  5.794 ms  10.738 ms  10.446 ms
 5  185.140.148.153 [AS12389]  39.453 ms  39.162 ms  39.332 ms
 6  72.14.197.6 [AS15169]  30.921 ms  33.199 ms  32.377 ms
 7  108.170.250.129 [AS15169]  42.122 ms  41.832 ms  41.544 ms
 8  108.170.250.130 [AS15169]  40.962 ms  40.355 ms  40.833 ms
 9  142.251.238.84 [AS15169]  53.692 ms  53.871 ms  53.577 ms
10  142.251.238.68 [AS15169]  44.794 ms  44.500 ms  49.536 ms
11  216.239.58.67 [AS15169]  54.779 ms  54.476 ms  54.861 ms
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  8.8.8.8 [AS15169]  41.827 ms  42.075 ms  41.786 ms
```


### 6.  
Самое большое время задержки на участке ```AS15169  216.239.58.67```, среднее время задержки (Avg) = 56,4 ms ![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen7.png)   
Также происходит значительная потеря пакетов на участке ```AS12389  185.140.148.153```


### 7.
```
vagrant@vagrant:~$ dig +short NS dns.google
ns3.zdns.google.
ns1.zdns.google.
ns2.zdns.google.
ns4.zdns.google.
vagrant@vagrant:~$ dig +short A dns.google
8.8.4.4
8.8.8.8
```


### 8.
```
vagrant@vagrant:~$ dig -x 8.8.8.8

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.8.8
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 53747
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;8.8.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.   4935    IN      PTR     dns.google.

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Sun Jul 03 19:23:09 MSK 2022
;; MSG SIZE  rcvd: 73
```
```
vagrant@vagrant:~$ dig -x 8.8.4.4

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.4.4
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 52453
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;4.4.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
4.4.8.8.in-addr.arpa.   18102   IN      PTR     dns.google.

;; Query time: 48 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Sun Jul 03 19:25:06 MSK 2022
;; MSG SIZE  rcvd: 73
```
Ответ: dns.google.
