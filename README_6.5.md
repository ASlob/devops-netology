# Домашнее задание к занятию 5. «Elasticsearch»

## Решение к Задаче 1

> В ответе приведите:
>
> - текст Dockerfile-манифеста,

```bash
FROM centos:7
MAINTAINER slow.back@yandex.ru
RUN groupadd elasticsearch
RUN useradd elasticsearch -g elasticsearch -p elasticsearch
RUN yum -y update
RUN yum clean all
RUN yum -y install perl-Digest-SHA
RUN yum -y install java-11-openjdk
RUN yum -y install wget
WORKDIR /opt/elasticsearch
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.14.0-x86_64.rpm
RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.14.0-x86_64.rpm.sha512
RUN sha512sum -c elasticsearch-7.14.0-x86_64.rpm.sha512
RUN rpm --install elasticsearch-7.14.0-x86_64.rpm
RUN mkdir /usr/share/elasticsearch/config
COPY elasticsearch.yml /etc/elasticsearch
COPY log4j2.properties /etc/elasticsearch
RUN cp -R /usr/share/elasticsearch/* /home/elasticsearch/
RUN chown -R elasticsearch:elasticsearch /home/elasticsearch/*
RUN chown elasticsearch:elasticsearch /var/lib/elasticsearch
RUN chown elasticsearch:elasticsearch /var/log/elasticsearch
WORKDIR /home/elasticsearch
USER elasticsearch
EXPOSE 9200
EXPOSE 9300
CMD ["/home/elasticsearch/bin/elasticsearch"]
```

> - ссылку на образ в репозитории dockerhub,

[ссылка на образ](https://hub.docker.com/r/slowback/elastic/tags)

> - ответ `Elasticsearch` на запрос пути `/` в json-виде.

```bash
[elasticsearch@66f9560565db ~]$ curl -XGET 'localhost:9200'
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "CVGzgC0ET2CfAmaeWi7TAw",
  "version" : {
    "number" : "7.14.0",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "dd5a0a2acaa2045ff9624f3729fc8a6f40835aa1",
    "build_date" : "2021-07-29T20:49:32.864135063Z",
    "build_snapshot" : false,
    "lucene_version" : "8.9.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

## Решение к Задаче 2

> Получите список индексов и их статусов, используя API, и **приведите в ответе** на задание.

```bash
vagrant@VM2:~$ curl http://localhost:9200/_cat/indices
green  open .geoip_databases xDZMYiotRWmMGpVFVrtXRA 1 0 42 39 40.6mb 40.6mb
green  open ind-1            t85liETQSnyR2bHxpyMcCQ 1 0  0  0   208b   208b
yellow open ind-3            1Ms3qegNR_a9XeGSNoYQOA 4 2  0  0   832b   832b
yellow open ind-2            TWQUaSJhT8-O5PEaPDZQZw 2 1  0  0   416b   416b
```

> Получите состояние кластера `Elasticsearch`, используя API.

```bash
vagrant@VM2:~$ curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```

> Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?

Кластер помечает индексы Yellow потому что их некуда реплицировать (нода только одна).

> Удалите все индексы.

```bash
vagrant@VM2:~$ curl -ku elastic  -X DELETE localhost:9200/ind-1
Enter host password for user 'elastic':
{"acknowledged":true}
```

```bash
vagrant@VM2:~$ curl -ku elastic  -X DELETE localhost:9200/ind-2
Enter host password for user 'elastic':
{"acknowledged":true}
```

```bash
vagrant@VM2:~$ curl -ku elastic  -X DELETE localhost:9200/ind-3
Enter host password for user 'elastic':
{"acknowledged":true}
```

## Задача 3

В этом задании вы научитесь:

- создавать бэкапы данных,
- восстанавливать индексы из бэкапов.

Создайте директорию `{путь до корневой директории с Elasticsearch в образе}/snapshots`.

Используя API, [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository)
эту директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html)
состояния кластера `Elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `Elasticsearch` из `snapshot`, созданного ранее.

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:

- возможно, вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `Elasticsearch`.

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
