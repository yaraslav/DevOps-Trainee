### Чекпоинты:

- [Напиши Dockerfile для сборки образа nginx:inno-dkr-09 на базе ubuntu:18.04.](#Point-1)  
- [Запусти контейнер с собранным образом, работающий в фоне и слушающий на хосте 127.0.0.1:8901. Выведи список запущенных контейнеров и проверь его работу.](#Point-2)

---

#### Point 1  
#### Напишим Dockerfile следующей конфигурации:
- Собирается из образа `ubuntu:18.04`,  
- В нем устанавливается пакет `nginx`,  
- В него копируется конфигурационный файл `nginx.conf`,  
- В `ENTRYPOINT` используется запуск `nginx`,  
- В `CMD` должны быть определены такие же параметры запуска `nginx`, как в образе `nginx:stable`
- Основная рабочая директория внутри контейнера - `/etc/nginx/`,  
- Должен быть определен Volume с путем `/var/lib/nginx`.  
  
Создаем Dockerfile c содержимым:
```Dockerfile
# Use the official Nginx image from Docker Hub
FROM ubuntu:18.04

WORKDIR /etc/nginx

RUN apt-get update && apt-get install -y nginx && apt-get clean && rm -rf /var/lib/apt/lists/*  

COPY nginx.conf /etc/nginx/nginx.conf

VOLUME [ "/var/lib/nginx" ]

EXPOSE 80

ENTRYPOINT [ "nginx" ]

CMD ["-g", "daemon off;"]

```
Конфиг используем прежний `nginx.conf`

Соберeм этот образ с именем `nginx:inno-dkr-09`.

Для этого подправим наш уже ранее созданный скрипт [re-build-run-nginx.sh](re-build-run-nginx.sh)
```bash
---
 -p 127.0.0.1:8901:80 \
---
```
И запустим его сборки нового образа и запуска контейнера.
<details><summary>Подробный лог скрипта</summary>

```bash
ubuntu@ip-172-31-19-243:~$ ./re-build.sh nginx:inno-dkr-09 inno-dkr-09
...and Build Nginx image again!

[+] Building 17.6s (9/9) FINISHED                                                                                        docker:default
 => [internal] load build definition from Dockerfile                                                                               0.0s
 => => transferring dockerfile: 614B                                                                                               0.0s
 => [internal] load metadata for docker.io/library/ubuntu:18.04                                                                    1.2s
 => [internal] load .dockerignore                                                                                                  0.0s
 => => transferring context: 2B                                                                                                    0.0s
 => [1/4] FROM docker.io/library/ubuntu:18.04@sha256:152dc042452c496007f07ca9127571cb9c29697f42acbfad72324b2bb2e43c98              1.9s
 => => resolve docker.io/library/ubuntu:18.04@sha256:152dc042452c496007f07ca9127571cb9c29697f42acbfad72324b2bb2e43c98              0.0s
 => => sha256:152dc042452c496007f07ca9127571cb9c29697f42acbfad72324b2bb2e43c98 1.33kB / 1.33kB                                     0.0s
 => => sha256:dca176c9663a7ba4c1f0e710986f5a25e672842963d95b960191e2d9f7185ebe 424B / 424B                                         0.0s
 => => sha256:f9a80a55f492e823bf5d51f1bd5f87ea3eed1cb31788686aa99a2fb61a27af6a 2.30kB / 2.30kB                                     0.0s
 => => sha256:7c457f213c7634afb95a0fb2410a74b7b5bc0ba527033362c240c7a11bef4331 25.69MB / 25.69MB                                   0.4s
 => => extracting sha256:7c457f213c7634afb95a0fb2410a74b7b5bc0ba527033362c240c7a11bef4331                                          1.3s
 => [internal] load build context                                                                                                  0.0s
 => => transferring context: 32B                                                                                                   0.0s
 => [2/4] WORKDIR /etc/nginx                                                                                                       0.1s
 => [3/4] RUN apt-get update && apt-get install -y nginx && apt-get clean && rm -rf /var/lib/apt/lists/*                          13.7s
 => [4/4] COPY nginx.conf /etc/nginx/nginx.conf                                                                                    0.1s
 => exporting to image                                                                                                             0.5s
 => => exporting layers                                                                                                            0.4s
 => => writing image sha256:f295e6a7d445728bd2f33fe143b5bf15a19d743e71c8fc559548fa7583a736f3                                       0.0s
 => => naming to docker.io/library/nginx:inno-dkr-09                                                                               0.0s

Deleting container which is already existed...
Error response from daemon: No such container: inno-dkr-09

...and Run  Nginx image again!
53daf2b8216741f8d40c28abc308006c052193692262321d94f3c0b5eca485fc
Nginx started successfully.
```
</details><br>

----

#### Point 2  
#### Запустим контейнер со следующими параметрами:
- Образ - собранный нами образ `nginx:inno-dkr-09`,  
- Должен работать в фоне,  
- Слушает на хосте `127.0.0.1:8901`.  
Выведи список запущенных контейнеров - контейнер должен быть запущен.  
Проверь работу, обратившись к `127.0.0.1:8901` - в ответ должно возвращать строку: "Welcome to the training program Innowise: Docker!".

Т.к. контейнер должен был запуститься скриптом в предыдущем шаге, проверяем образы:
```bash
ubuntu@ip-172-31-19-243:~$ docker images
REPOSITORY   TAG             IMAGE ID       CREATED          SIZE
nginx        inno-dkr-09     92577b95aec6   13 minutes ago   124MB
nginx        inno-dkr-08     72a9c6c7bcd1   2 hours ago      188MB
nginx        inno-dkr-07     4ebaceb1bd2e   5 months ago     43.3MB
nginx        stable-alpine   4ebaceb1bd2e   5 months ago     43.3MB
```
Проверяем доступ к серверу `nginx` и...
```bash
ubuntu@ip-172-31-19-243:~$ curl -v  http://localhost:8901/
* Host localhost:8901 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8901...
* connect to ::1 port 8901 from ::1 port 42720 failed: Connection refused
*   Trying 127.0.0.1:8901...
* connect to 127.0.0.1 port 8901 from 127.0.0.1 port 36008 failed: Connection refused
* Failed to connect to localhost port 8901 after 0 ms: Couldn't connect to server
* Closing connection
curl: (7) Failed to connect to localhost port 8901 after 0 ms: Couldn't connect to server
```
Видим ошибку! 
Смотрим контейнеры...
```bash
CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS                      PORTS     NAMES
ff072b7d6297   nginx:inno-dkr-09   "nginx -g 'daemon of…"   45 seconds ago   Exited (1) 14 seconds ago             inno-dkr-09
```
и логи 

```bash
ubuntu@ip-172-31-19-243:~$ docker logs inno-dkr-09
nginx: [emerg] getpwnam("nginx") failed in /etc/nginx/nginx.conf:1
```
Дело в конфиге `nginx.conf` и заданном там юзере `user  nginx` которого нет в собранном образе, а значит правим Dockerfile, добавив системного юзера:
```dockerfile
RUN useradd -r nginx
```
 
<details><summary>...и перезапускаем скрипт</summary>

```bash
ubuntu@ip-172-31-19-243:~$ ./re-build.sh nginx:inno-dkr-09 inno-dkr-09
\n...and Build Nginx image again!
[+] Building 1.4s (10/10) FINISHED                                                                                                                                                                              docker:default
 => [internal] load build definition from Dockerfile                                                                                                                                                                      0.0s
 => => transferring dockerfile: 638B                                                                                                                                                                                      0.0s
 => [internal] load metadata for docker.io/library/ubuntu:18.04                                                                                                                                                           0.7s
 => [internal] load .dockerignore                                                                                                                                                                                         0.0s
 => => transferring context: 2B                                                                                                                                                                                           0.0s
 => [1/5] FROM docker.io/library/ubuntu:18.04@sha256:152dc042452c496007f07ca9127571cb9c29697f42acbfad72324b2bb2e43c98                                                                                                     0.0s
 => [internal] load build context                                                                                                                                                                                         0.0s
 => => transferring context: 32B                                                                                                                                                                                          0.0s
 => CACHED [2/5] WORKDIR /etc/nginx                                                                                                                                                                                       0.0s
 => CACHED [3/5] RUN apt-get update && apt-get install -y nginx && apt-get clean && rm -rf /var/lib/apt/lists/*                                                                                                           0.0s
 => [4/5] RUN useradd -r nginx                                                                                                                                                                                            0.4s
 => [5/5] COPY nginx.conf /etc/nginx/nginx.conf                                                                                                                                                                           0.1s
 => exporting to image                                                                                                                                                                                                    0.1s
 => => exporting layers                                                                                                                                                                                                   0.1s
 => => writing image sha256:92577b95aec636ccf740ef44b06841789503647306e5d7bff45d3b1f0234002d                                                                                                                              0.0s
 => => naming to docker.io/library/nginx:inno-dkr-09                                                                                                                                                                      0.0s

Deleting container which is already existed...
inno-dkr-09
Deleted existing container inno-dkr-09.

...and Run  Nginx image again!
53daf2b8216741f8d40c28abc308006c052193692262321d94f3c0b5eca485fc

Nginx started successfully.
```
</details><br>
И проверяем снова:

```bash
ubuntu@ip-172-31-19-243:~$ curl -v  http://localhost:8901/
* Host localhost:8901 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8901...
* connect to ::1 port 8901 from ::1 port 55728 failed: Connection refused
*   Trying 127.0.0.1:8901...
* Connected to localhost (127.0.0.1) port 8901
> GET / HTTP/1.1
> Host: localhost:8901
> User-Agent: curl/8.5.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Server: nginx/1.14.0 (Ubuntu)
< Date: Wed, 05 Feb 2025 17:39:17 GMT
< Content-Type: application/octet-stream
< Content-Length: 56
< Connection: keep-alive
< Content-Type: text/plain
<
Welcome AGAIN to the training program Innowise: Docker!
* Connection #0 to host localhost left intact
```