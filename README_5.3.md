<div id="readme" class="Box-body readme blob js-code-block-container p-5 p-xl-6 gist-border-0">
<article class="markdown-body entry-content container-lg" itemprop="text">
<h1 dir="auto"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"></svg></a>Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"</h1>
<h2 dir="auto"><a id="user-content-задача-1" class="anchor" aria-hidden="true" href="#задача-1"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"></svg></a>Задача 1</h2>
Сценарий выполения задачи:
<ul dir="auto">
<li>создайте свой репозиторий на https://hub.docker.com;</li>
<li>выберете любой образ, который содержит веб-сервер Nginx;</li>
<li>создайте свой fork образа;</li>
<li>реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:</li>
</ul>

```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.
<ins>Ответ:</ins> Iaac позваляет описывать систему ввиде кода, что позваляет быстро развернуть систему и в дальнейшем избежать дрейфа конфигурации. Так же из приемуществ можно выделить удобная масштабируемость, бэкапирование, поиск ошибок, стандартизация. Iaac вобрал в себя все приемущества при работе с кодом.
<ul dir="auto">
<li>Какой из принципов IaaC является основополагающим?</li>
</ul>
<ins>Ответ:</ins> Идемпоте́нтность — свойство объекта или операции при повторном применении операции к объекту давать тот же результат, что и при первом.
<hr>
<h2 dir="auto"><a id="user-content-задача-2" class="anchor" aria-hidden="true" href="#задача-2"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"></svg></a>Задача 2</h2>
<ul dir="auto">
<li>Чем Ansible выгодно отличается от других систем управление конфигурациями?</li>
</ul>
<ins>Ответ:</ins> Не требует установки клиентской части, имеет систему оповещений, поддерживает работу с сетевыми устройствами по SSH или WinRM.
<ul dir="auto">
<li>Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?</li>
</ul>
<ins>Ответ:</ins> У каждого метода есть свои плюсы и минусы. Некоторые задачи легче осуществить с одним и сложнее — с другим, ну а при построении более сложных систем используется гибридный метод. Однако я бы выбрал Push-метод при условии, что управляющий кластер максимально будет защищён от несанкционированного доступа.
<hr>
<h2 dir="auto"><a id="user-content-задача-3" class="anchor" aria-hidden="true" href="#задача-3"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"></svg></a>Задача 3</h2>
<p dir="auto">Установить на личный компьютер:</p>
<ul dir="auto">
<li>VirtualBox</li>
<li>Vagrant</li>
<li>Ansible</li>
</ul>
<p dir="auto"><em>Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.</em></p>

```
C:\Program Files\Oracle\VirtualBox>vboxmanage.exe --version
6.1.34rlS0636
```
```
C:\>vagrant --version
Vagrant 2.2.19
```
```
vagrant@VM1:~$ ansible --version
ansible 2.9.6
```
<hr>
<h2 dir="auto"><a id="user-content-задача-4-" class="anchor" aria-hidden="true" href="#задача-4-"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"></svg></a>Задача 4 (*)</h2>
<p dir="auto">Воспроизвести практическую часть лекции самостоятельно.</p>
<ul dir="auto">
<li>Создать виртуальную машину.</li>
<li>Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды</li>
</ul>
<div class="snippet-clipboard-content notranslate position-relative overflow-auto" data-snippet-clipboard-copy-content="docker ps"><pre class="notranslate"><code>docker ps
</code></pre></div>
</article>
  </div>