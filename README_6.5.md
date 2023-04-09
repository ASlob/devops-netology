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

## Задача 2

В этом задании вы научитесь:

- создавать и удалять индексы,
- изучать состояние кластера,
- обосновывать причину деградации доступности данных.

Ознакомьтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html)
и добавьте в `Elasticsearch` 3 индекса в соответствии с таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API, и **приведите в ответе** на задание.

Получите состояние кластера `Elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?

Удалите все индексы.

### Важно

При проектировании кластера Elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

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
