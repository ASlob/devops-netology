# Домашнее задание к занятию 4. «PostgreSQL»

## Решение к Задаче 1

> Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
> Подключитесь к БД PostgreSQL, используя `psql`.
> Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.
> **Найдите и приведите** управляющие команды для:
>
> - вывода списка БД,
> - подключения к БД,
> - вывода списка таблиц,
> - вывода описания содержимого таблиц,
>- выхода из psql.
=======
>**Найдите и приведите** управляющие команды для:
>
>- вывода списка БД,

`\l[+]   [PATTERN]`

>- подключения к БД,

`\conninfo`

>- вывода списка таблиц,

`\d[S+]`

>- вывода описания содержимого таблиц,

`\d[S+]  NAME`

>- выхода из psql.

`\q`

## Задача 2

Используя `psql`, создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders`
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления, и полученный результат.

---

## Решение к Задаче 2

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили
провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.

Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?

## Задача 4

Используя утилиту `pg_dump`, создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---

# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

---

## Решение к Задаче 1

> Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

```sql
mysql> \s
--------------
mysql  Ver 8.0.31 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          11
Current database:       test_db
Current user:           slowback@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.31 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 5 min 27 sec

Threads: 2  Questions: 50  Slow queries: 0  Opens: 167  Flush tables: 3  Open tables: 85  Queries per second avg: 0.152
--------------
```

> **Приведите в ответе** количество записей с `price` > 300.

```sql
mysql> SELECT * FROM orders WHERE price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.02 sec)
```

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:

- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней
- количество попыток авторизации - 3
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
  - Фамилия "Pretty"
  - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и
**приведите в ответе к задаче**.

---

## Решение к Задаче 2

>Создайте пользователя test в БД c паролем test-pass, используя:
>
>- плагин авторизации mysql_native_password
>- срок истечения пароля - 180 дней
>- количество попыток авторизации - 3
>- максимальное количество запросов в час - 100
>- аттрибуты пользователя:
>   - Фамилия "Pretty"
>   - Имя "James"

```sql
mysql> CREATE USER 'test'@'localhost'
    -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> WITH MAX_CONNECTIONS_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2
    -> ATTRIBUTE '{"first_name":"James", "last_name":"Pretty"}';
Query OK, 0 rows affected (2.94 sec)
```

> Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

```sql
mysql> GRANT SELECT ON test_db.* TO test@localhost;
Query OK, 0 rows affected, 1 warning (0.98 sec)
```

> Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и
**приведите в ответе к задаче**.

```sql
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER = 'test';
+------+-----------+------------------------------------------------+
| USER | HOST      | ATTRIBUTE                                      |
+------+-----------+------------------------------------------------+
| test | localhost | {"last_name": "Pretty", "first_name": "James"} |
+------+-----------+------------------------------------------------+
1 row in set (0.97 sec)
```

```sql
mysql> SELECT User, max_questions, password_lifetime, User_attributes  FROM mysql.user where user='test';
+------+---------------+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
| User | max_questions | password_lifetime | User_attributes                                                                                                                              |
+------+---------------+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
| test |             0 |               180 | {"metadata": {"last_name": "Pretty", "first_name": "James"}, "Password_locking": {"failed_login_attempts": 3, "password_lock_time_days": 2}} |
+------+---------------+-------------------+----------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:

- на `MyISAM`
- на `InnoDB`

---

## Решение к Задаче 3

>Установите профилирование `SET profiling = 1`.  
>Изучите вывод профилирования команд `SHOW PROFILES;`.

```sql
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.03 sec)

mysql> SHOW PROFILES;
+----------+------------+-------------------+
| Query_ID | Duration   | Query             |
+----------+------------+-------------------+
|        1 | 0.00028800 | SET profiling = 1 |
+----------+------------+-------------------+
1 row in set, 1 warning (0.00 sec)
```

>Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

```sql
mysql> use test_db;
Database changed
mysql> SELECT table_schema,table_name,engine FROM information_schema.tables WHERE table_schema = DATABASE();
+--------------+------------+--------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE |
+--------------+------------+--------+
| test_db      | orders     | InnoDB |
+--------------+------------+--------+
1 row in set (0.02 sec)
```

>Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
>
>- на `MyISAM`
>- на `InnoDB`

```sql
mysql> use test_db;
Database changed
mysql> ALTER TABLE orders ENGINE=MyISAM;
Query OK, 5 rows affected (15.27 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+-------------+----------------------------------+
| Query_ID | Duration    | Query                            |
+----------+-------------+----------------------------------+
|        1 |  0.00037500 | SELECT DATABASE()                |
|        2 | 15.28424625 | ALTER TABLE orders ENGINE=MyISAM |
+----------+-------------+----------------------------------+
2 rows in set, 1 warning (0.00 sec)

mysql> SELECT table_schema,table_name,engine FROM information_schema.tables WHERE table_schema = DATABASE();
+--------------+------------+--------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE |
+--------------+------------+--------+
| test_db      | orders     | MyISAM |
+--------------+------------+--------+
1 row in set (0.02 sec)

mysql> ALTER TABLE orders ENGINE=InnoDB;
Query OK, 5 rows affected (7.89 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+-------------+------------------------------------------------------------------------------------------------------+
| Query_ID | Duration    | Query                                                                                                |
+----------+-------------+------------------------------------------------------------------------------------------------------+
|        1 |  0.00045975 | SELECT DATABASE()                                                                                    |
|        2 | 15.28424625 | ALTER TABLE orders ENGINE=MyISAM                                                                     |
|        3 |  0.01832725 | SELECT table_schema,table_name,engine FROM information_schema.tables WHERE table_schema = DATABASE() |
|        4 |  7.91136775 | ALTER TABLE orders ENGINE=InnoDB                                                                     |
+----------+-------------+------------------------------------------------------------------------------------------------------+
4 rows in set, 1 warning (0.00 sec)

mysql> SELECT table_schema,table_name,engine FROM information_schema.tables WHERE table_schema = DATABASE();
+--------------+------------+--------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE |
+--------------+------------+--------+
| test_db      | orders     | InnoDB |
+--------------+------------+--------+
1 row in set (0.01 sec)
```

## Задача 4

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):

- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

---

## Решение к Задаче 4

>Изучите файл `my.cnf` в директории /etc/mysql.
>
>Измените его согласно ТЗ (движок InnoDB):
>
>- Скорость IO важнее сохранности данных
>- Нужна компрессия таблиц для экономии места на диске
>- Размер буффера с незакомиченными транзакциями 1 Мб
>- Буффер кеширования 30% от ОЗУ
>- Размер файла логов операций 100 Мб
>
>Приведите в ответе измененный файл `my.cnf`

```bash

bash-4.4# cat my.cnf

# For advice on how to change settings please see

# <http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html>

[mysqld]

#

# Remove leading # and set to the amount of RAM for the most important data

# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%

# innodb_buffer_pool_size = 128M

#

# Remove leading # to turn on a very important data integrity option: logging

# changes to the binary log between backups

# log_bin

#

# Remove leading # to set options mainly useful for reporting servers

# The server defaults are faster for transactions and fast SELECTs

# Adjust sizes as needed, experiment to find the optimal values

# join_buffer_size = 128M

# sort_buffer_size = 2M

# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin

# this will increase compatibility with older clients. For background, see

# <https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin>

# default-authentication-plugin=mysql_native_password

skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

pid-file=/var/run/mysqld/mysqld.pid
[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/

innodb_flush_log_at_trx_commit  = 0
innodb_file_format              = Barracuda
innodb_log_buffer_size          = 1M
key_buffer_size                 = 333M
innodb_log_file_size            = 100M

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
