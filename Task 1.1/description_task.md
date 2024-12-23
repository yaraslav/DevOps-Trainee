## Чекпоинты задачи:

[1) Поднять ubuntu на VirtualBox/VMware/Cloud.](#1.)  
[2) Создать там пользователей Raymond и John.](#2)  
[3) Raymond должен заходить только по SSH ключу на инстанс. А John должен каждый раз вводить свой пароль при попытке зайти на инстанс и не иметь возможности зайти по ssh ключу.](#3)   
[4) Raymond должен иметь доступ к sudo, а John не сможет использовать его.](#4)  
[5) Из под пользователя Raymond создать документ, используя права доступа сделать так, чтобы пользователь John не смог редактировать содержимое документа, но смог его прочитать. Из под пользователя John создать shell скрипт(с любой командой) и дать возможность запускать его пользователю Raymond.](#5)  
[6) Поменять интерпретатор по умолчанию пользователю John(сделать, чтобы был bash). Создать нового пользователя так, чтобы у него сразу был интерпретатор sh по умолчанию.](#6)  
[7) Добавить нового пользователя в группу пользователя John, проверить, сможет ли он запускать созданный ранее shell скрипт.](#7)  
[8) Создать на своей хостовой машине файл, после чего прокинуть его на инстанс с помощью scp.](#8)  

1) #### Поднять ubuntu на VirtualBox/VMware/Cloud.

   Использую AWS EC2-инстанс (Ubuntu 24.04.1 LTS), ssh-клиент - MobaXterm
2) #### Создать там пользователей Raymond и John.
   #### Ход работы
   Переходим в root пользователя
```
ubuntu@hostname:~$ sudo -i
root@hostname:~#
```
  Под root пользователем создаем группу users `root@hostname:~# groupadd users`  в которую по умолчанию будем назначать пользователей.
  Далее настраиваем предварительные правила на пользователей через доп.файлы в  `etc/sudoers.d/`: 
  для пользователя raymond разрешаем `sudo`, для - john запрещаем `sudo`. Кроме того, для большей безопасности ограничиваем некоторые sudo-команды для юзеров группы users (выключение инстанса, создание/удаление файлов и т.д.) создав и редактируя файл (в моем случае): 

`root@hostname:~# visudo -f /etc/sudoers.d/91-add-groups_rules`
устанавливая в нем:
```
#group rules

%users ALL = (ALL:users) ALL, !/bin/ls, !/bin/cat, !/bin/rm, !/bin/touch, !/usr/sbin/usermod, !/usr/bin/gpasswd, !/usr/sbin/visudo, !/usr/bin/passwd root, !/sbin/shutdown, !/sbin/halt, !/sbin/reboot, !/sbin/restart

john ALL = (ALL) !ALL
```

Также ограничем всем юзерам (кроме root и sudo) доступ к `su` и `sudo-i` редактируя:
```
root@hostname:~#: echo "auth required pam_wheel.so group=sudo" >> /etc/pam.d/su
root@hostname:~#: echo "auth required pam_wheel.so group=sudo" >> /etc/pam.d/sudo-i
```

Создаем юзеров, их пароли (через OpenSSL библиотеку) и запишем это в файл, например так:
  ```
    root@hostname:~# useradd -m -s /bin/bash  raymond
    root@hostname:~# sudo usermod -a -G users raymond
    root@hostname:~# pass=$(openssl rand -base64 6) &&
    echo "$raymond:$pass" | sudo chpasswd && echo "raymond:$pass" > ~/user_password.txt
  ```

  Для удобства написал небольшой скрипт и передадим все имена юзеров как аргументы:
`./set_users.sh raymond john`
сам скрипт:
```
#!/bin/bash

for user in "$@"; do
    sudo useradd -m -s /bin/bash "$user" &&
    sudo usermod -a -G users "$user" &&
    pass=$(openssl rand -base64 6) &&
    echo "$user:$pass" | sudo chpasswd && echo "$user:$pass" >> ~/user_password.txt
done

```
Note: 
Для удобства создания директорий юзеров можно заранее отредактировать файл `/etc/skel` и определив там шаблоны директорий в домашнем катологе юзера создаваемые по-умолчанию, например добавить доп.каталог:
```
root@hostname:/etc/skel# mkdir logs 
```
Также можно отредактировать файл `/etc/default/useradd` и определив там шаблоны для создания юзера по-умолчанию.

После создания юзеров проверяем соответствие login/password:
```
ubuntu@hostname:~$ su john
 Password:*****
 john@hostname:/home/ubuntu$
```
и проверяем доступы к sudo для юзеров
```
john@hostname:~$ sudo apt update
[sudo] password for john:
Sorry, user john is not allowed to execute '/usr/bin/apt update' as root on hostname.eu-central-1.compute.internal.
john@hostname:~$ su
Password:
su: Permission denied

raymond@hostname:~$ sudo apt update
[sudo] password for raymond:
Hit:1 http://eu-central-1.ec2.archive.ubuntu.com/ubuntu noble InRelease
Get:2 http://eu-central-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease [126 kB]
Hit:3 http://eu-central-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease
Hit:4 http://security.ubuntu.com/ubuntu noble-security InRelease
Fetched 126 kB in 1s (240 kB/s)
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
32 packages can be upgraded. Run 'apt list --upgradable' to see them.
raymond@hostname:~$
raymond@hostname:~$ sudo ls /home/john/
Sorry, user raymond is not allowed to execute '/usr/bin/ls /home/john/' as root on ip-172-31-30-89.eu-central-1.compute.internal.
raymond@hostname:~$ su
Password:
su: Permission denied

```

После чего копируем файл user_password.txt на локальную машину.


3) #### Raymond должен заходить только по SSH ключу на инстанс. А John должен каждый раз вводить свой пароль при попытке зайти на инстанс и не иметь возможности зайти по ssh ключу.
   Создадим для этого правила авторизации/аутентификации на сервере по SSH создав и редактируя файл (в моем случае) `/etc/ssh/sshd_config.d/61-users-settings.conf` устанавливая в нем например:

```
Port 22
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

Match User raymond
    PasswordAuthentication yes
    PubkeyAuthentication yes
    AllowTcpForwarding no
    X11Forwarding no
    AuthorizedKeysFile .ssh/authorized_keys

Match User john
    PasswordAuthentication yes
    PubkeyAuthentication no

```
Доступ по паролю доступен для обоих юзеров, для raymond этот доступ закроем только после настройки доступа по ключу.
Проверяем верность настроек и перезапускаем sshd демон:
```
root@hostname:~$ sshd -t
root@hostname:~$ systemctl restart ssh
root@hostname:~$

```
проверяем доступ с удаленной машины на сервер по логину и паролю:

```
yarik@Innowise-work:~$ ssh john@18.199.223.49
john@18.199.223.49's password:
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-1021-aws x86_64)
Last login: Fri Dec 20 13:02:30 2024 from 85.221.149.160
john@ip-172-31-30-89:~$ exit
logout
Connection to 18.199.223.49 closed.

yarik@Innowise-work:~$ ssh raymond@18.199.223.49
raymond@18.199.223.49's password:
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-1021-aws x86_64)
Last login: Fri Dec 20 13:14:21 2024 from 85.221.149.160
raymond@ip-172-31-30-89:~$ exit
logout
Connection to 18.199.223.49 closed.
yarik@Innowise-work:~$
```
Создаем SSH-ключи для доступа на сервер. Генерируем на локальной машине ключи любым удобным способом (например встроенные инструменты MobaExterm, Putty или in-build `ssh-keygen`), например так:
```
yarik@Innowise-work:~$ ssh-keygen -t ed25519 -f raymond_key
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in raymond_key
Your public key has been saved in raymond_key.pub
The key fingerprint is:
SHA256:*************************** yarik@Innowise-work
The key's randomart image is:
+--[ED25519 256]--+
|          *****   |
+----[SHA256]-----+

```
Проверяем, что ключи созданы 
```
yarik@Innowise-work:~$ ls raymond_key*
raymond_key  raymond_key.pub
```
и копируем публичный ключ на сервер любым удобным способом, например при помощи `ssh-copy-id`:
```
yarik@Innowise-work:~$ ssh-copy-id -i raymond_key.pub raymond@18.199.223.49
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "raymond_key.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
raymond@18.199.223.49's password:

Number of key(s) added: 1
Now try logging into the machine, with:   "ssh 'raymond@18.199.223.49'"
and check to make sure that only the key(s) you wanted were added.
```
и проверяем подключение по ключу:
```
yarik@Innowise-work:~$ ssh -i raymond_key raymond@18.199.223.49
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-1021-aws x86_64)
Last login: Fri Dec 20 13:14:21 2024 from 85.221.149.160
raymond@ip-172-31-30-89:~$ exit
logout
Connection to 18.199.223.49 closed.
```
После чего закрываем доступ по паролю для юзера raymond, редактируя файл (в моем случае) `/etc/ssh/sshd_config.d/61-users-settings.conf` устанавливая в нем:
```
Match User raymond
    PasswordAuthentication no
```
Проверяем верность настроек и перезапускаем sshd демон:
```
root@hostname:~$ sshd -t
root@hostname:~$ systemctl restart ssh
root@hostname:~$

```
Убеждаемся, что доступ по паролю закрыт:
```
yarik@Innowise-work:~$ ssh raymond@18.199.223.49
raymond@18.199.223.49: Permission denied (publickey).
yarik@Innowise-work:~$
```

UPD: Для удобства работы можем включить  ssh-agent и добавить в него используемые ключи, что позволит на указывать их путь и fingerprint при каждом подключении. Например вот так: 
```
yarik@Innowise-work: eval $(ssh-agent  -s) && ssh-add /home/yarik/raymond_key && ssh-add -l
Agent pid 55444
Identity added: /home/yarik/raymond_key (yarik@Innowise-work)
256 SHA256:aL****************************VM yarik@Innowise-work (ED25519)
```
```
yarik@Innowise-work:ssh raymond@3.71.179.183
The authenticity of host '3.71.179.183 (3.71.179.183)' can't be established.
ED25519 key fingerprint is SHA256:7H**********************************Y.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:14: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? y
Please type 'yes', 'no' or the fingerprint: yes
Warning: Permanently added '3.71.179.183' (ED25519) to the list of known hosts.
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-1021-aws x86_64)

Last login: Fri Dec 20 15:15:38 2024 from 85.221.149.160
raymond@ip-172-31-30-89:~$
raymond@ip-172-31-30-89:~$ exit
logout
Connection to 3.71.179.183 closed.

yarik@Innowise-work:ssh raymond@3.71.179.183
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-1021-aws x86_64)

Last login: Mon Dec 23 15:34:12 2024 from 85.221.149.87
raymond@ip-172-31-30-89:~$

```

4) #### Raymond должен иметь доступ к sudo, а John не сможет использовать его.

см. выше п.2

5) #### Из под пользователя Raymond создать документ, используя права доступа сделать так, чтобы пользователь John не смог редактировать содержимое документа, но смог его прочитать. Из под пользователя John создать shell скрипт(с любой командой) и дать возможность запускать его пользователю Raymond.
Создаем из под юзера Raymond файл test.txt и назначаем на него права для чтения в группе users и права на директорию `/home/raymond` минимум для исполнения:
```
raymond@ip-172-31-30-89:~$ cat test text file > test.txt
raymond@ip-172-31-30-89:~$ ls -la test.txt
-rw-rw-r-- 1 raymond raymond 47 Dec 20 15:16 test.txt
raymond@ip-172-31-30-89:~$ chown raymond:users test.txt
raymond@ip-172-31-30-89:~$ chmod g-w test.txt
raymond@ip-172-31-30-89:~$ chmod o-r test.txt
raymond@ip-172-31-30-89:~$ ls -la test.txt
-rw-r----- 1 raymond users 47 Dec 20 15:16 test.txt
raymond@ip-172-31-30-89:~$ chmod o+x /home/raymond
raymond@ip-172-31-30-89:~$ 
raymond@ip-172-31-30-89:~$ cat test.txt
test text file
```
и проверяем доступ для чтения и редактирования из под пользователя john:
```
john@ip-172-31-30-89:~$ cat /home/raymond/test.txt
test text file
john@ip-172-31-30-89:~$ nano  /home/raymond/test.txt

[ File '/home/raymond/test.txt' is unwritable ]
```
Создаем из под юзера John скрипт test.sh и назначаем на него права для исполнения:
```
john@ip-172-31-30-89:~$ echo "echo "test script"" > test.sh
john@ip-172-31-30-89:~$ cat test.sh
echo test script
john@ip-172-31-30-89:~$ chmod go+x test.sh
john@ip-172-31-30-89:~$ chmod go+x test.sh
john@ip-172-31-30-89:~$ ./test.sh
-bash: ./test.sh: Permission denied
john@ip-172-31-30-89:~$ chmod +x test.sh
john@ip-172-31-30-89:~$ ./test.sh
test script
```
в этом случае файл может быть исполняем под юзером Raymond через sudo
```
raymond@ip-172-31-30-89:~$ sudo /home/john/test.sh
[sudo] password for raymond:
test script
```
или можно повысит права на исполнение на директорию `john@ip-172-31-30-89:~$ chmod go+x /home/john/`  и сменить владельца группы `chown john:users test.sh`  тогда 
```
raymond@ip-172-31-30-89:~$ /home/john/test.sh
test script
```

6) #### Поменять интерпретатор по умолчанию пользователю John(сделать, чтобы был bash). Создать нового пользователя так, чтобы у него сразу был интерпретатор sh по умолчанию.
У пользователя John по умолчанию установлен /bin/bash. 
Создаем нового юзера с /bin/sh
```
root@ip-172-31-30-89:~# useradd -m -s /bin/sh bill
root@ip-172-31-30-89:~# usermod -a -G users bill
root@ip-172-31-30-89:~# pass=$(openssl rand -base64 6) &&
    echo "$bill:$pass" | sudo chpasswd && echo "bill:$pass" >> ~/user_password.txt
chpasswd: (user ) pam_chauthtok() failed, error:
Authentication token manipulation error
chpasswd: (line 1, user ) password not changed
root@ip-172-31-30-89:~# pass=$(openssl rand -base64 6) &&     echo "bill:$pass" | sudo chpasswd && echo "bill:$pass" >> ~/user_password.txt
root@ip-172-31-30-89:~#
```
   
7) #### Добавить нового пользователя в группу пользователя John, проверить, сможет ли он запускать созданный ранее shell скрипт.
    ```
    root@ip-172-31-30-89:~# usermod -a -G john bill
    ```
проверка нового юзера и выполнения файла:
```
root@ip-172-31-30-89:~# sudo -u bill -i
$ ls
logs
$ groups bill
bill : bill users john
$ cat /home/john/test.sh
echo test script
$ /home/john/test.sh
test script
$
```
8) #### Создать на своей хостовой машине файл, после чего прокинуть его на инстанс с помощью scp.
```
yarik@Innowise-work:~$ scp -i raymond_key trace.log  raymond@18.199.223.49:~
trace.log                                                                                          100%   34KB 577.6KB/s   00:00
yarik@Innowise-work:~$
```

             


