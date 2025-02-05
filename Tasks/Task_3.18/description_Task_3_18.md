### Чекпоинты:

 
[Скачай конфигурационный файл nginx. Опиши Dockerfile, собери образ с тегом inno-dkr-08. Выведи список образов на твоем хосте.](#Point-1)  
[Запусти контейнер с собранным образом и проверь его работу на порту 8900. Выведи список запущенных контейнеров.](#Point-2)

---

#### Point 1  
#### Скачай конфигурационный файл nginx. Опиши Dockerfile, собери образ с тегом inno-dkr-08. Выведи список образов на твоем хосте.

1. Скачай конфигурационный файл nginx.
   Используем ранеесозданный `ngnix.conf` из предыдущих задач
2. Опишим Dockerfile, в котором:  
- как базовый образ используется nginx:stable,  
- внутрь контейнера как основной конфигурационный файл копируется скачанный тобой nginx.conf
- слушает на хосте 127.0.0.1:8900
  
  Создадим в текущей директории Dockerfile  
```bash
ubuntu@ip-172-31-19-243:~$ sudo nano Dockerfile
```
  с содержанием:

```dockerfile
# Use the official Nginx image from Docker Hub
FROM nginx:stable

# Copy custom Nginx configuration (optional)
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for the web server
EXPOSE 80

# Start Nginx in the foreground (required to keep the container running)
CMD ["nginx", "-g", "daemon off;"]

```

3. Собери этот образ с именем nginx и тегом inno-dkr-08. Выведи список образов на твоем хосте.  
   
Соберём образ с тегом `inno-dkr-08`
```bash
buntu@ip-172-31-19-243:~$ docker build -t nginx:inno-dkr-08 .
```
<details><summary>Подробный лог сборки</summary>

```bash
[+] Building 6.6s (7/7) FINISHED                                                                docker:default
 => [internal] load build definition from Dockerfile                                                      0.1s
 => => transferring dockerfile: 346B                                                                      0.0s
 => [internal] load metadata for docker.io/library/nginx:stable                                           1.5s
 => [internal] load .dockerignore                                                                         0.0s
 => => transferring context: 2B                                                                           0.0s
 => [internal] load build context                                                                         0.0s
 => => transferring context: 851B                                                                         0.0s
 => [1/2] FROM docker.io/library/nginx:stable@sha256:c2860a703abb6d7bbe12710dede9e2219b50aae839324099f58  4.7s
 => => resolve docker.io/library/nginx:stable@sha256:c2860a703abb6d7bbe12710dede9e2219b50aae839324099f58  0.0s
 => => sha256:494f43df02c1559295e2ab7811991e16ccf78996ead9eba60529c7efd023005d 2.29kB / 2.29kB            0.0s
 => => sha256:ecee3853484af70f442a7e25bb7fcd34f148b8769de25f4c1537db95b57d3867 41.88MB / 41.88MB          1.0s
 => => sha256:957ecafad75c0632d0d914ec1b0ec3fb72b26cdb109e9e371cc9ed853834dfe1 629B / 629B                0.6s
 => => sha256:c2860a703abb6d7bbe12710dede9e2219b50aae839324099f58e00a9896982a4 10.26kB / 10.26kB          0.0s
 => => sha256:92c5c54280f2d4ec1c23b1e610268f07d2497bdd12dbae6028baf0b20fb2b4d0 7.32kB / 7.32kB            0.0s
 => => sha256:c29f5b76f736a8b555fd191c48d6581bb918bcd605a7cbcc76205dd6acff3260 28.21MB / 28.21MB          0.9s
 => => sha256:cdcc20f8c268dc0b9aa0d080e845e9c5dd3cba7edd741041ad83ebb762b77c0e 956B / 956B                1.0s
 => => sha256:8626b3f59e2bb56adb46ffdf11ff08d7cf6f7c2bd6b6316786229f92d6fac18d 1.21kB / 1.21kB            1.1s
 => => extracting sha256:c29f5b76f736a8b555fd191c48d6581bb918bcd605a7cbcc76205dd6acff3260                 1.5s
 => => sha256:c8de15fafc3b8b85f304ffb069f0835634c854a8fe45b445ce2b09c1e8e887f0 394B / 394B                1.1s
 => => sha256:10857794dc67c4fc76c1cc669dc2fbcf10a9b3bf936eeff55e5d7a0bff6b4de6 1.40kB / 1.40kB            1.1s
 => => extracting sha256:ecee3853484af70f442a7e25bb7fcd34f148b8769de25f4c1537db95b57d3867                 1.6s
 => => extracting sha256:957ecafad75c0632d0d914ec1b0ec3fb72b26cdb109e9e371cc9ed853834dfe1                 0.0s
 => => extracting sha256:cdcc20f8c268dc0b9aa0d080e845e9c5dd3cba7edd741041ad83ebb762b77c0e                 0.0s
 => => extracting sha256:c8de15fafc3b8b85f304ffb069f0835634c854a8fe45b445ce2b09c1e8e887f0                 0.0s
 => => extracting sha256:8626b3f59e2bb56adb46ffdf11ff08d7cf6f7c2bd6b6316786229f92d6fac18d                 0.0s
 => => extracting sha256:10857794dc67c4fc76c1cc669dc2fbcf10a9b3bf936eeff55e5d7a0bff6b4de6                 0.0s
 => [2/2] COPY nginx.conf /etc/nginx/nginx.conf                                                           0.1s
 => exporting to image                                                                                    0.1s
 => => exporting layers                                                                                   0.0s
 => => writing image sha256:756d2d0690171c3750634215cd6a9668e6cd13890a799f35f2ab362636c6b827              0.0s
 => => naming to docker.io/library/nginx:inno-dkr-08                                                      0.0s
ubuntu@ip-172-31-19-243:~$

```
</details><br>

Список образов на хосте:
```bash
ubuntu@ip-172-31-19-243:~$ docker image ls
REPOSITORY   TAG             IMAGE ID       CREATED         SIZE
nginx        inno-dkr-08     756d2d069017   3 minutes ago   188MB
nginx        inno-dkr-07     4ebaceb1bd2e   5 months ago    43.3MB
nginx        stable-alpine   4ebaceb1bd2e   5 months ago    43.3MB
ubuntu@ip-172-31-19-243:~$
```
---

#### Point 2  
#### Запустим контейнер с собранным образом nginx и тегом inno-dkr-08:
- контейнер должен работать в фоне,  
- слушать на хосте 127.0.0.1:8900.  

```bash
ubuntu@ip-172-31-19-243:~$ docker run -d --name inno-dkr-08 -p 127.0.0.1:8900:80 nginx:inno-dkr-08
101168678c457a83a46a79929f1af263941c49c5d89d8a10508cf9ecd757b859
```
Выведи список запущенных контейнеров - контейнер должен быть запущен.  
```bash
ubuntu@ip-172-31-19-243:~$ docker ps
CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS          PORTS                              NAMES
101168678c45   nginx:inno-dkr-08   "/docker-entrypoint.…"   19 minutes ago   Up 19 minutes   127.0.0.1:8900->80/tcp   inno-dkr-08
```

Проверь работу, обратившись к 127.0.0.1:8900.

```bash
ubuntu@ip-172-31-19-243:~$ curl -v  http://localhost:8900/
* Host localhost:8900 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
*   Trying [::1]:8900...
* connect to ::1 port 8900 from ::1 port 58368 failed: Connection refused
*   Trying 127.0.0.1:8900...
* Connected to localhost (127.0.0.1) port 8900
> GET / HTTP/1.1
> Host: localhost:8900
> User-Agent: curl/8.5.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Server: nginx/1.26.2
< Date: Wed, 05 Feb 2025 15:17:16 GMT
< Content-Type: application/octet-stream
< Content-Length: 50
< Connection: keep-alive
< Content-Type: text/plain
<
Welcome to the training program Innowise: Docker!
* Connection #0 to host localhost left intact
```

Для удобства создал два скрипта [re-build-run-nginx.sh](re-build-run-nginx.sh) и [re-run-nginx.sh](re-run-nginx.sh).
