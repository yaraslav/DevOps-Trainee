### Чекпоинты

[1) Скачай конфигурационный файл nginx и создай volume. Запусти контейнер с указанными параметрами.](#Point-1)  
[2) Проверь работу контейнера, выведи список контейнеров и volumes, а также содержимое volume.](#Point-2)  

---

1. #### Point 1  
#### Скачай конфигурационный файл nginx и создай volume. Запусти контейнер с указанными параметрами.  
   **Задача:**  
   1. Скачай конфигурационный файл nginx.
   Будем использовать ранее созданный `nginx.conf`.
   2. Создай volume с именем `inno-dkr-04-volume` и запусти контейнер со следующими параметрами:  
      - должен работать в фоне;  
      - слушает на хосте `127.0.0.1:8891`;  
      - имеет имя `inno-dkr-04`;  
      - должен пробрасывать скачанный конфигурационный файл внутрь контейнера как основной конфигурационный файл;  
      - образ — `nginx:stable`;  
      - в директорию с логами nginx должен быть подключен созданный вами volume, монтирование должно происходить в `logs/external` (иначе контейнер упадет при старте).

   Для этого немного откорректируем на скрипт запуска [re-run-nginx.sh](re-run-nginx.sh):
```ini
  GNU nano 7.2                                             re-run-nginx.sh
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
```

user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    tcp_nopush     on;

    keepalive_timeout  65;

    gzip  on;


    server {
        listen 80;

        location = / {
            add_header Content-Type text/plain always;
            return 200 'Welcome to the training program Innowise: Docker!\n';
        }
    }

}


```

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
ubuntu@ip-172-31-19-243:~$ docker exec -it inno-dkr-04 bash
root@f99d0182748f:/# cd var/log/nginx/
root@f99d0182748f:/var/log/nginx# ls
access.log  error.log
root@f99d0182748f:/var/log/nginx# exit
exit
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$ ./re-run-nginx.sh

Stopping and deleting container which is already existed...
f99d0182748f

...and Starting Nginx again with -it mode for 'attach' using!
5b0b16fceb41da4251edb6bbbd2e893829d8fb7697613c1d04a0467018e1f511

Nginx started successfully.

ubuntu@ip-172-31-19-243:~$ nano re-run-nginx.sh
ubuntu@ip-172-31-19-243:~$ ./re-run-nginx.sh

Stopping and deleting container which is already existed...
5b0b16fceb41

...and Starting Nginx again with -it mode for 'attach' using!
517aef5508c0736049b50d2fe6673ce8613f72349e8d648d95d0b66d8f13e507

Nginx started successfully.

ubuntu@ip-172-31-19-243:~$ docker exec -it inno-dkr-04 bash
root@517aef5508c0:/# exit
exit
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$ curl http://127.0.0.1:8891
Welcome to the training program Innowise: Docker!
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$ sudo ls  /var/lib/docker/volumes/inno-dkr-04-volume/_data/
ubuntu@ip-172-31-19-243:~$ sudo ls  /var/lib/docker/volumes/inno-dkr-04-volume/_data
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$ sudo ls  /var/lib/docker/volumes/inno-dkr-04-volume/
_data
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$ nano re-run-nginx.sh
ubuntu@ip-172-31-19-243:~$ ./re-run-nginx.sh

Stopping and deleting container which is already existed...
517aef5508c0

...and Starting Nginx again with -it mode for 'attach' using!
0e08542344177477f82378dad2549b31f78f6875f4c88a95149441dabeac7348

Nginx started successfully.

ubuntu@ip-172-31-19-243:~$ curl http://127.0.0.1:8891
Welcome to the training program Innowise: Docker!
ubuntu@ip-172-31-19-243:~$ sudo ls  /var/lib/docker/volumes/inno-dkr-04-volume/_data
access.log  error.log
ubuntu@ip-172-31-19-243:~$ sudo ls -l  /var/lib/docker/volumes/inno-dkr-04-volume/_data
total 0
lrwxrwxrwx 1 root root 11 Jan 14 02:21 access.log -> /dev/stdout
lrwxrwxrwx 1 root root 11 Jan 14 02:21 error.log -> /dev/stderr
ubuntu@ip-172-31-19-243:~$ sudo cat   /var/lib/docker/volumes/inno-dkr-04-volume/_data/access.log


^C
ubuntu@ip-172-31-19-243:~$ sudo cat   /var/lib/docker/volumes/inno-dkr-04-volume/_data/error.log
^C
ubuntu@ip-172-31-19-243:~$ curl http://127.0.0.1:8891
Welcome to the training program Innowise: Docker!
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$ curl http://127.0.0.1:8891
Welcome to the training program Innowise: Docker!
ubuntu@ip-172-31-19-243:~$ sudo cat   /var/lib/docker/volumes/inno-dkr-04-volume/_data/access.log
^[[A^[[A^C
ubuntu@ip-172-31-19-243:~$ sudo cat   /var/lib/docker/volumes/inno-dkr-04-volume/_data/access.log


^[[A^C
ubuntu@ip-172-31-19-243:~$ sudo ls /var/lib/docker/volumes/inno-dkr-04-volume/_data/access.log
/var/lib/docker/volumes/inno-dkr-04-volume/_data/access.log
ubuntu@ip-172-31-19-243:~$ sudo l /var/lib/docker/volumes/inno-dkr-04-volume/_data/access.log
sudo: l: command not found
ubuntu@ip-172-31-19-243:~$ cat /var/lib/docker/volumes/inno-dkr-04-volume/_data/access.log
cat: /var/lib/docker/volumes/inno-dkr-04-volume/_data/access.log: Permission denied
ubuntu@ip-172-31-19-243:~$ sudo cat /var/lib/docker/volumes/inno-dkr-04-volume/_data/access.log


^X^C
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$ sudo cat /var/lib/docker/volumes/inno-dkr-04-volume/_data/access.log
^C
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$


---

2. #### Point 2  
#### Проверь работу контейнера, выведи список контейнеров и volumes, а также содержимое volume.  
   **Задача:**  
   1. Проверь работу контейнера, обратившись к `127.0.0.1:8891`. В ответ должно возвращаться сообщение:  
      ```
      Welcome to the training program Innowise: Docker!
      ```  
   2. Выведи список запущенных контейнеров — контейнер должен быть активен.  
   3. Выведи список существующих volumes с помощью команды:  
      ```bash
      docker volume ls
      ```  
   4. Выведи содержимое volume на хостовой системе с помощью команды:  
      ```bash
      ls -la /var/lib/docker/volumes/inno-dkr-04-volume/_data
      ```  
