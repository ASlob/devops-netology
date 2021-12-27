1.
CD - встроеная команда для изменения рабочего каталога, она не является утилитой , т.к. в файловой системе отсутствуют файлы связанные с этой командой.  
---  

2.
Альтернативой pipe являеется опция -с (счётик) утилиты grep. С помощью этой опции можно подсчитать колличество вхождений строки, т.е. сколько раз определённая строка была найдена в каждом файле.
---
3.
Команда pstree -p отображает все запущенные родительские процессы вместе с их дочерними процессами и соответствующими PID. В виртуальной машине Ubuntu 20.04 процесс systemd является родительским
---

4.
Способ 1
Нужно запустить два окна терминала и в обоих выполнить vagrant ssh
Ввод в терминале /dev/pts/0
	ls \text 2>/dev/pts/1
Вывод в терминале /dev/pts/1
	ls: cannot access 'text': No such file or directory

Способ 2
В терминале выполнить vagrant ssh, далее выполнить tmux (sudo apt install tmux). Комбинациями клавиш Ctrl+B и Shift+" создать ещё один процесс.
Далее
Ввод в терминале /dev/pts/1
	ls \text 2>/dev/pts/2
Вывод в терминале /dev/pts/2
	ls: cannot access 'text': No such file or directory
---

5.
vagrant@vagrant:~$ cat>text_in
new line
vagrant@vagrant:~$ ls
text_in
vagrant@vagrant:~$ cat < text_in > text_out
vagrant@vagrant:~$ ls
text_in  text_out
vagrant@vagrant:~$ cat text_out
new line
---

6.
Ответ: получится. Для этого нужно одновременно запустить Windows Terminal (это будет pty0) и консоль в VirtualBox Менеджер (это будет tty1). Комнда будет выглядеть следующим образом: 1) Из tty1 в pts/0: echo hello > /dev/pts/0; 2) Из pts/0 в tty1: echo hello > /dev/tty1
---

7.
Команда bash 5>&1 создаёт сиволическую ссылку с дескриптером 5 и направляет стандартным потоком (>) в фоновом режиме (&) в stdout (1)
Команда echo netology > /proc/$$/fd/5 отправляет netology в данный дескриптер, если отправить в дескриптер, например, 2, то терминал выдаст ошибку, т.к. ранее мы не создавали подобный дескриптер. Заданный дескриптер (5) будет существовать только в рамках текущей сессии, в других сессиях его видно не будет.
---

8.
vagrant@vagrant:~$ cat text_in
new line
second line
vagrant@vagrant:~$ ls -l text_in 3>&2 2>&1 1>&3 |grep -c "third line"
-rw-rw-r-- 1 vagrant vagrant 21 Dec 26 07:52 text_in
0
---

9.
Команда cat /proc/$$/environ показывает переменные оболочки, аналогичный вывод можно получить командами printenv и export
---

10.
/proc/<PID>/cmdline - содержит параметры командной строки, переданные на этапе запуска процесса
/proc/<PID>/exe - является символьной ссылкой на исполненный бинарный файл
---

11.
vagrant@vagrant:~$ cat /proc/cpuinfo | grep sse
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx lm constant_tsc rep_good nopl cpuid tsc_known_freq pni ssse3 x2apic hypervisor lahf_lm pti
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx lm constant_tsc rep_good nopl cpuid tsc_known_freq pni ssse3 x2apic hypervisor lahf_lm pti

Ответ: SSE 2.0
---

12.
vagrant@vagrant:~$ ssh localhost 'tty'
vagrant@localhost's password:
not a tty

Для удаленного сеанса по умолчанию не выделяется TTY. Для выделения TTY для удаленного выполнения необходимо использовать ключ -t.

vagrant@vagrant:~$ ssh -t localhost 'tty'
vagrant@localhost's password:
/dev/pts/1
Connection to localhost closed.
---

13.
vagrant@vagrant:~$ ps -a
    PID TTY          TIME CMD
    936 pts/0    00:00:00 top
    937 pts/1    00:00:00 ps
vagrant@vagrant:~$ sudo reptyr -T 936
---

14.
Команда tee нужна для записи вывода любой команды в один или несколько файлов. Команда echo является встроеной командой оболочки и параметр sudo на неё не распространяется в отлиии от tee, которая является внешней командой. Чтобы выполнить sudo echo нужно войти в оболочку под su.
