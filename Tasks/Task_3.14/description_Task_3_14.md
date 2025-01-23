### Чекпоинты

[1) Скачай конфигурационный файл nginx и создай volume. Запусти контейнер с указанными параметрами.](#Point-1)  
[2) Проверь работу контейнера, выведи список контейнеров и volumes, а также содержимое volume.](#Point-2)  

---

1. #### Point 1  
#### Скачай конфигурационный файл nginx и создай volume. Запусти контейнер с указанными параметрами.  
   **Задача:**  
   1. Скачай конфигурационный файл nginx.
   Будем использовать ранее созданный `nginx.conf`.
   Внесем в него небольшие изменения (изменим response):
```ini
    server {
        listen 80;

        location = / {
            add_header Content-Type text/plain always;
            return 200 'Welcome to the training program Innowise: Docker!\n';
        }
    }

}
```
   
   2. Создадим volume с именем `inno-dkr-04-volume` следующим образом:
```bash
ubuntu@ip-172-31-19-243:~$ docker volume create inno-dkr-04-volume
inno-dkr-04-volume
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$ docker volume ls
DRIVER    VOLUME NAME
local     283551504bd30bd48eea996bf5af9dd23817be6d7b4795e2ab2885df7c75ef26
local     inno-dkr-04-volume
ubuntu@ip-172-31-19-243:~$ docker volume inspect inno-dkr-04-volume
[
    {
        "CreatedAt": "2025-01-23T11:03:10Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/inno-dkr-04-volume/_data",
        "Name": "inno-dkr-04-volume",
        "Options": null,
        "Scope": "local"
    }
]
ubuntu@ip-172-31-19-243:~$
```

   и запустим контейнер со следующими параметрами:  
      - должен работать в фоне;  
      - слушает на хосте `127.0.0.1:8891`;  
      - имеет имя `inno-dkr-04`;  
      - должен пробрасывать скачанный конфигурационный файл внутрь контейнера как основной конфигурационный файл;  
      - образ — `nginx:stable`;  
      - в директорию с логами nginx должен быть подключен созданный вами volume, монтирование должно происходить в `logs/external` (иначе контейнер упадет при старте).

   Для этого немного откорректируем наш скрипт запуска [re-run-nginx.sh](re-run-nginx.sh):
```ini
#!/bin/bash

# Re-Start Nginx
echo -e "\nStopping and deleting container which is already existed..."
if [ "$(docker ps -aq)" ]; then
docker rm -f $(docker ps -aq)
fi
echo -e "\n...and Starting Nginx again with -it mode for 'attach' using!"
if docker run -dit --name inno-dkr-04 \
 -p 8891:80 \
 --mount type=bind,source=/home/ubuntu/nginx.conf,target=/etc/nginx/nginx.conf,readonly \
 --mount source=inno-dkr-04-volume,target=/var/log/nginx nginx:stable; then
    echo -e "\nNginx started successfully.\n"
else
    echo -e "\nFailed to start Nginx.\n"
fi

```
Запустим скрипт и проверим работу:

```bash
ubuntu@ip-172-31-19-243:~$ ./re-run-nginx.sh

Stopping and deleting container which is already existed...
f99d0182748f

...and Starting Nginx again with -it mode for 'attach' using!
5b0b16fceb41da4251edb6bbbd2e893829d8fb7697613c1d04a0467018e1f511

Nginx started successfully.

ubuntu@ip-172-31-19-243:~$ docker logs inno-dkr-04
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up

ubuntu@ip-172-31-19-243:~$ curl http://127.0.0.1:8891
Welcome to the training program Innowise: Docker!

```

---

2. #### Point 2  
#### Проверь работу контейнера, выведи список контейнеров и volumes, а также содержимое volume.  
   **Задача:**  
   1. Проверь работу контейнера, обратившись к `127.0.0.1:8891`. В ответ должно возвращаться сообщение:  
```bash
ubuntu@ip-172-31-19-243:~$ curl http://127.0.0.1:8891
Welcome to the training program Innowise: Docker!
```
   2. Выведи список существующих volumes с помощью команды:  
```bash
ubuntu@ip-172-31-19-243:~$ docker volume ls
DRIVER    VOLUME NAME
local     283551504bd30bd48eea996bf5af9dd23817be6d7b4795e2ab2885df7c75ef26
local     inno-dkr-04-volume
```  
   3. Выведev содержимое volume на хостовой системе с помощью команды:  
```bash
ubuntu@ip-172-31-19-243:~$ sudo ls -la /var/lib/docker/volumes/inno-dkr-04-volume/_data
total 12
drwxr-xr-x 2 messagebus messagebus 4096 Jan 23 12:40 .
drwx-----x 3 root       root       4096 Jan 23 11:03 ..
lrwxrwxrwx 1 messagebus messagebus   11 Jan 23 13:11 access.log -> /dev/stdout
lrwxrwxrwx 1 messagebus messagebus   11 Jan 14 02:21 error.log -> /dev/stderr

ubuntu@ip-172-31-19-243:~$
```  

И при проверке файлов лога ничего нет:
```bash
ubuntu@ip-172-31-19-243:~$ sudo cat   /var/lib/docker/volumes/inno-dkr-04-volume/_data/access.log

^C
ubuntu@ip-172-31-19-243:~$ sudo cat   /var/lib/docker/volumes/inno-dkr-04-volume/_data/error.log

^C
```bash
проверяем файлы в контейнере и получаем тоже самое, например:

```bash
ubuntu@ip-172-31-19-243:~$ docker exec -it inno-dkr-04 cat  /var/log/nginx/error.log

^C
ubuntu@ip-172-31-19-243:~$
```
Это происходит из-за того, что в контейнере вывод лога nginx идет в стандартный stderr/stdout в `docker logs` по-умолчанию:

```bash
ubuntu@ip-172-31-19-243:~$ docker exec -it inno-dkr-04 ls -l /var/log/nginx/
total 0
lrwxrwxrwx 1 nginx nginx 11 Jan 14 02:21 access.log -> /dev/stdout
lrwxrwxrwx 1 nginx nginx 11 Jan 14 02:21 error.log -> /dev/stderr
```
Для тестирования создадим не ссылку, а файл в разделе `/var/log/nginx/` внутри контейнера и проверим:
```bash
ubuntu@ip-172-31-19-243:~$ docker exec -it inno-dkr-04 bash
root@ca25b0d7490c:/#
root@ca25b0d7490c:/# rm /var/log/nginx/access.log
root@ca25b0d7490c:/# touch /var/log/nginx/access.log
root@ca25b0d7490c:/# touch /var/log/nginx/access.log
root@ca25b0d7490c:/#
root@ca25b0d7490c:/# nginx -s reload
2025/01/23 12:40:55 [notice] 45#45: signal process started
root@ca25b0d7490c:/#
root@ca25b0d7490c:/#
root@ca25b0d7490c:/# exit
exit
ubuntu@ip-172-31-19-243:~$ docker exec -it inno-dkr-04 ls -l /var/log/nginx/
total 0
-rw-r--r-- 1 root  root   0 Jan 23 12:40 access.log
lrwxrwxrwx 1 nginx nginx 11 Jan 14 02:21 error.log -> /dev/stderr
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$ sudo ls -la /var/lib/docker/volumes/inno-dkr-04-volume/_data
total 12
drwxr-xr-x 2 messagebus messagebus 4096 Jan 23 12:40 .
drwx-----x 3 root       root       4096 Jan 23 11:03 ..
-rw-r--r-- 1 root       root       1641 Jan 23 13:11 access.log
lrwxrwxrwx 1 messagebus messagebus   11 Jan 14 02:21 error.log -> /dev/stderr
```
и теперь видим там файл, а не ссылку.

Проверяем сервис и лог в локальном разделе:

```bash
ubuntu@ip-172-31-19-243:~$ sudo cat /var/lib/docker/volumes/inno-dkr-04-volume/_data/access.log

ubuntu@ip-172-31-19-243:~$ curl http://127.0.0.1:8891
Welcome to the training program Innowise: Docker!

ubuntu@ip-172-31-19-243:~$ sudo cat /var/lib/docker/volumes/inno-dkr-04-volume/_data/access.log
172.17.0.1 - - [23/Jan/2025:12:50:40 +0000] "GET / HTTP/1.1" 200 50 "-" "curl/8.5.0" "-"
```
NB: Данное решение "workaround" для тестирования, если использовать далее это решение в контейнере нужно настроить ротацию логов например.
Например как здесь:
https://alexanderzeitler.com/articles/rotating-nginx-logs-with-docker-compose/



