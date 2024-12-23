### Чекпоинты:

[1) Вывести размеры разделов диска в отдельный файл. Отсортировать количество столбцов до трех, оставив только Filesystem, Use%, Mounted on.](#Point-1)  
[2) Узнать размер всех файлов и папок в директории /etc. вывод так, Отсортировать чтобы показывало только 10 самых больших файлов ](#Point-2)  
[3) Cоздать файл со следующим содержанием. NDS/A NSDA ANS!D NAD/A](#Point-3)  
[4) Вывести строки NDS/A и NAD/A из файла используя awk или sed(regexp).](#Point-4)   
[5) Вывести пронумерованные строчки из /etc/passwd, в которых есть оболочка /bin/bash, и перенаправить вывод в файл.](#Point-5)  
[6) Заменить все строчки с /bin/sh на /bin/bash(проводить на бэкапе).](#Point-6)  
  

 Используемые команды должны быть записаны в отдельный файлик.


1. #### Point 1  
#### Вывести размеры разделов диска в отдельный файл. Отсортировать количество столбцов до трех, оставив только Filesystem, Use%, Mounted on.
Всё это можно сделать средствами предустановленой по-умолчанию утилитой *df*:

     весь вывод
    df -h > disk-size.txt
     и отсортированные значения (Filesystem, Use%, Mounted on)
    df -h --output=source,pcent,target > disk-size-usage.txt

```    
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

    ubuntu@ip-172-31-30-89:~$ df -h --output=source,pcent,target |  sort -k2 -n
    Filesystem     Use% Mounted on
    tmpfs            0% /dev/shm
    tmpfs            0% /run/lock
    tmpfs            1% /run
    tmpfs            1% /run/user/1000
    /dev/xvda15      6% /boot/efi
    /dev/xvda16     17% /boot
    /dev/root       35% /


но в данном случае мы не исключаем заголовки из сортировки и при отсортировки в обратном порядке получим 

    ubuntu@ip-172-31-30-89:~$ df -h --output=source,pcent,target |  sort -k2 -n -r
    /dev/root       35% /
    /dev/xvda16     17% /boot
    /dev/xvda15      6% /boot/efi
    tmpfs            1% /run/user/1000
    tmpfs            1% /run
    tmpfs            0% /run/lock
    tmpfs            0% /dev/shm
    Filesystem     Use% Mounted on

поэтому нужно немного усложнить команду, создав конвейер команд, выводя сначала только заголовки, а затем отсортированные столбцы
    ```
    (df -h --output=source,pcent,target | head -n 1; df -h --output=source,pcent,target | tail -n +2 | sort -k2 -n -r)
    ```

    ubuntu@ip-172-31-30-89:~$ (df -h --output=source,pcent,target | head -n 1; df -h --output=source,pcent,target | tail -n +2 | sort -k2 -n -r) > size-sort-usage.txt && cat size-sort-usage.txt
    Filesystem     Use% Mounted on
    /dev/root       35% /
    /dev/xvda16     17% /boot
    /dev/xvda15      6% /boot/efi
    tmpfs            1% /run/user/1000
    tmpfs            1% /run
    tmpfs            0% /run/lock
    tmpfs            0% /dev/shm


2. #### Point 2  
 #### Узнать размер всех файлов и папок в директории /etc. Отсортировать вывод так,  чтобы показывало только 10 самых больших файлов
```
sudo du -ah /etc  | sort -rh | tail -n +2 | head -n 10
```

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


3. #### Point 3  
 ####   Cоздать файл со следующим содержанием. 
NDS/A
NSDA
ANS!D
NAD/A. 

4. #### Point 4  
 #### Вывести строки NDS/A и NAD/A из файла используя awk или sed(regexp). 
5. #### Point 5  
 #### Вывести пронумерованные строчки из /etc/passwd, в которых есть оболочка /bin/bash, и перенаправить вывод в файл.
6. #### Point 6  
 ####  Заменить все строчки с /bin/sh на /bin/bash(проводить на бэкапе)



    Используемые команды должны быть записаны в отдельный файлик.
