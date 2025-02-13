#### Чекпоинты:

[1) Создать Dockerfile с параметризуемой версией Nginx, переменной окружения и файлом в /opt.](#point-1)  
[2) Собрать образ и передать необходимые аргументы, затем вывести список образов.](#point-2)  
[3) Запустить контейнер с переменной окружения, проверить список запущенных контейнеров и содержимое окружения.](#point-3)
[4) Собрать образ с новым именем без передачи аргументов (по-умолчанию), вывести список образов. Запустить контейнер без переменной окружения, проверить список запущенных контейнеров и содержимое окружения.](#point-4)
---

### 1. Point 1
#### Создадим Dockerfile с параметризуемой версией Nginx, переменной окружения и файлом в /opt.

  - Создадим файл `Dockerfile` со следующим содержимым, в котором создадим образ сервера и выведем версию софта в файл. Версию софта и наименование файла зададим через параметры сборки (со значениями по-умолчанию):
  
```dockerfile
ARG NG_VERSION=latest

FROM nginx:${NG_VERSION}

ARG NG_VERSION
ENV NG_VERSION=${NG_VERSION}

ARG ARG_FILE=default.txt

RUN touch /opt/${ARG_FILE} && \
echo "NG_VERSION=${NG_VERSION}" > /opt/${ARG_FILE}
```

---

### 2. Point 2
#### Соберем образ и передадим необходимые аргументы, выведем список образов.

  - Соберём образ с передачей аргументов `--build-arg NG_VERSION=stable` и `--build-arg ARG_FILE=example.txt`:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ docker build --build-arg NG_VERSION=stable --build-arg ARG_FILE=example.txt -t nginx:inno-dkr-10 .
[+] Building 0.7s (6/6) FINISHED                                                                                                                                                           docker:default
 => [internal] load build definition from Dockerfile                                                                                                                                                 0.0s
 => => transferring dockerfile: 249B                                                                                                                                                                 0.0s
 => [internal] load metadata for docker.io/library/nginx:stable                                                                                                                                      0.5s
 => [internal] load .dockerignore                                                                                                                                                                    0.0s
 => => transferring context: 2B                                                                                                                                                                      0.0s
 => [1/2] FROM docker.io/library/nginx:stable@sha256:ce438af5a52c680c72ecc85f9b51f84bbb517fa3cce9c8d25f010ed5ddd415d4                                                                                0.0s
 => CACHED [2/2] RUN touch /opt/example.txt &&     echo "NG_VERSION=stable" > /opt/example.txt                                                                                                       0.0s
 => exporting to image                                                                                                                                                                               0.1s
 => => exporting layers                                                                                                                                                                              0.0s
 => => writing image sha256:1f8e63aa2a70c3aa35a7397524098d2dd5b24008be0574dc60c4e80a7fd9b7dd                                                                                                         0.0s
 => => naming to docker.io/library/nginx:inno-dkr-10                             
```
  - Выведи список образов:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ docker images
REPOSITORY   TAG           IMAGE ID       CREATED          SIZE
nginx        inno-dkr-10   05f46d7a01b1   16 minutes ago   192MB
```
---

### 3. Point 3
#### Запустим контейнер с переменной окружения `-e INNO=DKR10`, проверь список запущенных контейнеров и содержимое окружения и файла.

  - Запустим контейнер в фоновом режиме:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ docker run -d --name inno-dkr-10 -e INNO=DKR10 nginx:inno-dkr-10
5bfb6454ae5e96f047f25174d05ca8fbfe5fe4bac4286de85013bba087c11109
```
  - Выведим список запущенных контейнеров:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ docker ps -a
CONTAINER ID   IMAGE               COMMAND                  CREATED              STATUS              PORTS     NAMES
5bfb6454ae5e   nginx:inno-dkr-10   "/docker-entrypoint.…"   About a minute ago   Up About a minute   80/tcp    inno-dkr-10
```
  - Проверим ВСЕ переменные окружения в контейнере:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ docker exec inno-dkr-10 printenv
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=5bfb6454ae5e
INNO=DKR10
NGINX_VERSION=1.26.3
NJS_VERSION=0.8.9
NJS_RELEASE=1~bookworm
PKG_RELEASE=1~bookworm
DYNPKG_RELEASE=2~bookworm
NG_VERSION=stable
HOME=/root
```
или только интересующие нас добавление на этапе сборки и запуска:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ docker exec inno-dkr-10 printenv  | grep NG_VERSION
NG_VERSION=stable
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ docker exec inno-dkr-10 printenv | grep INNO
INNO=DKR10
```
  - Выведи список файлов в `/opt/` и содержимое:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ docker exec inno-dkr-10 ls -l /opt/
total 4
-rw-r--r-- 1 root root 18 Feb 13 15:02 example.txt
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ docker exec inno-dkr-10 cat  /opt/example.txt
NG_VERSION=stable
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$
```

### 4. Point 4
#### Собрать образ с новым именем без передачи аргументов (по-умолчанию), вывести список образов. Запустить контейнер без переменной окружения, проверить список запущенных контейнеров и содержимое окружения.

- Соберём образ c именем `nginx:inno-dkr-11` без указания аргументов (по-умолчанию):
```bash 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ docker build -t nginx:inno-dkr-11 .
[+] Building 1.4s (7/7) FINISHED                                                                                                                                                           docker:default
=> [internal] load build definition from Dockerfile                                                                                                                                                 0.0s
=> => transferring dockerfile: 249B                                                                                                                                                                 0.0s 
=> [internal] load metadata for docker.io/library/nginx:latest                                                                                                                                      1.0s 
=> [auth] library/nginx:pull token for registry-1.docker.io                                                                                                                                         0.0s
=> [internal] load .dockerignore                                                                                                                                                                    0.0s
=> => transferring context: 2B                                                                                                                                                                      0.0s 
=> CACHED [1/2] FROM docker.io/library/nginx:latest@sha256:91734281c0ebfc6f1aea979cffeed5079cfe786228a71cc6f1f46a228cde6e34                                                                         0.0s 
=> [2/2] RUN touch /opt/default.txt &&     echo "NG_VERSION=latest" > /opt/default.txt                                                                                                              0.2s 
=> exporting to image                                                                                                                                                                               0.1s
=> => exporting layers                                                                                                                                                                              0.0s 
=> => writing image sha256:ba03b36c50730d87954f2bcb6df5b9eff41a0a48b0cee7239a887f0b6b026a06                                                                                                         0.0s 
=> => naming to docker.io/library/nginx:inno-dkr-11
```
- Выведем список образов:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ docker images
REPOSITORY   TAG           IMAGE ID       CREATED          SIZE
nginx        inno-dkr-11   ba03b36c5073   2 minutes ago    192MB
nginx        inno-dkr-10   1f8e63aa2a70   40 minutes ago   192MB
```
- Запустим новый контейнер в фоновом режиме, проверим переменные окружения в контейнере и созданый файл:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ docker run -d --name inno-dkr-11 nginx:inno-dkr-11
b443b75bc4c4b4b279c79a4df2b741f4da2315a596acd5394e5f4b7a3644f09d
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ docker exec inno-dkr-11 printenv
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=b443b75bc4c4
NGINX_VERSION=1.27.4
NJS_VERSION=0.8.9
NJS_RELEASE=1~bookworm
PKG_RELEASE=1~bookworm
DYNPKG_RELEASE=1~bookworm
NG_VERSION=latest
HOME=/root
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ docker exec inno-dkr-11 ls -l /opt/
total 4
-rw-r--r-- 1 root root 18 Feb 13 15:41 default.txt
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.20$ 
```