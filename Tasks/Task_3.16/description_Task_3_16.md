### Чекпоинты

[1) Запусти контейнеры с различными драйверами (локальным и по-default json драйвером) логирования и настройками ограничения размера лога.](#Point-1)  
[2) Настрой глобальные параметры логирования Docker через файл `daemon.json`.](#Point-2)  
[3) Запусти контейнер с использованием глобальных настроек логирования.](#Point-3)
[4) Вернем настройки для драйвера `json` с использованием глобальных настроек логирования.](#Point-4)

---

1. #### Point 1  
#### Запусти контейнеры с различными драйверами (локальным и default json драйвером) логирования и настройками ограничения размера лога.  
   **Задача:**  
   1. Запусти контейнер с именем `inno-dkr-06-default`, используя образ `nginx:stable`, с параметрами:
      - Работает в фоне.
      - Слушает на хосте `127.0.0.1:8892`.
      - Логи используют драйвер по-умолчанию.
Отредактируем для этого уже ранее созданый файл на сервере `blue-server` и отменим запись логов в смонтированный бакет как было ранее,  удалим все образы и ранее созданные контейнеры перед этим:
```ini  
#!/bin/bash
# Re-Start Nginx
echo -e "\nStopping and deleting container which is already existed..."
if [ "$(docker ps -aq)" ]; then
docker rm -f $(docker ps -aq)
fi
echo -e "\n...and Starting Nginx again with -it mode for 'attach' using!"
if docker run -d \
  --name inno-dkr-06-default \
  -p 8891:80 \
  --mount type=bind,source=/home/ubuntu/nginx.conf,target=/etc/nginx/nginx.conf,readonly \
  nginx:stable;then
    echo -e "\nNginx started successfully.\n"
else
    echo -e "\nFailed to start Nginx.\n"
fi
```
Запустим скрипт:
```bash
ubuntu@ip-172-31-19-243:~$ ./re-run-nginx.sh

Stopping and deleting container which is already existed...

...and Starting Nginx again with -it mode for 'attach' using!
Unable to find image 'nginx:stable' locally
stable: Pulling from library/nginx
af302e5c37e9: Pull complete
fd5e42408d9a: Pull complete
f45aaf9ca822: Pull complete
ae00e6f53029: Pull complete
b8229349b16f: Pull complete
092d2c15cc87: Pull complete
4d9b8625ec33: Pull complete
Digest: sha256:f2c6d8e7b81820cc0186a764d6558935b521e1a3404647247d329273e01a1886
Status: Downloaded newer image for nginx:stable
1069cee88495628237ec8954f3070e619e92f0e056d02e362cd14d14a0eded02

Nginx started successfully.
```

   2. Выведем список запущенных контейнеров и сделаем несколько запросов к запущенному nginx через браузер, чтобы были записаны логи. Выведим содержимое лога с меткой времени из файла на хостовой системе, в который записаны логи контейнера:

```bash
ubuntu@ip-172-31-19-243:~$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                     NAMES
00b0c70c1b71   nginx:stable   "/docker-entrypoint.…"   14 seconds ago   Up 13 seconds   0.0.0.0:8891->80/tcp, [::]:8891->80/tcp   inno-dkr-06-default
ubuntu@ip-172-31-19-243:~$ 
ubuntu@ip-172-31-19-243:~$ docker logs -t inno-dkr-06-default
2025-01-27T16:45:31.254274186Z /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
2025-01-27T16:45:31.254549136Z /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
2025-01-27T16:45:31.256738851Z /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
2025-01-27T16:45:31.268567889Z 10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
2025-01-27T16:45:31.278761244Z 10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
2025-01-27T16:45:31.278939677Z /docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
2025-01-27T16:45:31.279099959Z /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
2025-01-27T16:45:31.282736015Z /docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
2025-01-27T16:45:31.284052373Z /docker-entrypoint.sh: Configuration complete; ready for start up
2025-01-27T16:47:03.773575708Z 85.221.149.113 - - [27/Jan/2025:16:47:03 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/                                 537.36" "-"
2025-01-27T16:47:04.259947828Z 85.221.149.113 - - [27/Jan/2025:16:47:04 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/                                 537.36" "-"

На хостовой машине ищем логи тут по ID контейнера(логи будут в формате json):
```bash
ubuntu@ip-172-31-19-243:~$sudo ls -al /var/lib/docker/containers/
total 12
drwx--x---  3 root root 4096 Jan 27 16:45 .
drwx--x--- 12 root root 4096 Jan 27 16:45 ..
drwx--x---  4 root root 4096 Jan 27 16:45 00b0c70c1b71d692ab5abd247d5239c18ec5e70baa0e347e897b15b3db4f38f3
ubuntu@ip-172-31-19-243:~$ ^C
ubuntu@ip-172-31-19-243:~$ sudo ls -al /var/lib/docker/containers/00b0c70c1b71d692ab5abd247d5239c18ec5e70ba
total 44
drwx--x--- 4 root root 4096 Jan 27 16:45 .
drwx--x--- 3 root root 4096 Jan 27 16:45 ..
-rw-r----- 1 root root 1385 Jan 27 16:45 00b0c70c1b71d692ab5abd247d5239c18ec5e70baa0e347e897b15b3db4f38f3-j
drwx------ 2 root root 4096 Jan 27 16:45 checkpoints
-rw------- 1 root root 3330 Jan 27 16:45 config.v2.json
-rw------- 1 root root 1694 Jan 27 16:45 hostconfig.json
-rw-r--r-- 1 root root   13 Jan 27 16:45 hostname
-rw-r--r-- 1 root root  174 Jan 27 16:45 hosts
drwx--x--- 2 root root 4096 Jan 27 16:45 mounts
-rw-r--r-- 1 root root  273 Jan 27 16:45 resolv.conf
-rw-r--r-- 1 root root   71 Jan 27 16:45 resolv.conf.hash
ubuntu@ip-172-31-19-243:~$ sudo ls -al /var/lib/docker/containers/00b0c70c1b71d692ab5abd247d5239c18ec5e70ba
-rw-r----- 1 root root 1385 Jan 27 16:45 /var/lib/docker/containers/00b0c70c1b71d692ab5abd247d5239c18ec5e70g
ubuntu@ip-172-31-19-243:~$ sudo cat -t  /var/lib/docker/containers/00b0c70c1b71d692ab5abd247d5239c18ec5e70baa0e347e897b15b3db4f38f3/00b0c70c1b71d692ab5abd247d5239c18ec5e70baa0e347e897b15b3db4f38f3-json.log                  {"log":"/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration\n","stream":"stdout","time":"2025-01-27T16:45:31.254274186Z"}
{"log":"/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/\n","stream":"stdout","time":"2025-01-27T16:45:31.254549136Z"}
{"log":"/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh\n","stream":"stdout","time":"2025-01-27T16:45:31.256738851Z"}
{"log":"10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf\n","stream":"stdout","time":"2025-01-27T16:45:31.268567889Z"}
{"log":"10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf\n","stream":"stdout","time":"2025-01-27T16:45:31.278761244Z"}
{"log":"/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh\n","stream":"stdout","time":"2025-01-27T16:45:31.278939677Z"}
{"log":"/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh\n","stream":"stdout","time":"2025-01-27T16:45:31.279099959Z"}
{"log":"/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh\n","stream":"stdout","time":"2025-01-27T16:45:31.282736015Z"}
{"log":"/docker-entrypoint.sh: Configuration complete; ready for start up\n","stream":"stdout","time":"2025-01-27T16:45:31.284052373Z"}
ubuntu@ip-172-31-19-243:~$
```
   3. Запустим контейнер с именем `inno-dkr-06-local`, используя образ `nginx:stable`, с параметрами:
      - Работает в фоне.
      - Слушает на хосте `127.0.0.1:8892`.
      - Логи используют драйвер `local` с ограничением объема файла лога не более 10 MiB.

Отредактируем для этого уже ранее созданый файл на сервере `blue-server` из предыдущих заданий следующим образом (добавим `--log-driver=local --log-opt max-size=10m `) и отменим запись логов в смонтированный бакет, удалим все образы и ранее созданные контейнеры перед этим:
```ini  
#!/bin/bash
# Re-Start Nginx
echo -e "\nStopping and deleting container which is already existed..."
if [ "$(docker ps -aq)" ]; then
docker rm -f $(docker ps -aq)
fi
echo -e "\n...and Starting Nginx again with -it mode for 'attach' using!"
if docker run -d \
  --name inno-dkr-06-local \
  -p 8891:80 \
  --log-driver=local \
  --log-opt max-size=10m \
  --mount type=bind,source=/home/ubuntu/nginx.conf,target=/etc/nginx/nginx.conf,readonly \
  nginx:stable;then
    echo -e "\nNginx started successfully.\n"
else
    echo -e "\nFailed to start Nginx.\n"
fi
```
Запустим скрипт:
```bash
ubuntu@ip-172-31-19-243:~$ ./re-run-nginx.sh

Stopping and deleting container which is already existed...

...and Starting Nginx again with -it mode for 'attach' using!

Nginx started successfully.
```
   4. Выведем список запущенных контейнеров:
```bash
ubuntu@ip-172-31-19-243:~$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED              STATUS              PORTS                                     NAMES
ca0695c4e2cd   nginx:stable   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:8891->80/tcp, [::]:8891->80/tcp   inno-dkr-06-local
```
 Сделаем несколько запросов к запущенному nginx через браузер, чтобы были записаны логи. Выведим содержимое лога из файла на хостовой системе, в который записаны логи контейнера:
```bash
ubuntu@ip-172-31-19-243:~$ docker logs -f inno-dkr-06-local
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
85.221.149.113 - - [27/Jan/2025:16:03:09 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
85.221.149.113 - - [27/Jan/2025:16:03:45 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
85.221.149.113 - - [27/Jan/2025:16:03:45 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
85.221.149.113 - - [27/Jan/2025:16:03:46 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
```
На хостовой машине ищем логи тут по ID контейнера(доги будут в формате local .log):
```bash
ubuntu@ip-172-31-19-243:~$ sudo ls -al /var/lib/docker/containers/ca0695c4e2cd4213c65a4306638df88bec4308e9f849c0c7473dd127bd45c/local-logs/container.log
-rw-r----- 1 root root 2108 Jan 27 16:21 /var/lib/docker/containers/ca0695c4e2cd4213c65a4306638df88bec4308e9f849c0c7473dd127bd45c/local-logs/container.log

ubuntu@ip-172-31-19-243:~$sudo cat  /var/lib/docker/containers/ca0695c4e2cd4213c65a4306638df88bec4308e9f849c0c7473dd127bd45c/local-logs/container.log
t
stdout▒▒Ȥ▒▒`/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configurationt]
stdout▒▒▒Ȥ▒▒I/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/]i
stdout▒▒ĞȤ▒▒U/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.shiq
stdout▒▒ϣȤ▒▒]10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.confqs
stdout▒▒▒Ȥ▒▒_10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.confsa
stdout▒▒▒▒Ȥ▒▒M/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envshae
stdout▒ñ▒Ȥ▒▒Q/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.shee
stdoutի▒Ȥ▒▒Q/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sheU
stdout▒ҳ▒Ȥ▒▒A/docker-entrypoint.sh: Configuration complete; ready for start upU▒
stdout▒▒▒▒▒▒85.221.149.113 - - [27/Jan/2025:16:21:48 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"▒▒
stdout▒▒唥▒▒▒85.221.149.113 - - [27/Jan/2025:16:21:48 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"▒▒
stdout▒▒▒▒▒85.221.149.113 - - [27/Jan/2025:16:21:49 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) 
```
---

2. #### Point 2  
#### Настроим глобальные параметры логирования Docker через файл `daemon.json`.  
   **Задача:**  
   1. Открой файл `/etc/docker/daemon.json` для редактирования (если файла не существует, создай его):
```bash
ubuntu@ip-172-31-19-243:~$ sudo ls -l /etc/docker/daemon.json
ls: cannot access '/etc/docker/daemon.json': No such file or directory
ubuntu@ip-172-31-19-243:~$ sudo nano  /etc/docker/daemon.json
ubuntu@ip-172-31-19-243:~$

```
   2. Добавим (или обновим) следующие параметры для установки глобального драйвера логирования `local` и ограничения объема логов в 10 MiB:
```json
{
"log-driver": "local",
"log-opts": {
    "max-size": "10m"
}
}
```
   3. Сохраним изменения и перезапустим демон Docker для применения новых настроек:

```bash
ubuntu@ip-172-31-19-243:~$ sudo systemctl restart docker
ubuntu@ip-172-31-19-243:~$
```

---

3. #### Point 3  
#### Запустим контейнер с использованием глобальных настроек логирования.  
   **Задача:**  
   1. Запусти контейнер с именем `inno-dkr-06-global`, используя образ `nginx:stable`, с параметрами:
      - Работает в фоне.
      - Слушает на хосте `127.0.0.1:8891`.
      - В команде запуска **не** должны присутствовать параметры драйвера логирования.
    Для этого опять изменим скрипт запуска:
```ini
#!/bin/bash
# Re-Start Nginx
echo -e "\nStopping and deleting container which is already existed..."
if [ "$(docker ps -aq)" ]; then
docker rm -f $(docker ps -aq)
fi
echo -e "\n...and Starting Nginx again with -it mode for 'attach' using!"
if docker run -d \
  --name inno-dkr-06-global \
  -p 8891:80 \
  --mount type=bind,source=/home/ubuntu/nginx.conf,target=/etc/nginx/nginx.conf,readonly \
  nginx:stable;then
    echo -e "\nNginx started successfully.\n"
else
    echo -e "\nFailed to start Nginx.\n"
fi
```
   2. Выведи список запущенных контейнеров и сделаем несколько запросов к запущенному nginx через браузер, чтобы были записаны логи. Выведим содержимое лога из файла на хостовой системе, в который записаны логи контейнера:
```bash     
ubuntu@ip-172-31-19-243:~$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                     NAMES
a13e9fe5c3de   nginx:stable   "/docker-entrypoint.…"   47 seconds ago   Up 46 seconds   0.0.0.0:8891->80/tcp, [::]:8891->80/tcp   inno-dkr-06-global
ubuntu@ip-172-31-19-243:~$ docker logs -f inno-dkr-06-global
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
85.221.149.113 - - [27/Jan/2025:16:21:48 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
85.221.149.113 - - [27/Jan/2025:16:21:48 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
85.221.149.113 - - [27/Jan/2025:16:21:49 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
85.221.149.113 - - [27/Jan/2025:16:21:51 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
85.221.149.113 - - [27/Jan/2025:16:21:52 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
```
Содержимое локального файла лога на хостовой машине можно увидеть здесь:
```bash

ubuntu@ip-172-31-19-243:~$ sudo ls -al /var/lib/docker/containers/a13e9fe5c3dec724213c65a4306638df88bec4308e9f849c0c7473dd127bd45c/local-logs/container.log
-rw-r----- 1 root root 2108 Jan 27 16:21 /var/lib/docker/containers/a13e9fe5c3dec724213c65a4306638df88bec4308e9f849c0c7473dd127bd45c/local-logs/container.log

ubuntu@ip-172-31-19-243:~$sudo cat  /var/lib/docker/containers/a13e9fe5c3dec724213c65a4306638df88bec4308e9f849c0c7473dd127bd45c/local-logs/container.log
t
stdout▒▒Ȥ▒▒`/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configurationt]
stdout▒▒▒Ȥ▒▒I/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/]i
stdout▒▒ĞȤ▒▒U/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.shiq
stdout▒▒ϣȤ▒▒]10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.confqs
stdout▒▒▒Ȥ▒▒_10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.confsa
stdout▒▒▒▒Ȥ▒▒M/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envshae
stdout▒ñ▒Ȥ▒▒Q/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.shee
stdoutի▒Ȥ▒▒Q/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sheU
stdout▒ҳ▒Ȥ▒▒A/docker-entrypoint.sh: Configuration complete; ready for start upU▒
stdout▒▒▒▒▒▒85.221.149.113 - - [27/Jan/2025:16:21:48 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"▒▒
stdout▒▒唥▒▒▒85.221.149.113 - - [27/Jan/2025:16:21:48 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"▒▒
stdout▒▒▒▒▒85.221.149.113 - - [27/Jan/2025:16:21:49 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"▒▒
stdout▒▒▒ȟ▒▒▒▒85.221.149.113 - - [27/Jan/2025:16:21:51 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"▒▒
stdout▒ިà▒▒▒▒85.221.149.113 - - [27/Jan/2025:16:21:52 +0000] "GET / HTTP/1.1" 200 50 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"▒
```

4. #### Point 4
#### Вернем настройки для драйвера `json` с использованием глобальных настроек логирования.

Для этого отредактируем файл  `/etc/docker/daemon.json`:
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```
   3. Сохраним изменения и перезапустим демон Docker для применения новых настроек:

```bash
ubuntu@ip-172-31-19-243:~$ sudo systemctl restart docker
ubuntu@ip-172-31-19-243:~$
```
