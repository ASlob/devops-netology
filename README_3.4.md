### 1.
Установка node_exporter, настройка прав

```
user@linserv:~$ wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
user@linserv:~$ tar zxvf node_exporter-1.3.1.linux-amd64.tar.gz
user@linserv:~$ cd node_exporter-1.3.1.linux-amd64/
user@linserv:~/node_exporter-1.3.1.linux-amd64$ ls
LICENSE  node_exporter  NOTICE
user@linserv:~/node_exporter-1.3.1.linux-amd64$ sudo cp node_exporter /usr/local/bin/
[sudo] password for user:
user@linserv:~/node_exporter-1.3.1.linux-amd64$ sudo useradd --no-create-home --shell /bin/false nodeusr
user@linserv:~/node_exporter-1.3.1.linux-amd64$ sudo chown -R nodeusr:nodeusr /usr/local/bin/node_exporter
user@linserv:~/node_exporter-1.3.1.linux-amd64$ sudo nano /etc/systemd/system/node_exporter.service
```

Создаём юнит
```
[Unit]
Description=Node Exporter Service
After=network.target

[Service]
User=nodeusr
Group=nodeusr
Type=simple
ExecStart=/usr/local/bin/node_exporter
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Настройка автозагрузки. Проверка.
```
user@linserv:~/node_exporter-1.3.1.linux-amd64$ sudo systemctl enable node_exporter
Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service → /etc/systemd/system/node_exporter.service.
user@linserv:~/sudo reboot
user@linserv:~/sudo systemctl status node_exporter
● node_exporter.service - Node Exporter Service
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2022-06-30 16:25:36 UTC; 3h 9min ago
   Main PID: 2122 (node_exporter)
      Tasks: 5 (limit: 1071)
     Memory: 4.6M
     CGroup: /system.slice/node_exporter.service
             └─2122 /usr/local/bin/node_exporter
```

Результат в браузере: ![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen.png)


### 2.
```
--collector.cpu
--collector.diskstats
--collector.meminfo
--collector.netstat
```
### 3.
```
vagrant@vagrant:~$ sudo lsof -i :19999
COMMAND PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
netdata 664 netdata    4u  IPv4  24589      0t0  TCP *:19999 (LISTEN)
netdata 664 netdata   22u  IPv4  28988      0t0  TCP vagrant:19999->_gateway:49462 (ESTABLISHED)
netdata 664 netdata   26u  IPv4  29973      0t0  TCP vagrant:19999->_gateway:49463 (ESTABLISHED)
netdata 664 netdata   32u  IPv4  29974      0t0  TCP vagrant:19999->_gateway:49464 (ESTABLISHED)
netdata 664 netdata   34u  IPv4  29975      0t0  TCP vagrant:19999->_gateway:49465 (ESTABLISHED)
netdata 664 netdata   52u  IPv4  29977      0t0  TCP vagrant:19999->_gateway:49470 (ESTABLISHED)
netdata 664 netdata   53u  IPv4  29978      0t0  TCP vagrant:19999->_gateway:49471 (ESTABLISHED)
```
Результат в браузере: ![Screenshot](https://github.com/ASlob/devops-netology/tree/main/images/screen2.png)
### 4.  
```
user@linserv:~$ who
user     pts/0        2022-06-27 08:58 (192.168.0.2)
user     pts/1        2022-06-27 10:47 (192.168.0.46)
```
Ввод pts/0
```
user@linserv:~$ ls test.file 2>/dev/pts/1
```
Вывод pts/1
```
user@linserv:~$ ls: cannot access 'test.file': No such file or directory
```

### 5.  
```
user@linserv:~$ cat test_dir/test_file
qwerty
55555
qwerty
66666
55555
55555
user@linserv:~$ cat test_dir/test_file.out
cat: test_dir/test_file.out: No such file or directory
user@linserv:~$ cat < test_dir/test_file > test_dir/test_file.out
user@linserv:~$ cat test_dir/test_file.out
qwerty
55555
qwerty
66666
55555
55555
user@linserv:~$
```

### 6.  
Данные из PTY перенаправляются в эмулятор TTY командой ```echo 'netology' > /dev/tty1```, при этом в PTY вывода мы не увидим, а в TTY появится вывод netology.


### 7.
Команда ```bash 5>&1``` создаст дескриптор 5 и перенатправит его в stdout. Если выполнить команду ```echo netology > /proc/$$/fd/5```, то вывод ```netology``` перенаправится в пятый дескриптор ```/fd/5``` процесса ```bash```, а тот перенаправит его в стандартный поток вывода и мы получим вывод ```netology``` на терминале. А если выполнить команду ```echo netology > /proc/$$/fd/4```, то в терминале мы увидим ```bash: /proc/1121/fd/4: No such file or directory```, так как дескриптор 4 ещё не создан.


### 8.
Да, получится, через создание нового дескриптора ```cat file.test 5>&1 2>&1 1>&5 | grep 'no such file'```

```5>&2``` - дскриптор 5 перенаправили в ```stderr```  
```2>&1``` - ```stderr``` перенаправили в ```stdout```  
```1>&5``` - ```stdout``` - перенаправили дескриптор 5  

### 9.  
Команда ```cat /proc/$$/environ``` выведет набор переменных окружения, аналогичная команда ```env``` или ```env | less``` в более читаемом виде.


### 10.  
``` 
    220        /proc/[pid]/exe
    221               Under Linux 2.2 and later, this file is a symbolic link containing the actual pathname of the executed command.  This symbolic link can be dereferenced  normally;  attempting to
    222               open  it will open the executable.  You can even type /proc/[pid]/exe to run another copy of the same executable that is being run by process [pid].  If the pathname has been un‐
    223               linked, the symbolic link will contain the string '(deleted)' appended to the original pathname.  In a multithreaded process, the contents of this symbolic link are not available
    224               if the main thread has already terminated (typically by calling pthread_exit(3)).
    225
    226               Permission to dereference or read (readlink(2)) this symbolic link is governed by a ptrace access mode PTRACE_MODE_READ_FSCREDS check; see ptrace(2).
    227
    228               Under  Linux  2.0 and earlier, /proc/[pid]/exe is a pointer to the binary which was executed, and appears as a symbolic link.  A readlink(2) call on this file under Linux 2.0 re‐
    229               turns a string in the format:
    230
    231                   [device]:inode
    232
    233               For example, [0301]:1502 would be inode 1502 on device major 03 (IDE, MFM, etc. drives) minor 01 (first partition on the first drive).
    234
    235               find(1) with the -inum option can be used to locate the file.
```
**/proc/[pid]/exe - представляет собой символическую ссылку, содержащую фактический путь к выполняемой команде процесса**

```
    179        /proc/[pid]/cmdline
    180               This  read-only  file holds the complete command line for the process, unless the process is a zombie.  In the latter case, there is nothing in this file: that is, a read on this
    181               file will return 0 characters.  The command-line arguments appear in this file as a set of strings separated by null bytes ('\0'), with a further null byte after the last string.
```
**/proc/[pid]/cmdline - полный путь до исполняемого файла процесса**


### 11.  
**Ответ: ssse3**


### 12.  
По умолчанию, когда вы запускаете команду на удаленном компьютере с помощью ssh, TTY не выделяется для удаленного сеанса. Это позволяет передавать двоичные данные и т. д.. Без необходимости работать с причудами TTY. Это среда, предусмотренная для команды, выполняемой на computerone.

Однако, когда вы запускаете ssh без удаленной команды, он выделяет TTY, потому что вы, скорее всего, будете запускать сеанс оболочки. Это ожидается ```ssh otheruser@computertwo.com``` командой, но из-за предыдущего объяснения для этой команды нет доступного TTY.

Если вы хотите включить оболочку computertwo, используйте это вместо этого, что приведет к выделению TTY во время удаленного выполнения:   
```ssh -t user@computerone.com 'ssh otheruser@computertwo.com'```
Это обычно подходит, когда вы в конце концов запускаете оболочку или другой интерактивный процесс в конце цепочки ssh. Если вы собираетесь передавать данные, добавлять их не нужно и не нужно -t, но тогда каждая команда ssh будет содержать команду создания данных или -consuming, например:   
```ssh user@computerone.com 'ssh otheruser@computertwo.com "cat /boot/vmlinuz"'```


### 13.  



### 14.  
