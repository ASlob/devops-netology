# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

---

## Решение к Задаче 1

`docker-compos.yml`

```yaml
version: '3'
services:
 db:
   container_name: pgsql12
   image: postgres:12
   environment:
     POSTGRES_USER: slowback
     POSTGRES_PASSWORD: 111111
     POSTGRES_DB: new_db
   ports:
     - "5432:5432"
   volumes:      
     - db_volume:/home/user/database/
     - backup_volume:/home/user/backup/

volumes:
 db_volume:
 backup_volume:

```

## Задача 2

В БД из задачи 1:

- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:

- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:

- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:

- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

---

## Решение к Задаче 2

> - итоговый список БД после выполнения пунктов выше,

```bash
test_db=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 new_db    | slowback | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | slowback | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | slowback | UTF8     | en_US.utf8 | en_US.utf8 | =c/slowback          +
           |          |          |            |            | slowback=CTc/slowback
 template1 | slowback | UTF8     | en_US.utf8 | en_US.utf8 | =c/slowback          +
           |          |          |            |            | slowback=CTc/slowback
 test_db   | slowback | UTF8     | en_US.utf8 | en_US.utf8 |
(5 rows)
```

>- описание таблиц (describe)

```bash
test_db=# \d orders
                               Table "public.orders"
    Column    |  Type   | Collation | Nullable |              Default
--------------+---------+-----------+----------+------------------------------------
 id           | integer |           | not null | nextval('orders_id_seq'::regclass)
 наименование | text    |           |          |
 цена         | integer |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```

```bash
test_db=# \d clients
                                  Table "public.clients"
      Column       |  Type   | Collation | Nullable |               Default

-------------------+---------+-----------+----------+---------------------------------
----
 id                | integer |           | not null | nextval('clients_id_seq'::regcla
ss)
 фамилия           | text    |           |          |
 страна проживания | text    |           |          |
 заказ             | integer |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "country_index" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```

>- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```sql
SELECT 
    grantee, table_catalog, table_name, privilege_type 
FROM 
    information_schema.table_privileges 
WHERE 
    table_name in ('orders','clients');
```

>- список пользователей с правами над таблицами test_db

```bash
test_db=# SELECT grantee, table_catalog, table_name, privilege_type FROM information_schema.table_privileges WHERE table_name IN ('orders','clients');
     grantee      | table_catalog | table_name | privilege_type
------------------+---------------+------------+----------------
 slowback         | test_db       | orders     | INSERT
 slowback         | test_db       | orders     | SELECT
 slowback         | test_db       | orders     | UPDATE
 slowback         | test_db       | orders     | DELETE
 slowback         | test_db       | orders     | TRUNCATE
 slowback         | test_db       | orders     | REFERENCES
 slowback         | test_db       | orders     | TRIGGER
 test_admin_user  | test_db       | orders     | INSERT
 test_admin_user  | test_db       | orders     | SELECT
 test_admin_user  | test_db       | orders     | UPDATE
 test_admin_user  | test_db       | orders     | DELETE
 test_admin_user  | test_db       | orders     | TRUNCATE
 test_admin_user  | test_db       | orders     | REFERENCES
 test_admin_user  | test_db       | orders     | TRIGGER
 test_simple_user | test_db       | orders     | INSERT
 test_simple_user | test_db       | orders     | SELECT
 test_simple_user | test_db       | orders     | UPDATE
 test_simple_user | test_db       | orders     | DELETE
 slowback         | test_db       | clients    | INSERT
 slowback         | test_db       | clients    | SELECT
 slowback         | test_db       | clients    | UPDATE
 slowback         | test_db       | clients    | DELETE
 slowback         | test_db       | clients    | TRUNCATE
 slowback         | test_db       | clients    | REFERENCES
 slowback         | test_db       | clients    | TRIGGER
 test_admin_user  | test_db       | clients    | INSERT
 test_admin_user  | test_db       | clients    | SELECT
 test_admin_user  | test_db       | clients    | UPDATE
 test_admin_user  | test_db       | clients    | DELETE
 test_admin_user  | test_db       | clients    | TRUNCATE
 test_admin_user  | test_db       | clients    | REFERENCES
 test_admin_user  | test_db       | clients    | TRIGGER
 test_simple_user | test_db       | clients    | INSERT
 test_simple_user | test_db       | clients    | SELECT
 test_simple_user | test_db       | clients    | UPDATE
 test_simple_user | test_db       | clients    | DELETE
(36 rows)
```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:

- вычислите количество записей для каждой таблицы
- приведите в ответе:
  - запросы
  - результаты их выполнения.

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

Подсказк - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
