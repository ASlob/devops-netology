# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на <https://hub.docker.com>;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:

```html
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```

Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на <https://hub.docker.com/username_repo>.

---

## РЕШЕНИЕ к задаче 1

[ССЫЛКА НА ОБРАЗ](https://hub.docker.com/layers/slowback/nginx/latest/images/sha256-1ec87efba992d60ca80f97b31356f801323086cdbad8ef83aac57698cb31cea5?context=explore)

---

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

---

## РЕШЕНИЕ к задаче 2

> - Высоконагруженное монолитное java веб-приложение;

Виртуальная машина, возможно быстрое масштабирование под пиковые нагрузки и нет простоя мощностей.

> - Nodejs веб-приложение;

Контейнеризация, позволяет быстро развернуть приложение вместе с его окружением и всеми зависимостями, подходит для разработки. Для продакшена - виртуализация.

> - Мобильное приложение c версиями для Android и iOS;

В процессе разработки приложения раварачиваются на симмуляторах/эмуляторах, виртуальных машинах, а при качественном ручном тестировании на физических девайсах различных производителей с разными версиями ОС.

> - Шина данных на базе Apache Kafka;

Всё зависит от количества перерабатываемых данных. Для малонагруженных шин данных и тестирования подойдёт контениризация или виртуальные машины. Для высокопроизводительных шин данных дата-центров - физические сервера с выделенным сетевым контуром под Kafka.

> - Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;

Если ELK устанавливается непосредственно на виртуальную машину, то необходимо будет рассмотреть некоторые проблемы с оркестровкой служб и согласованностью конфигурации. Обновление и откат услуг во время более поздней эксплуатации и технического обслуживания будут проблематичными. Если использовать docker для сборки, то можно управлять всем кластером, например через swarm, что принесет множество полезных функций.

> - Мониторинг-стек на базе Prometheus и Grafana;

Под данный сценарий подойдёт контейнеризация, т.к. Prometheus и Grafana не хранят данные.

> - MongoDB, как основное хранилище данных для java-приложения;

Физический сервер либо виртуальная машина. Выбор зависит от нагруженности самого java-приложения.

> - Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

Под данный сценарий подойдёт контейнеризация, под управлением Docker Compose. Данный способ упрощает миграцию с одних мощностей на другие и даёт дополнительные возможности управления.

---

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

---

## РЕШЕНИЕ к задаче 3

```shell
user@linserv://$ docker pull centos
Using default tag: latest
latest: Pulling from library/centos
a1d0c7532777: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
docker.io/library/centos:latest

user@linserv://$ docker pull debian
Using default tag: latest
latest: Pulling from library/debian
f606d8928ed3: Pull complete
Digest: sha256:e538a2f0566efc44db21503277c7312a142f4d0dedc5d2886932b92626104bff
Status: Downloaded newer image for debian:latest
docker.io/library/debian:latest

user@linserv://$ docker images
REPOSITORY       TAG       IMAGE ID       CREATED         SIZE
slowback/nginx   latest    cf10aa91138a   3 days ago      142MB
nginx            latest    51086ed63d8c   2 weeks ago     142MB
debian           latest    d91720f514f7   2 weeks ago     124MB
hello-world      latest    feb5d9fea6a5   13 months ago   13.3kB
centos           latest    5d0da3dc9764   13 months ago   231MB

user@linserv://$ docker run -it --rm -d --name centos -v /data:/data centos:latest
7f78cc914ef9ea04840d2665e75262eb49ef2a3e7db35bb9c9c343eb722d5691

user@linserv://$ docker ps
CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS         PORTS     NAMES
7f78cc914ef9   centos:latest   "/bin/bash"   12 seconds ago   Up 7 seconds             centos

user@linserv://$ docker run -it --rm -d --name debian -v /data:/data debian:latest
af44101a60304139c97c7182305997c077cbb2481f5d12e156ac95e23ff559a6

user@linserv://$ docker ps
CONTAINER ID   IMAGE           COMMAND       CREATED              STATUS              PORTS     NAMES
af44101a6030   debian:latest   "bash"        21 seconds ago       Up 17 seconds                 debian
7f78cc914ef9   centos:latest   "/bin/bash"   About a minute ago   Up About a minute             centos

user@linserv://$ docker exec -it centos /bin/bash
[root@7f78cc914ef9 /]# touch /data/centos.txt
[root@7f78cc914ef9 /]# ls /data
centos.txt
[root@7f78cc914ef9 /]# exit
exit

user@linserv://$ sudo touch /data/host.txt
[sudo] password for user:

user@linserv://$ docker exec -it debian /bin/bash
root@af44101a6030:/# ls /data
centos.txt  host.txt
root@af44101a6030:/# exit
exit
```
