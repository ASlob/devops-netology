1.
chdir("/tmp") = 0 - системный вызов, изменяющий нашу текущую рабочую директорию на указанную

2.
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3

3.
В одной сессии терминала запускаем процесс  
ping 192.168.1.1 >> test.txt  

В другой сессии терминала переходим под root находим нужный процесс  
vagrant@vagrant:~$ sudo -i  
root@vagrant:~# ps -a  
    PID TTY          TIME CMD  
   6657 pts/0    00:00:00 ping  
   6704 pts/1    00:00:00 sudo  
   6706 pts/1    00:00:00 bash  
   6718 pts/1    00:00:00 ps  
'''root@vagrant:~# lsof -p 6657'''  
COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME  
ping    6657 vagrant  cwd    DIR  253,0     4096 131074 /home/vagrant  
ping    6657 vagrant  rtd    DIR  253,0     4096      2 /  
ping    6657 vagrant  txt    REG  253,0    72776 524524 /usr/bin/ping  
ping    6657 vagrant  mem    REG  253,0  5699248 535133 /usr/lib/locale/locale-archive  
ping    6657 vagrant  mem    REG  253,0   137584 527268 /usr/lib/x86_64-linux-gnu/libgpg-error.so.0.28.0  
ping    6657 vagrant  mem    REG  253,0  2029224 527432 /usr/lib/x86_64-linux-gnu/libc-2.31.so  
ping    6657 vagrant  mem    REG  253,0   101320 527451 /usr/lib/x86_64-linux-gnu/libresolv-2.31.so  
ping    6657 vagrant  mem    REG  253,0  1168056 527252 /usr/lib/x86_64-linux-gnu/libgcrypt.so.20.2.5  
ping    6657 vagrant  mem    REG  253,0    31120 527208 /usr/lib/x86_64-linux-gnu/libcap.so.2.32  
ping    6657 vagrant  mem    REG  253,0   191472 527389 /usr/lib/x86_64-linux-gnu/ld-2.31.so  
ping    6657 vagrant    0u   CHR  136,0      0t0      3 /dev/pts/0  
ping    6657 vagrant    1w   REG  253,0    16461 131088 /home/vagrant/test.txt  
ping    6657 vagrant    2u   CHR  136,0      0t0      3 /dev/pts/0  
ping    6657 vagrant    3u  icmp             0t0  68848 00000000:0001->00000000:0000  
ping    6657 vagrant    4u  sock    0,9      0t0  68849 protocol: PINGv6  
root@vagrant:~# exit  
logout  
vagrant@vagrant:~$ rm test.txt  
vagrant@vagrant:~$ sudo lsof -p 6657  
COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME  
ping    6657 vagrant  cwd    DIR  253,0     4096 131074 /home/vagrant  
ping    6657 vagrant  rtd    DIR  253,0     4096      2 /  
ping    6657 vagrant  txt    REG  253,0    72776 524524 /usr/bin/ping  
ping    6657 vagrant  mem    REG  253,0  5699248 535133 /usr/lib/locale/locale-archive  
ping    6657 vagrant  mem    REG  253,0   137584 527268 /usr/lib/x86_64-linux-gnu/libgpg-error.so.0.28.0  
ping    6657 vagrant  mem    REG  253,0  2029224 527432 /usr/lib/x86_64-linux-gnu/libc-2.31.so  
ping    6657 vagrant  mem    REG  253,0   101320 527451 /usr/lib/x86_64-linux-gnu/libresolv-2.31.so  
ping    6657 vagrant  mem    REG  253,0  1168056 527252 /usr/lib/x86_64-linux-gnu/libgcrypt.so.20.2.5  
ping    6657 vagrant  mem    REG  253,0    31120 527208 /usr/lib/x86_64-linux-gnu/libcap.so.2.32  
ping    6657 vagrant  mem    REG  253,0   191472 527389 /usr/lib/x86_64-linux-gnu/ld-2.31.so  
ping    6657 vagrant    0u   CHR  136,0      0t0      3 /dev/pts/0  
ping    6657 vagrant    1w   REG  253,0    26373 131088 /home/vagrant/test.txt (deleted)  
ping    6657 vagrant    2u   CHR  136,0      0t0      3 /dev/pts/0  
ping    6657 vagrant    3u  icmp             0t0  68848 00000000:0001->00000000:0000  
ping    6657 vagrant    4u  sock    0,9      0t0  68849 protocol: PINGv6  
vagrant@vagrant:~$ sudo -i  
root@vagrant:~# echo '' >/proc/6657/fd/1  
root@vagrant:~# lsof -p 6657  
COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME  
ping    6657 vagrant  cwd    DIR  253,0     4096 131074 /home/vagrant  
ping    6657 vagrant  rtd    DIR  253,0     4096      2 /  
ping    6657 vagrant  txt    REG  253,0    72776 524524 /usr/bin/ping  
ping    6657 vagrant  mem    REG  253,0  5699248 535133 /usr/lib/locale/locale-archive  
ping    6657 vagrant  mem    REG  253,0   137584 527268 /usr/lib/x86_64-linux-gnu/libgpg-error.so.0.28.0  
ping    6657 vagrant  mem    REG  253,0  2029224 527432 /usr/lib/x86_64-linux-gnu/libc-2.31.so  
ping    6657 vagrant  mem    REG  253,0   101320 527451 /usr/lib/x86_64-linux-gnu/libresolv-2.31.so  
ping    6657 vagrant  mem    REG  253,0  1168056 527252 /usr/lib/x86_64-linux-gnu/libgcrypt.so.20.2.5  
ping    6657 vagrant  mem    REG  253,0    31120 527208 /usr/lib/x86_64-linux-gnu/libcap.so.2.32  
ping    6657 vagrant  mem    REG  253,0   191472 527389 /usr/lib/x86_64-linux-gnu/ld-2.31.so  
ping    6657 vagrant    0u   CHR  136,0      0t0      3 /dev/pts/0  
ping    6657 vagrant    1w   REG  253,0      178 131088 /home/vagrant/test.txt (deleted)  
ping    6657 vagrant    2u   CHR  136,0      0t0      3 /dev/pts/0  
ping    6657 vagrant    3u  icmp             0t0  68848 00000000:0001->00000000:0000  
ping    6657 vagrant    4u  sock    0,9      0t0  68849 protocol: PINGv6  

4.  
Вся системная память и другие ресурсы, выделенные зомби-процессу, деаллокируются при его завершении с помощью системного вызова exit(). Но его запись в таблице остается доступной. Если родительский процесс не запущен, наличие зомби-процесса означает ошибку в операционной системе. Это может не вызывать серьезных проблем, если зомби-процессов немного. Но при больших нагрузках присутствие зомби-процессов может привести к нехватке записей в таблице процессов.  

5.  
PID    COMM               FD ERR PATH  
796    vminfo              6   0 /var/run/utmp  
562    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services  
562    dbus-daemon        18   0 /usr/share/dbus-1/system-services  
562    dbus-daemon        -1   2 /lib/dbus-1/system-services  
562    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/  

6.  
Linux vagrant 5.4.0-80-generic #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux  

Цитата из man:  

/proc/version  

This string identifies the kernel version that is currently running. It includes the contents of /proc/sys/kernel/ostype, /proc/sys/kernel/osrelease and /proc/sys/kernel/version.  
For example:  

    Linux version 1.0.9 (quinlan@phaze) #1 Sat May 14 01:51:54 EDT 1994  

7.
Операторы управления:  
Точка с запятой (;) - все команды с наборами аргументов будут выполнены последовательно, причем командная оболочка будет ожидать завершения исполнения каждой из команд перед исполнением следующей команды.  
Двойной амперсанд (&&) - Командная оболочка будет интерпретировать последовательность символов && как логический оператор "И". При использовании оператора && вторая команда будет исполняться только в том случае, если исполнение первой команды успешно завершится (будет возвращен нулевой код завершения).  

set -e завершает работу при сбое команды. Следовательно && не имеет смысла использоваться, т.к. при возникновении ошибки - последовательность команд будет прервана.  

8.
-e прерывает выполнение исполнения при ошибке любой команды кроме последней в последовательности.  
-u неустановленные/не заданные параметры и переменные считаются как ошибки, с выводом в stderr текста ошибки и выполнит завершение неинтерактивного вызова.  
-x вывод трейса простых команд.  
-o устаналивает или снимает опцию по её длинному имени. Например set -o noglob. Если никакой опции не задано, то выводится список всех опций и их статус.  
pipefail - устанавливает, что код выхода из конвейера отличается от нормального («последняя команда в конвейере») поведения: ИСТИНА, если ни одна из команд не завершилась ошибкой, ЛОЖЬ, если что-то не удалось (код самой правой команды, которая завершилась ошибкой).  

Для сценария , повышает деталезацию вывода ошибок и логирования на каждом этапе. Также завершит сценарий при наличии ошибок, кроме последней завершающей команды.  

9.  
vagrant@vagrant:~$ ps -o stat  
STAT  
Ss  
R+  

S прерывистый сон (ожидание завершения события)  
s является лидером сессии  

считать S, Ss или Ssl равнозначными нельзя, дополнительные символы это характеристики процесса  
