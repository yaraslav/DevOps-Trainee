### Чекпоинты:

[1) Установи Docker на свою систему, как указано в официальной документации. Запусти запись вывода терминала в файл. Запусти контейнер на порту 28080 из официального образа nginx: `docker run -d -p 127.0.0.1:28080:80 --name rbm-dkr-01 nginx:stable.` Выведи в консоли список запущенных контейнеров командой: docker ps. При помощи утилиты curl запроси адрес http://127.0.0.1:28080 - должна появиться приветственная страница nginx.  ](#Point-1)  
[2) Останови ранее запущенный контейнер командой: `docker` stop rbm-dkr-01.` Выполни команду docker ps, тем самым проверь произошедшие изменения в списке запущенных контейнеров - список контейнеров должен быть пуст. При помощи утилиты curl запроси адрес http://127.0.0.1:28080 - сейчас должна быть ошибка, поскольку мы уже удалили контейнер и ничего не слушается на этом порту.](#Point-2)  
[3) При помощи команды docker ps -a выведи список всех контейнеров в системе - в списке будет твой остановленный контейнер. Останови запись в файл и загрузите полученные логи в репозиторий на gitlab.](#Point-3)  


1. #### Point 1  
#### Установи Docker на свою систему, как указано в официальной документации. Запусти запись вывода терминала в файл. Запусти контейнер на порту 28080 из официального образа nginx: docker run -d -p 127.0.0.1:28080:80 --name rbm-dkr-01 nginx:stable. Выведи в консоли список запущенных контейнеров командой: docker ps. При помощи утилиты curl запроси адрес http://127.0.0.1:28080 - должна появиться приветственная страница nginx. Если не появляется, то запуск контейнера неуспешен по какой-то причине.  


Установка Docker на Ubuntu:
- проверим и удалим устаревшие файлы и раннее установленные конфликтующие пакеты следующим скриптом
```bash
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```
```bash
ubuntu@ip-172-31-30-89:~$ for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-getve $pkg; done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Package 'docker.io' is not installed, so not removed
0 upgraded, 0 newly installed, 0 to remove and 32 not upgraded.
```
- выберем для установки способ через менеджер пакетов `apt` и официальный репозиторий `docker`
```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# install the latest version:
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```
- проверяем установку и запуск сервиса `systemctl status docker.service`
```bash
ubuntu@ip-172-31-30-89:~$ systemctl status docker.service
● docker.service - Docker Application Container Engine
     Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; preset: enabled)
     Active: active (running) since Sat 2025-01-04 12:38:05 UTC; 1min 11s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 3730 (dockerd)
      Tasks: 9
     Memory: 29.5M (peak: 98.8M)
        CPU: 354ms
     CGroup: /system.slice/docker.service
             └─3730 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Jan 04 12:38:03 ip-172-31-30-89 systemd[1]: Starting docker.service - Docker Application Container Engine...
Jan 04 12:38:04 ip-172-31-30-89 dockerd[3730]: time="2025-01-04T12:38:04.420054880Z" level=info msg="Starting up"
Jan 04 12:38:04 ip-172-31-30-89 dockerd[3730]: time="2025-01-04T12:38:04.424483235Z" level=info msg="OTEL tracing is not configured, usi>
Jan 04 12:38:04 ip-172-31-30-89 dockerd[3730]: time="2025-01-04T12:38:04.424615137Z" level=info msg="detected 127.0.0.53 nameserver, ass>
Jan 04 12:38:04 ip-172-31-30-89 dockerd[3730]: time="2025-01-04T12:38:04.635100461Z" level=info msg="Loading containers: start."
Jan 04 12:38:05 ip-172-31-30-89 dockerd[3730]: time="2025-01-04T12:38:05.203069183Z" level=info msg="Loading containers: done."
Jan 04 12:38:05 ip-172-31-30-89 dockerd[3730]: time="2025-01-04T12:38:05.523353076Z" level=info msg="Docker daemon" commit=c710b88 conta>
Jan 04 12:38:05 ip-172-31-30-89 dockerd[3730]: time="2025-01-04T12:38:05.524336125Z" level=info msg="Daemon has completed initialization"
Jan 04 12:38:05 ip-172-31-30-89 dockerd[3730]: time="2025-01-04T12:38:05.720755676Z" level=info msg="API listen on /run/docker.sock"
Jan 04 12:38:05 ip-172-31-30-89 systemd[1]: Started docker.service - Docker Application Container Engine.
lines 1-22/22 (END)
```
- а также версию установки:
```bash
ubuntu@ip-172-31-19-243:~$ docker -v
Docker version 27.4.1, build b9d17ea
```
- и запускаем тестовый контейнер
```bash
sudo docker run hello-world
```
<details>
<summary>Вывод лога запуска контейнера</summary>

```bash
ubuntu@ip-172-31-30-89:~$ sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
c1ec31eb5944: Pull complete
Digest: sha256:5b3cc85e16e3058003c13b7821318369dad01dac3dbb877aac3c28182255c724
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```
</details><br>

- проверяем наличие образов `sudo docker` images и контейнеров `sudo docker ps -a`

```bash
ubuntu@ip-172-31-30-89:~$ sudo docker images
REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
hello-world   latest    d2c94e258dcb   20 months ago   13.3kB
ubuntu@ip-172-31-30-89:~$
ubuntu@ip-172-31-30-89:~$ sudo docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                      PORTS     NAMES
ed0a0d69a03c   hello-world   "/hello"   22 seconds ago   Exited (0) 20 seconds ago             loving_merkle
```
- удалим этот контейнер `sudo docker rm`
```bash
ubuntu@ip-172-31-30-89:~$ sudo docker rm  loving_merkle
loving_merkle
```
**_UPD:_** _для того, чтобы не использовать каждый раз команду `sudo` при выполнение `docker` команд, добавим пользователя в группу `docker`:_
```bash
# если группа не создана создадим её и добавим пользователя
ubuntu@ip-172-31-30-89:~$ sudo groupadd docker
ubuntu@ip-172-31-30-89:~$ sudo usermod -aG docker $USER

ubuntu@ip-172-31-30-89:~$ getent group docker
docker:x:988:
ubuntu@ip-172-31-30-89:~$ sudo usermod -aG docker $USER
ubuntu@ip-172-31-30-89:~$ getent group docker
docker:x:988:ubuntu
```
Перезапустим сессию выйдя из ней и снова войдя или выполнив команду `newgrp docker` создающую новую ссесию.
```bash
ubuntu@ip-172-31-30-89:~$ newgrp docker
```
Далее установим и запустим контейнер на порту `28080` из официального образа nginx командой: `docker run -d -p 127.0.0.1:28080:80 --name nginx-01 nginx:stable`

```bash
ubuntu@ip-172-31-30-89:~$ docker run -d -p 127.0.0.1:28080:80 --name nginx-01 nginx:stable
Unable to find image 'nginx:stable' locally
stable: Pulling from library/nginx
fd674058ff8f: Pull complete
7182e7b8bb70: Pull complete
f54ce070d3ce: Pull complete
d5cc0a5fd30d: Pull complete
954f71c94ccf: Pull complete
2b90f21a19b0: Pull complete
a7f0ecbff445: Pull complete
Digest: sha256:df6f3c8e3fb6161cc5e85c8db042c8e62cfb7948fc4d6fddfad32741c3e2520d
Status: Downloaded newer image for nginx:stable
82d2c29c92311730293b2315a0ddcd6da41bd67e4657cc563098d94d37427fa2
```
и проверяем его работу:
```bash

ubuntu@ip-172-31-30-89:~$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                     NAMES
82d2c29c9231   nginx:stable   "/docker-entrypoint.…"   42 minutes ago   Up 42 minutes   127.0.0.1:28080->80/tcp   nginx-01
ubuntu@ip-172-31-30-89:~$
```
```bash
ubuntu@ip-172-31-30-89:~$ curl http://localhost:28080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
ubuntu@ip-172-31-30-89:~$
```
---
2. #### Point 2  
 #### Останови ранее запущенный контейнер командой: docker stop rbm-dkr-01. Выполни команду docker ps, тем самым проверь произошедшие изменения в списке запущенных контейнеров - список контейнеров должен быть пуст. При помощи утилиты curl запроси адрес http://127.0.0.1:28080 - сейчас должна быть ошибка, поскольку мы уже удалили контейнер и ничего не слушается на этом порту.

Остановим контейнер с сервером `nginx-01` командой `docker stop` и проверим его состояние:
```bash
ubuntu@ip-172-31-30-89:~$ docker stop nginx-01
nginx-01
```
и проверим доступность сервера
```bash
ubuntu@ip-172-31-30-89:~$ curl http://localhost:28080
curl: (7) Failed to connect to localhost port 28080 after 0 ms: Couldn't connect to server
```
---
3. #### Point 3  
 ####   При помощи команды docker ps -a выведи список всех контейнеров в системе - в списке будет твой остановленный контейнер. Останови запись в файл и загрузите полученные логи в репозиторий на gitlab.

Проверим состояние контейнера и образа:
```bash
ubuntu@ip-172-31-30-89:~$ docker image ls
REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
nginx         stable    29ef6eaebfc5   4 months ago    188MB
hello-world   latest    d2c94e258dcb   20 months ago   13.3kB
ubuntu@ip-172-31-30-89:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
ubuntu@ip-172-31-30-89:~$ docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS                     PORTS     NAMES
82d2c29c9231   nginx:stable   "/docker-entrypoint.…"   46 minutes ago   Exited (0) 6 seconds ago             nginx-01
ubuntu@ip-172-31-30-89:~$
```