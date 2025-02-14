### Чекпоинты:

[1) Вывести размеры разделов диска в отдельный файл. Отсортировать количество столбцов до трех, оставив только Filesystem, Use%, Mounted on.](#point-1)  
[2) Узнать размер всех файлов и папок в директории /etc. вывод так, Отсортировать чтобы показывало только 10 самых больших файлов ](#point-2)  
[3) Cоздать файл со следующим содержанием. NDS/A NSDA ANS!D NAD/A](#point-3)  
[4) Вывести строки NDS/A и NAD/A из файла используя awk или sed(regexp).](#point-4)   
[5) Вывести пронумерованные строчки из /etc/passwd, в которых есть оболочка /bin/bash, и перенаправить вывод в файл.](#point-5)  
[6) Заменить все строчки с /bin/sh на /bin/bash(проводить на бэкапе).](#point-6)  
  



1. #### Point 1  
#### Вывести размеры разделов диска в отдельный файл. Отсортировать количество столбцов до трех, оставив только Filesystem, Use%, Mounted on.
Всё это можно сделать средствами предустановленой по-умолчанию утилитой *df*:

весь вывод

    df -h > disk-size.txt
и отсортированные значения (Filesystem, Use%, Mounted on)

    df -h --output=source,pcent,target > disk-size-usage.txt

```bash    
ubuntu@ip-172-31-30-89:~$ df -h --output=source,pcent,target > disk-size-usage.txt && cat disk-size-usage.txt
Filesystem     Use% Mounted on
/dev/root       35% /
tmpfs            0% /dev/shm
tmpfs            1% /run
tmpfs            0% /run/lock
/dev/xvda16     17% /boot
/dev/xvda15      6% /boot/efi
tmpfs            1% /run/user/1000
```
Кроме того возможно сортировка значений по возрастанию/убыванию, например по % использования. Для этого используем утилиту sort, например так:
```bash
ubuntu@ip-172-31-30-89:~$ df -h --output=source,pcent,target |  sort -k2 -n
Filesystem     Use% Mounted on
tmpfs            0% /dev/shm
tmpfs            0% /run/lock
tmpfs            1% /run
tmpfs            1% /run/user/1000
/dev/xvda15      6% /boot/efi
/dev/xvda16     17% /boot
/dev/root       35% /
```

но в данном случае мы не исключаем заголовки из сортировки и при отсортировки в обратном порядке получим 
```bash
ubuntu@ip-172-31-30-89:~$ df -h --output=source,pcent,target |  sort -k2 -n -r
/dev/root       35% /
/dev/xvda16     17% /boot
/dev/xvda15      6% /boot/efi
tmpfs            1% /run/user/1000
tmpfs            1% /run
tmpfs            0% /run/lock
tmpfs            0% /dev/shm
Filesystem     Use% Mounted on
```
поэтому нужно немного усложнить команду, создав конвейер команд, выводя сначала только заголовки, а затем отсортированные столбцы
```bash
(df -h --output=source,pcent,target | head -n 1; df -h --output=source,pcent,target | tail -n +2 | sort -k2 -n -r)
```
```bash
ubuntu@ip-172-31-30-89:~$ (df -h --output=source,pcent,target | head -n 1; df -h --output=source,pcent,target | tail -n +2 | sort -k2 -n -r) > size-sort-usage.txt && cat size-sort-usage.txt
Filesystem     Use% Mounted on
/dev/root       35% /
/dev/xvda16     17% /boot
/dev/xvda15      6% /boot/efi
tmpfs            1% /run/user/1000
tmpfs            1% /run
tmpfs            0% /run/lock
tmpfs            0% /dev/shm
```

2. #### Point 2  
 #### Узнать размер всех файлов и папок в директории /etc. Отсортировать вывод так,  чтобы показывало только 10 самых больших файлов
Для этого используем команду du, также сортировку и ограничение вывода первых 10-ти файлов без первой записи общего объема директории
```bash
sudo du -ah /etc  | sort -rh | tail -n +2 | head -n 10
```
```bash
ubuntu@ip-172-31-30-89:~$ sudo du -ah /etc  | sort -rh | tail -n +2 | head -n 10
1.1M    /etc/apparmor.d
664K    /etc/ssl
664K    /etc/ssh
640K    /etc/ssl/certs
608K    /etc/ssh/moduli
536K    /etc/apparmor.d/abstractions
280K    /etc/vmware-tools
252K    /etc/cloud
216K    /etc/ssl/certs/ca-certificates.crt
216K    /etc/cloud/templates
```

3. #### Point 3  
 ####   Cоздать файл со следующим содержанием. 
NDS/A
NSDA
ANS!D
NAD/A. 

Создаем файл любым удобным способом, например:
```bash
echo -e $'NDS/A\nNSDA\nANS!D\nNAD/A' > test.txt && cat test.txt
```
```bash
ubuntu@ip-172-31-30-89:~$ echo -e $'NDS/A\nNSDA\nANS!D\nNAD/A' > test.txt && cat test.txt
NDS/A
NSDA
ANS!D
NAD/A
```
или так 
```bash
cat > test2.txt  <<EOF
NDS/A
NSDA
ANS!D
NAD/A.

EOF
```
```bash
ubuntu@ip-172-31-30-89:~$ cat test2.txt
NDS/A
NSDA
ANS!D
NAD/A
```
4. #### Point 4  
 #### Вывести строки NDS/A и NAD/A из файла используя awk или sed(regexp). 
Определим искомые строки как подпадающие под регулярное выражение 'N**/A' и будем искать через 'awk'

```bash
awk '/^N.*\/A$/' test.tx
``` 
```bash
ubuntu@ip-172-31-30-89:~$ awk '/^N.*\/A$/' test.txt
NDS/A
NAD/A
```
5. #### Point 5  
 #### Вывести пронумерованные строчки из /etc/passwd, в которых есть оболочка /bin/bash, и перенаправить вывод в файл.
Для этого будем использовать grep и нумерацию строк, так это проще чем регулярки  в awk:
```bash
cat /etc/passwd | grep '/bin/bash' | nl > lines.txt && cat lines.txt
```
```bash
ubuntu@ip-172-31-30-89:~$ cat /etc/passwd | grep '/bin/bash' | nl > lines.txt && cat lines.txt
1  root:x:0:0:root:/root:/bin/bash
2  ubuntu:x:1000:1000:Ubuntu:/home/ubuntu:/bin/bash
3  raymond:x:1001:1002::/home/raymond:/bin/bash
4  john:x:1002:1003::/home/john:/bin/bash
```

6. #### Point 6  
 ####  Заменить все строчки с /bin/sh на /bin/bash(проводить на бэкапе)
Создаем бэкап файла, например вот так:
```bash
ubuntu@ip-172-31-30-89:~$ sudo cp /etc/passwd /etc/passwd.bk
ubuntu@ip-172-31-30-89:~$ ls /etc/passwd.bk
/etc/passwd.bk
```
Проверим наличие строк в /bin/sh в файле предидущим способом:
```bash
ubuntu@ip-172-31-30-89:~$ cat /etc/passwd.bk | grep '/bin/sh' | nl

     1  bill:x:1003:1005::/home/bill:/bin/sh
```
Заменим элемент строки при помощи утилиты sed и проверим результат:
```bash
ubuntu@ip-172-31-30-89:~$ sudo sed -i 's|/bin/sh|/bin/bash|g' /etc/passwd.bk
ubuntu@ip-172-31-30-89:~$ cat /etc/passwd.bk | grep '/bin/sh' | nl
ubuntu@ip-172-31-30-89:~$ cat /etc/passwd.bk | grep '/bin/bash' | nl
     1  root:x:0:0:root:/root:/bin/bash
     2  ubuntu:x:1000:1000:Ubuntu:/home/ubuntu:/bin/bash
     3  raymond:x:1001:1002::/home/raymond:/bin/bash
     4  john:x:1002:1003::/home/john:/bin/bash
     5  bill:x:1003:1005::/home/bill:/bin/bash
```

