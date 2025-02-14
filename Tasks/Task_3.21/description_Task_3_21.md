#### Чекпоинты:

1. [Создать тестовый файл `testfile` размером 10МБ.](#point-1)
2. [Собрать образ из предоставленного Dockerfile.](#point-2)
3. [Проанализировать образ, размер образа и историю слоев образа.](#point-3)
4. [Оптимизация Dockerfile](#point-4)
5. [Сборка и анализ оптимизированного Docker-образа. Сравнение default и optimized образов.](#point-5)

#### 1. Point 1
**Создадим тестовый файл `testfile` размером 10МБ:**
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.21$ head -c 10M /dev/zero > testfile.txt
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.21$ ls -lh testfile.txt
-rwxrwxrwx 1 yarik yarik 10M Feb 13 18:37 testfile.txt
```
#### 2. Point 2
**Собрать образ из предоставленного Dockerfile по-умолчанию:**
 - Создадим дефолтный dockerfile  - `default.Dockerfile`:
```dockerfile
FROM ubuntu:20.04
ENV testenv1=env1

RUN groupadd --gid 2000 user && useradd --uid 2000 --gid 2000 --shell /bin/bash --create-home user
RUN ls -lah /var/lib/apt/lists/
RUN apt-get update -y && apt-get install nginx -y
RUN ls -lah /var/lib/apt/lists/
RUN rm -rf /var/lib/apt/lists/*
RUN ls -lah /var/lib/apt/lists/

COPY testfile .

RUN chown user:user testfile
USER user

CMD ["sleep infinity"]
```
 - Собрать образ на его основе (буду использовать `buildx` для безопасной root-less сборки):
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.21$ docker buildx build -t inno-dkr-11:default -f default.Dockerfile  .
[+] Building 16.6s (14/14) FINISHED                                                                                                                                                                                                                           docker:default
 => [internal] load build definition from default.Dockerfile                                                                                                                                                                                                            0.1s
 => => transferring dockerfile: 460B                                                                                                                                                                                                                                    0.0s 
 => [internal] load metadata for docker.io/library/ubuntu:20.04                                                                                                                                                                                                         0.0s 
 => [internal] load .dockerignore                                                                                                                                                                                                                                       0.0s 
 => => transferring context: 2B                                                                                                                                                                                                                                         0.0s 
 => [1/9] FROM docker.io/library/ubuntu:20.04                                                                                                                                                                                                                           0.0s
 => [internal] load build context                                                                                                                                                                                                                                       0.2s 
 => => transferring context: 10.49MB                                                                                                                                                                                                                                    0.2s 
 => [2/9] RUN groupadd --gid 2000 user && useradd --uid 2000 --gid 2000 --shell /bin/bash --create-home user                                                                                                                                                            0.5s 
 => [3/9] RUN ls -lah /var/lib/apt/lists/                                                                                                                                                                                                                               0.4s
 => [4/9] RUN apt-get update -y && apt-get install nginx -y                                                                                                                                                                                                            13.1s
 => [5/9] RUN ls -lah /var/lib/apt/lists/                                                                                                                                                                                                                               0.4s
 => [6/9] RUN rm -rf /var/lib/apt/lists/*                                                                                                                                                                                                                               0.5s
 => [7/9] RUN ls -lah /var/lib/apt/lists/                                                                                                                                                                                                                               0.4s
 => [8/9] COPY testfile .                                                                                                                                                                                                                                               0.1s
 => [9/9] RUN chown user:user testfile                                                                                                                                                                                                                                  0.5s
 => exporting to image                                                                                                                                                                                                                                                  0.5s
 => => exporting layers                                                                                                                                                                                                                                                 0.4s
 => => writing image sha256:670af4d231493541b89cf1c8c6ed35f7ea18c72899b70ad7c41025642901d5f4                                                                                                                                                                            0.0s
 => => naming to docker.io/library/inno-dkr-11:default                                                                                                                                                                                                                  0.0s 

```

#### 3. Point 3
**Проанализировать образ, размер образа и историю слоев образа.:**
 - Размер образа:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.21$ docker images 
REPOSITORY                      TAG                  IMAGE ID       CREATED          SIZE
inno-dkr-11                     default              670af4d23149   12 minutes ago   210MB
```
 - Посмотреть историю слоев образа:
```bash
docker history inno-dkr-11:default --no-trunc

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.21$ docker history inno-dkr-11:default --no-trunc
IMAGE                                                                     CREATED        CREATED BY                                                                                                                 SIZE      COMMENT
sha256:dddb44dc829fe3669fc7095f2236a4a68d26a278e78afc0b7653f04aba71e351   21 hours ago   CMD ["sleep infinity"]                                                                                                     0B        buildkit.dockerfile.v0
<missing>                                                                 21 hours ago   USER user                                                                                                                  0B        buildkit.dockerfile.v0
<missing>                                                                 21 hours ago   RUN /bin/sh -c chown user:user testfile # buildkit                                                                         10.5MB    buildkit.dockerfile.v0
<missing>                                                                 21 hours ago   COPY testfile . # buildkit                                                                                                 10.5MB    buildkit.dockerfile.v0
<missing>                                                                 21 hours ago   RUN /bin/sh -c ls -lah /var/lib/apt/lists/ # buildkit                                                                      0B        buildkit.dockerfile.v0
<missing>                                                                 21 hours ago   RUN /bin/sh -c rm -rf /var/lib/apt/lists/* # buildkit                                                                      0B        buildkit.dockerfile.v0
<missing>                                                                 21 hours ago   RUN /bin/sh -c ls -lah /var/lib/apt/lists/ # buildkit                                                                      0B        buildkit.dockerfile.v0
<missing>                                                                 21 hours ago   RUN /bin/sh -c apt-get update -y && apt-get install nginx -y # buildkit                                                    115MB     buildkit.dockerfile.v0
<missing>                                                                 21 hours ago   RUN /bin/sh -c ls -lah /var/lib/apt/lists/ # buildkit                                                                      0B        buildkit.dockerfile.v0
<missing>                                                                 21 hours ago   RUN /bin/sh -c groupadd --gid 2000 user && useradd --uid 2000 --gid 2000 --shell /bin/bash --create-home user # buildkit   658kB     buildkit.dockerfile.v0
<missing>                                                                 21 hours ago   ENV testenv1=env1                                                                                                          0B        buildkit.dockerfile.v0
<missing>                                                                 4 months ago   /bin/sh -c #(nop)  CMD ["/bin/bash"]                                                                                       0B
<missing>                                                                 4 months ago   /bin/sh -c #(nop) ADD file:7486147a645d8835a5181c79f00a3606c6b714c83bcbfcd8862221eb14690f9e in /                           72.8MB
<missing>                                                                 4 months ago   /bin/sh -c #(nop)  LABEL org.opencontainers.image.version=20.04                                                            0B
<missing>                                                                 4 months ago   /bin/sh -c #(nop)  LABEL org.opencontainers.image.ref.name=ubuntu                                                          0B
<missing>                                                                 4 months ago   /bin/sh -c #(nop)  ARG LAUNCHPAD_BUILD_ARCH                                                                                0B
<missing>                                                                 4 months ago   /bin/sh -c #(nop)  ARG RELEASE                                                                                             0B
```
   - Обратить внимание:
     - У всех ли слоев есть размер?
     - Какие три директивы создают слои? (см. "Best practices for writing Dockerfile", раздел "Minimize the number of layers")
     - Как повлияла директива `RUN chown user:user testfile` на размер образа?
 - Можно посмотреть структуру образа через команду `docker inspect inno-dkr-11:default` (вывод не прилагаю).


#### 4. Point 4
**Оптимизация Dockerfile и образов:**

 - Оптимизируем Dockerfile и изменим строки с установкой зависимостей  и назнаяением прав на файл :
```dockerfile
RUN apt-get update -y && apt-get install nginx -y && apt-get clean && rm -rf /var/lib/apt/lists/*
```
и 
```dockerfile
COPY --chown=user:user testfile .
```
  Оптимизированный `optimized.Dockerfile` здесь  [optimized.Dockerfile](optimized.Dockerfile)

5. #### Point 5 
**Сборка и анализ оптимизированного Docker-образа. Сравнение default и optimized образов.**

 - Соберем  оптимизированный образ:
```bash

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.21$ docker buildx build -t inno-dkr-11:optimized -f optimized.Dockerfile .
[+] Building 16.8s (14/14) FINISHED                                                                                                                                                                                                                           docker:default
 => [internal] load build definition from optimized.Dockerfile                                                                                                                                                                                                          0.0s
 => => transferring dockerfile: 498B                                                                                                                                                                                                                                    0.0s 
 => [internal] load metadata for docker.io/library/ubuntu:20.04                                                                                                                                                                                                         1.2s 
 => [auth] library/ubuntu:pull token for registry-1.docker.io                                                                                                                                                                                                           0.0s
 => [internal] load .dockerignore                                                                                                                                                                                                                                       0.0s
 => => transferring context: 2B                                                                                                                                                                                                                                         0.0s 
 => [1/8] FROM docker.io/library/ubuntu:20.04@sha256:8e5c4f0285ecbb4ead070431d29b576a530d3166df73ec44affc1cd27555141b                                                                                                                                                   0.0s 
 => [internal] load build context                                                                                                                                                                                                                                       0.0s 
 => => transferring context: 32B                                                                                                                                                                                                                                        0.0s 
 => CACHED [2/8] RUN groupadd --gid 2000 user && useradd --uid 2000 --gid 2000 --shell /bin/bash --create-home user                                                                                                                                                     0.0s 
 => CACHED [3/8] RUN ls -lah /var/lib/apt/lists/                                                                                                                                                                                                                        0.0s 
 => [4/8] RUN apt-get update -y && apt-get install nginx -y && apt-get clean && rm -rf /var/lib/apt/lists/*                                                                                                                                                            13.7s
 => [5/8] RUN ls -lah /var/lib/apt/lists/                                                                                                                                                                                                                               0.3s
 => [6/8] RUN rm -rf /var/lib/apt/lists/*                                                                                                                                                                                                                               0.5s
 => [7/8] RUN ls -lah /var/lib/apt/lists/                                                                                                                                                                                                                               0.5s
 => [8/8] COPY --chown=user:user testfile .                                                                                                                                                                                                                             0.1s
 => exporting to image                                                                                                                                                                                                                                                  0.4s
 => => exporting layers                                                                                                                                                                                                                                                 0.3s
 => => writing image sha256:5e1c770f838b60a9e9830c2c5fb7908f4d9e136123505a84037c5e5a2d46787c                                                                                                                                                                            0.0s
 => => naming to docker.io/library/inno-dkr-11:optimized                                      
```

 - Сравним размеры итоговых образов:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.21$ docker images 
REPOSITORY    TAG         IMAGE ID       CREATED         SIZE
inno-dkr-11   optimized   5e1c770f838b   7 seconds ago   143MB
inno-dkr-11   default     dddb44dc829f   21 hours ago    210MB
```

   - Сравнить количество и размеры слоев с `inno-dkr-11:default`.
```bash
docker history inno-dkr-11:optimized --no-trunc
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.21$ docker history inno-dkr-11:optimized --no-trunc
IMAGE                                                                     CREATED         CREATED BY                                                                                                                 SIZE      COMMENT
sha256:5e1c770f838b60a9e9830c2c5fb7908f4d9e136123505a84037c5e5a2d46787c   7 minutes ago   CMD ["sleep infinity"]                                                                                                     0B        buildkit.dockerfile.v0
<missing>                                                                 7 minutes ago   USER user                                                                                                                  0B        buildkit.dockerfile.v0
<missing>                                                                 7 minutes ago   COPY --chown=user:user testfile . # buildkit                                                                               10.5MB    buildkit.dockerfile.v0
<missing>                                                                 7 minutes ago   RUN /bin/sh -c ls -lah /var/lib/apt/lists/ # buildkit                                                                      0B        buildkit.dockerfile.v0
<missing>                                                                 7 minutes ago   RUN /bin/sh -c rm -rf /var/lib/apt/lists/* # buildkit                                                                      0B        buildkit.dockerfile.v0
<missing>                                                                 7 minutes ago   RUN /bin/sh -c ls -lah /var/lib/apt/lists/ # buildkit                                                                      0B        buildkit.dockerfile.v0
<missing>                                                                 7 minutes ago   RUN /bin/sh -c apt-get update -y && apt-get install nginx -y && apt-get clean && rm -rf /var/lib/apt/lists/* # buildkit    59.3MB    buildkit.dockerfile.v0
<missing>                                                                 21 hours ago    RUN /bin/sh -c ls -lah /var/lib/apt/lists/ # buildkit                                                                      0B        buildkit.dockerfile.v0
<missing>                                                                 21 hours ago    RUN /bin/sh -c groupadd --gid 2000 user && useradd --uid 2000 --gid 2000 --shell /bin/bash --create-home user # buildkit   658kB     buildkit.dockerfile.v0
<missing>                                                                 21 hours ago    ENV testenv1=env1                                                                                                          0B        buildkit.dockerfile.v0
<missing>                                                                 4 months ago    /bin/sh -c #(nop)  CMD ["/bin/bash"]                                                                                       0B
<missing>                                                                 4 months ago    /bin/sh -c #(nop) ADD file:7486147a645d8835a5181c79f00a3606c6b714c83bcbfcd8862221eb14690f9e in /                           72.8MB
<missing>                                                                 4 months ago    /bin/sh -c #(nop)  LABEL org.opencontainers.image.version=20.04                                                            0B
<missing>                                                                 4 months ago    /bin/sh -c #(nop)  LABEL org.opencontainers.image.ref.name=ubuntu                                                          0B
<missing>                                                                 4 months ago    /bin/sh -c #(nop)  ARG LAUNCHPAD_BUILD_ARCH                                                                                0B
<missing>                                                                 4 months ago    /bin/sh -c #(nop)  ARG RELEASE                                                                                             0B
```


Как результат видим уменьшение объема образа (`143MB` взамен `210MB`) за счет уменьшения слоя c директивой `RUN` с установкой зависимостей системы и слоя `COPY` c флагом назначения прав на копируемый файл взамен отдельной директивы `RUN`


Используемые Dockerfiles: здесь [optimized.Dockerfile](optimized.Dockerfile) и здесь  [default.Dockerfile](default.Dockerfile)
