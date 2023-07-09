# Домашнее задание к занятию 5. «Elasticsearch»

## Решение к Задаче 1

> В ответе приведите:
>
> - текст Dockerfile-манифеста,

```yml
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
vagrant@VM2:~$ curl -XGET 'localhost:9200'
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "DfuZDSXpSn6BEGjri8C1_g",
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

> Ознакомьтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) и добавьте в `Elasticsearch` 3 индекса в соответствии с таблицей:
>
> | Имя | Количество реплик | Количество шард |
> |-----|-------------------|-----------------|
> | ind-1| 0 | 1 |
> | ind-2 | 1 | 2 |
> | ind-3 | 2 | 4 |

```bash
vagrant@VM2:~$ curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
vagrant@VM2:~$ curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
vagrant@VM2:~$ curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}'
```

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

> Создайте директорию `{путь до корневой директории с Elasticsearch в образе}/snapshots`.

```bash
[root@0cde4fdd1499 elasticsearch]# mkdir /home/elasticsearch/snapshots
[root@0cde4fdd1499 elasticsearch]# chown elasticsearch:elasticsearch /home/elasticsearch/snapshots
[root@0cde4fdd1499 elasticsearch]# echo "  repo: /home/elasticsearch/snapshots" >> /etc/elasticsearch/elasticsearch.yml
```

> Используя API, [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository)
> эту директорию как `snapshot repository` c именем `netology_backup`.
> **Приведите в ответе** запрос API и результат вызова API для создания репозитория.

```bash
vagrant@VM2:~$ curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d '{"type": "fs","settings": {"location": "/home/elasticsearch/snapshots"}}'
{
  "acknowledged" : true
}
vagrant@VM2:~$ curl -X GET 'http://localhost:9200/_snapshot/netology_backup?pretty'
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/home/elasticsearch/snapshots"
    }
  }
}
```

> Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```bash
vagrant@VM2:~$ curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}
```

```bash
vagrant@VM2:~$ curl -X GET 'http://localhost:9200/test?pretty'
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1688910846474",
        "number_of_replicas" : "0",
        "uuid" : "yr-9TRAFS1O2hn6GvhyaqQ",
        "version" : {
          "created" : "7140099"
        }
      }
    }
  }
}
```

> [Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) состояния кластера `Elasticsearch`.

```bash
vagrant@VM2:~$ curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
{"snapshot":{"snapshot":"elasticsearch","uuid":"n-1OaSV6RSGi7lghK9ZV1g","repository":"netology_backup","version_id":7140099,"version":"7.14.0","indices":["test",".geoip_databases"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2023-07-09T14:00:41.889Z","start_time_in_millis":1688911241889,"end_time":"2023-07-09T14:00:43.617Z","end_time_in_millis":1688911243617,"duration_in_millis":1728,"failures":[],"shards":{"total":2,"failed":0,"successful":2},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]}]}}
```

> **Приведите в ответе** список файлов в директории со `snapshot`.

```bash
[root@0cde4fdd1499 snapshots]# ls -la
total 56
drwxr-xr-x 3 elasticsearch elasticsearch  4096 Jul  9 14:00 .
drwx------ 1 elasticsearch elasticsearch  4096 Jul  9 12:47 ..
-rw-r--r-- 1 elasticsearch elasticsearch   831 Jul  9 14:00 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Jul  9 14:00 index.latest
drwxr-xr-x 4 elasticsearch elasticsearch  4096 Jul  9 14:00 indices
-rw-r--r-- 1 elasticsearch elasticsearch 27650 Jul  9 14:00 meta-n-1OaSV6RSGi7lghK9ZV1g.dat
-rw-r--r-- 1 elasticsearch elasticsearch   440 Jul  9 14:00 snap-n-1OaSV6RSGi7lghK9ZV1g.dat
```

> Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```bash
vagrant@VM2:~$ curl -X DELETE 'http://localhost:9200/test?pretty'
{
  "acknowledged" : true
}
vagrant@VM2:~$ curl -X PUT localhost:9200/test-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
```

```bash
vagrant@VM2:~$ curl -X GET http://localhost:9200/_cat/indices?v
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases xDZMYiotRWmMGpVFVrtXRA   1   0         41           43     42.1mb         42.1mb
green  open   test-2           fQUj6Q08T8y0GM4PdyPNFg   1   0          0            0       208b           208b
```

> [Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние кластера `Elasticsearch` из `snapshot`, созданного ранее.
> **Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```bash
vagrant@VM2:~$ curl -X POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty -H 'Content-Type: application/json' -d'{"include_global_state":true}'
{
  "accepted" : true
}
```

```bash
vagrant@VM2:~$ curl -X GET http://localhost:9200/_cat/indices?vackup/elastics
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases rdfeWOj_RwKFNTEj3Xo9DQ   1   0         41           43     42.1mb         42.1mb
green  open   test-2           fQUj6Q08T8y0GM4PdyPNFg   1   0          0            0       208b           208b
green  open   test             VZk50RZITD-Galv_1fydhA   1   0          0            0       208b           208b
```
