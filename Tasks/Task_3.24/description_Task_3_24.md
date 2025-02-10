#### Чекпоинты:

[1) Склонировать директорию `gocalc`.](#point-1)  
[2) Написать `Dockerfile` с Multi-stage build для `gocalc`.](#point-2)  
[3) Собрать образ, вывести список образов, изучить `history`, запушить в GitLab.](#point-3)  
[4) Модифицировать `Dockerfile` без использования именованных этапов.](#point-4)  
[5) Склонировать репозиторий `grafana` из ветки `v6.3.x`.](#point-5)  
[7) Добавить в `Dockerfile` новый образ на базе `nginx:alpine` и скопировать в него скомпилированную статику (`public`).](#point-7)  
[8) Собрать отдельно образ с `nginx` и отдельно с приложением, выставить теги `grafana:app` и `grafana:static`, вывести список образов.](#point-8)  

---

### Подробное описание шагов:

#### Point 1
**Склонировать директорию `gocalc`** 
- Откройте терминал и выполните команду:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ git clone https://devops-gitlab.inno.ws/devops-board/docker.git && cd docker
Cloning into 'docker'...
remote: Enumerating objects: 12, done.
remote: Counting objects: 100% (12/12), done.
remote: Compressing objects: 100% (7/7), done.
remote: Total 12 (delta 3), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (12/12), done.
Resolving deltas: 100% (3/3), done.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker$ ls
dkr-nginx-conf-1  dkr-nginx-conf-2  dkr-nginx-conf-3  dkr-nginx-conf-4  gocalc
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker$ cd gocalc
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ ls
main.go 
```
#### Point 2
**Написать `Dockerfile` с Multi-stage build для `gocalc`**
- Создадим файл `Dockerfile` со следующим содержимым с учетом всех требований (с учетом того что указана устаревшая версия golang:1.19.1, а зависимости в коде требуют более новой версии используем текущую актуальную 1.22.12 и создадим дополнительно `go.mod` для получения зависимостей):
- 
```dockerfile
# first stage
FROM golang:1.22.12-alpine AS build

WORKDIR /app
ENV GO111MODULE=auto

# set git and deps
RUN apk add --no-cache git

# create go.mod
RUN go mod init gocalc

# Копируем main.go
COPY main.go .

# get deps
RUN go mod tidy
RUN go mod download

# app build
RUN go build -o app

# runtime build
FROM alpine:3.10.3
WORKDIR /root/
COPY --from=build /app/app .

CMD ["./app"]
```

#### Point 3
**Собрать образ, вывести список образов, изучить `history`, запушить в GitLab**
- Выполните команды:
```bash
docker build -t gocalc:latest .
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ docker build -t gocalc:latest .
```
<details>
<summary>Подробный лог сборки</summary>

```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ docker build -t gocalc:latest .
failed to fetch metadata: fork/exec /usr/local/lib/docker/cli-plugins/docker-buildx: no such file or directory

DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  50.18kB
Step 1/13 : FROM golang:1.22.12-alpine AS build
 ---> 4129f51f28c9
Step 2/13 : WORKDIR /app
 ---> Using cache
 ---> e8dc9a318f67
Step 3/13 : ENV GO111MODULE=auto
 ---> Using cache
 ---> d0a4af46e050
Step 4/13 : RUN apk add --no-cache git
 ---> Using cache
 ---> b895b13bc463
Step 5/13 : RUN go mod init gocalc
 ---> Running in 651b3ab2497b
go: creating new go.mod: module gocalc
 ---> Removed intermediate container 651b3ab2497b
 ---> 1dd4b60f5368
Step 6/13 : COPY main.go .
 ---> 4812412e1c55
Step 7/13 : RUN go mod tidy
 ---> Running in 9407f729056f
go: finding module for package github.com/prometheus/client_golang/prometheus/promhttp
go: finding module for package github.com/caarlos0/env
go: finding module for package github.com/prometheus/client_golang/prometheus
go: finding module for package github.com/lib/pq
go: downloading github.com/caarlos0/env v3.5.0+incompatible
go: downloading github.com/prometheus/client_golang v1.20.5
go: downloading github.com/lib/pq v1.10.9
go: found github.com/caarlos0/env in github.com/caarlos0/env v3.5.0+incompatible
go: found github.com/lib/pq in github.com/lib/pq v1.10.9
go: found github.com/prometheus/client_golang/prometheus in github.com/prometheus/client_golang v1.20.5
go: found github.com/prometheus/client_golang/prometheus/promhttp in github.com/prometheus/client_golang v1.20.5
go: downloading github.com/cespare/xxhash/v2 v2.3.0
go: downloading github.com/prometheus/common v0.55.0
go: downloading github.com/prometheus/client_model v0.6.1
go: downloading golang.org/x/sys v0.22.0
go: downloading github.com/beorn7/perks v1.0.1
go: downloading github.com/prometheus/procfs v0.15.1
go: downloading google.golang.org/protobuf v1.34.2
go: downloading github.com/klauspost/compress v1.17.9
go: downloading github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822
go: downloading github.com/kylelemons/godebug v1.1.0
go: downloading github.com/google/go-cmp v0.6.0
go: downloading github.com/stretchr/testify v1.9.0
go: downloading github.com/davecgh/go-spew v1.1.1
go: downloading github.com/pmezard/go-difflib v1.0.0
go: downloading gopkg.in/yaml.v3 v3.0.1
 ---> Removed intermediate container 9407f729056f
 ---> 4007e28d464f
Step 8/13 : RUN go mod download
 ---> Running in 12a772d290da
 ---> Removed intermediate container 12a772d290da
 ---> 969b8c94697f
Step 9/13 : RUN go build -o app
 ---> Running in 591747d729a7
 ---> Removed intermediate container 591747d729a7
 ---> 61ff88464c93
Step 10/13 : FROM alpine:3.10.3
3.10.3: Pulling from library/alpine
89d9c30c1d48: Pull complete
Digest: sha256:c19173c5ada610a5989151111163d28a67368362762534d8a8121ce95cf2bd5a
Status: Downloaded newer image for alpine:3.10.3
 ---> 965ea09ff2eb
Step 11/13 : WORKDIR /root/
 ---> Running in bafb3722a95d
 ---> Removed intermediate container bafb3722a95d
 ---> a91e26f88fb4
Step 12/13 : COPY --from=build /app/app .
 ---> a4b2350eb2c6
Step 13/13 : CMD ["./app"]
 ---> Running in 601ac192ae34
 ---> Removed intermediate container 601ac192ae34
 ---> 65b3c20437cd
Successfully built 65b3c20437cd
Successfully tagged gocalc:latest

```
</details><br>

 - получим список образов и историю:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ docker images
REPOSITORY                      TAG              IMAGE ID       CREATED          SIZE
gocalc                          latest           65b3c20437cd   15 minutes ago   17.5MB
<none>                          <none>           61ff88464c93   15 minutes ago   480MB
golang                          1.22.12-alpine   4129f51f28c9   5 days ago       231MB

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ docker history gocalc:latest
IMAGE          CREATED          CREATED BY                                      SIZE      COMMENT
65b3c20437cd   16 minutes ago   /bin/sh -c #(nop)  CMD ["./app"]                0B
a4b2350eb2c6   16 minutes ago   /bin/sh -c #(nop) COPY file:191d576ba00ce414…   11.9MB
a91e26f88fb4   16 minutes ago   /bin/sh -c #(nop) WORKDIR /root                 0B
965ea09ff2eb   5 years ago      /bin/sh -c #(nop)  CMD ["/bin/sh"]              0B
<missing>      5 years ago      /bin/sh -c #(nop) ADD file:fe1f09249227e2da2…   5.55MB
```
- запушим в удаленный репозиторий созданный Dockerfile, для чего сначала создадим новый удаленный репозиторий:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ glab repo create https://devops-gitlab.inno.ws/api/v4/doc
ker-lab --group learn-labs --internal --description "This is the docker-lab  repository"
✓ Created repository LearnLabs  / docker-lab on GitLab: https://devops-gitlab.inno.ws/learn-labs/docker-lab
? Create a local project directory for LearnLabs  / docker-lab? No                                                           
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ 

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ git remote add origin https://devops-gitlab.inno.ws/learn-labs/docker-lab
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ git remote -v 
origin  https://devops-gitlab.inno.ws/learn-labs/docker-lab (fetch)
origin  https://devops-gitlab.inno.ws/learn-labs/docker-lab (push)
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ git add Dockerfile 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ git commit -m "Dockerfile с multi-stage build"
[main (root-commit) bdbbed2] Dockerfile с multi-stage build
 1 file changed, 29 insertions(+)
 create mode 100644 Dockerfile

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ git push --set-upstream origin main
warning: redirecting to https://devops-gitlab.inno.ws/learn-labs/docker-lab.git/
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Delta compression using up to 8 threads
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 587 bytes | 53.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
To https://devops-gitlab.inno.ws/learn-labs/docker-lab
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```
UPD: Дополнительно можем запушить собраный образ в gitlab regestry проекта.
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ docker login devops-registry.inno.ws
Username: yaraslau.alenchyk@innowise.com
Password: 
Login Succeeded
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$  
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ docker tag gocalc:latest  devops-registry.inno.ws/yaraslau.alenchyk/devops-trainee/gocalc:lates
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ docker push  devops-registry.inno.ws/yaraslau.alenchyk/devops-trainee/gocalc:lates
The push refers to repository [devops-registry.inno.ws/yaraslau.alenchyk/devops-trainee/gocalc]
92f258618d69: Pushed
77cae8ab23bf: Pushed
lates: digest: sha256:8d1c533c1735c646db2f5294171f7a2d9cbfcd1ac725918e65a9da7667dca95f size: 739
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ 
```

#### Point 4 
**Модифицировать `Dockerfile` без использования именованных этапов**
- Изменим `Dockerfile`, модифицировав таким образом, что он не должен использовать именованный этап (директива FROM не должна содержать параметр AS у образа сборщика, и COPY --from= не должен ссылаться на имя). Добавим директиву ARG с секретом в первый образ и запишим его значение в файл в конечном образе:
```dockerfile
# First stage: Build the application
FROM golang:1.22.12-alpine

WORKDIR /app
ENV GO111MODULE=auto

# ARG directive for the secret in the first image
ARG SECRET_KEY

# Install dependencies (git in this case)
RUN apk add --no-cache git

# Create a go.mod file for Go module
RUN go mod init gocalc

# Copy the main.go file into the container
COPY main.go .

# Install dependencies (go modules)
RUN go mod tidy
RUN go mod download

# Build the Go application
RUN go build -o app

# Second stage: The final image with the application
FROM alpine:3.10.3

WORKDIR /root/

# Copy the built application from the first stage (using index 0)
COPY --from=0 /app/app .

# Write the value of SECRET_KEY to a file in the final image
RUN echo $SECRET_KEY > /root/secret_key.txt

# Set the default command to run the application
CMD ["./app"]
```

- соберем образ `docker build --build-arg SECRET_KEY=my_secret_value -t mygocalc:latest .`
<details>
<summary>Подробный лог сборки</summary>

```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ docker build --build-arg SECRET_KEY=my_secret_value -t mygocalc:latest .
failed to fetch metadata: fork/exec /usr/local/lib/docker/cli-plugins/docker-buildx: no such file or directory

DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  66.05kB
Step 1/15 : FROM golang:1.22.12-alpine
 ---> 4129f51f28c9
Step 2/15 : WORKDIR /app
 ---> Using cache
 ---> e8dc9a318f67
Step 3/15 : ENV GO111MODULE=auto
 ---> Using cache
 ---> d0a4af46e050
Step 4/15 : ARG SECRET_KEY
 ---> Running in 8e7a13836d4e
 ---> Removed intermediate container 8e7a13836d4e
 ---> 46dab91e52f8
Step 5/15 : RUN apk add --no-cache git
 ---> Running in 74241143b80b
fetch https://dl-cdn.alpinelinux.org/alpine/v3.21/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.21/community/x86_64/APKINDEX.tar.gz
(1/12) Installing brotli-libs (1.1.0-r2)
(2/12) Installing c-ares (1.34.3-r0)
(3/12) Installing libunistring (1.2-r0)
(4/12) Installing libidn2 (2.3.7-r0)
(5/12) Installing nghttp2-libs (1.64.0-r0)
(6/12) Installing libpsl (0.21.5-r3)
(7/12) Installing zstd-libs (1.5.6-r2)
(8/12) Installing libcurl (8.12.0-r0)
(9/12) Installing libexpat (2.6.4-r0)
(10/12) Installing pcre2 (10.43-r0)
(11/12) Installing git (2.47.2-r0)
(12/12) Installing git-init-template (2.47.2-r0)
Executing busybox-1.37.0-r9.trigger
OK: 19 MiB in 28 packages
 ---> Removed intermediate container 74241143b80b
 ---> 0761985988e8
Step 6/15 : RUN go mod init gocalc
 ---> Running in 214c9a5f4997
go: creating new go.mod: module gocalc
 ---> Removed intermediate container 214c9a5f4997
 ---> d0f7a73d0cab
Step 7/15 : COPY main.go .
 ---> dcb0e8b3eee3
Step 8/15 : RUN go mod tidy
 ---> Running in 1535ba06eed2
go: finding module for package github.com/prometheus/client_golang/prometheus/promhttp
go: finding module for package github.com/lib/pq
go: finding module for package github.com/caarlos0/env
go: finding module for package github.com/prometheus/client_golang/prometheus
go: downloading github.com/prometheus/client_golang v1.20.5
go: downloading github.com/lib/pq v1.10.9
go: downloading github.com/caarlos0/env v3.5.0+incompatible
go: found github.com/caarlos0/env in github.com/caarlos0/env v3.5.0+incompatible
go: found github.com/lib/pq in github.com/lib/pq v1.10.9
go: found github.com/prometheus/client_golang/prometheus in github.com/prometheus/client_golang v1.20.5
go: found github.com/prometheus/client_golang/prometheus/promhttp in github.com/prometheus/client_golang v1.20.5
go: downloading github.com/klauspost/compress v1.17.9
go: downloading github.com/prometheus/client_model v0.6.1
go: downloading github.com/prometheus/common v0.55.0
go: downloading google.golang.org/protobuf v1.34.2
go: downloading github.com/cespare/xxhash/v2 v2.3.0
go: downloading github.com/beorn7/perks v1.0.1
go: downloading github.com/prometheus/procfs v0.15.1
go: downloading golang.org/x/sys v0.22.0
go: downloading github.com/kylelemons/godebug v1.1.0
go: downloading github.com/google/go-cmp v0.6.0
go: downloading github.com/munnerz/goautoneg v0.0.0-20191010083416-a7dc8b61c822
go: downloading github.com/stretchr/testify v1.9.0
go: downloading github.com/davecgh/go-spew v1.1.1
go: downloading gopkg.in/yaml.v3 v3.0.1
go: downloading github.com/pmezard/go-difflib v1.0.0
 ---> Removed intermediate container 1535ba06eed2
 ---> 4eff67cd4511
Step 9/15 : RUN go mod download
 ---> Running in 71096be611d0
 ---> Removed intermediate container 71096be611d0
 ---> 27a25a7abaef
Step 10/15 : RUN go build -o app
 ---> Running in 38a8699af938
 ---> Removed intermediate container 38a8699af938
 ---> c27676d0ea4f
Step 11/15 : FROM alpine:3.10.3
 ---> 965ea09ff2eb
Step 12/15 : WORKDIR /root/
 ---> Using cache
 ---> a91e26f88fb4
Step 13/15 : COPY --from=0 /app/app .
 ---> Using cache
 ---> a4b2350eb2c6
Step 14/15 : RUN echo $SECRET_KEY > /root/secret_key.txt
 ---> Running in 372fbef46053
 ---> Removed intermediate container 372fbef46053
 ---> 007e05296dbc
Step 15/15 : CMD ["./app"]
 ---> Running in adbb8c337a49
 ---> Removed intermediate container adbb8c337a49
 ---> fcd2dd67e32c
Successfully built fcd2dd67e32c
Successfully tagged mygocalc:latest
```
</details><br>

- Проверим список образов:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ docker images
REPOSITORY                                                        TAG              IMAGE ID       CREATED         SIZE
mygocalc                                                          latest           fcd2dd67e32c   3 minutes ago   17.5MB
<none>                                                            <none>           c27676d0ea4f   3 minutes ago   480MB
devops-registry.inno.ws/yaraslau.alenchyk/devops-trainee/gocalc   lates            65b3c20437cd   3 hours ago     17.5MB
gocalc                                                            latest           65b3c20437cd   3 hours ago     17.5MB
<none>                                                            <none>           61ff88464c93   3 hours ago     480MB
golang                                                            1.22.12-alpine   4129f51f28c9   6 days ago      231MB
```
- Запушим изменения в репозиторий
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ git add .
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ git commit -m "Modifided Dockerfile"
[main e3ad64b] Modifided Dockerfile
 2 files changed, 111 insertions(+), 10 deletions(-)
 create mode 100644 main.go
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ ls
Dockerfile  main.go
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/docker/gocalc$ git push 
warning: redirecting to https://devops-gitlab.inno.ws/learn-labs/docker-lab.git/
Enumerating objects: 6, done.
Counting objects: 100% (6/6), done.
Delta compression using up to 8 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 1.67 KiB | 131.00 KiB/s, done.
Total 4 (delta 0), reused 0 (delta 0), pack-reused 0
To https://devops-gitlab.inno.ws/learn-labs/docker-lab
   bdbbed2..e3ad64b  main -> main
```

#### Point 5
**Склонируем репозиторий `grafana` из ветки `v6.3.x`**
- Выполните команду:
```bash
git clone -b v6.3.0 https://github.com/grafana/grafana.git && cd grafana
```

#### [7) Добавить в `Dockerfile` новый образ на базе `nginx:alpine` и скопировать в него статику. Собрать отдельно образ с `nginx` и отдельно с приложением, выставить теги `grafana:app` и `grafana:static`, вывести список образов](#point-7)
- Будем собирать образы из одного Dockerfile c использованием флага `-target`. Для этого откроем существующий `Dockerfile` и изменим его, добавив финальные этапы сборки :
```dockerfile
# Final stage for Grafana application image
FROM alpine:3.10.3 as grafana_app

# --------------------------------------------------
# Final stage for NGINX static files image
FROM nginx:alpine as grafana_static

# Copy the compiled static files from js-builder stage
COPY --from=js-builder /usr/src/app/public /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```
<details><summary>Весь файл Dockerfile.new </summary>

```dockerfile
# JS build stage: Build static assets
FROM node:14.15.1-alpine3.12 as js-builder

WORKDIR /usr/src/app/

COPY package.json yarn.lock ./
COPY packages packages

RUN yarn install --pure-lockfile --no-progress

COPY tsconfig.json .eslintrc .editorconfig .browserslistrc .prettierrc.js ./
COPY public public
COPY tools tools
COPY scripts scripts
COPY emails emails

ENV NODE_ENV production
RUN yarn build

# Go build stage: Build Grafana application
FROM golang:1.15.1-alpine3.12 as go-builder

RUN apk add --no-cache gcc g++

WORKDIR $GOPATH/src/github.com/grafana/grafana

COPY go.mod go.sum ./
RUN go mod verify

COPY pkg pkg
COPY build.go package.json ./
RUN go run build.go build

# Final stage for Grafana application image
FROM alpine:3.10.3 as grafana_app

LABEL maintainer="Grafana team <hello@grafana.com>"

ARG GF_UID="472"
ARG GF_GID="0"

ENV PATH="/usr/share/grafana/bin:$PATH" \
    GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
    GF_PATHS_DATA="/var/lib/grafana" \
    GF_PATHS_HOME="/usr/share/grafana" \
    GF_PATHS_LOGS="/var/log/grafana" \
    GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
    GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

WORKDIR $GF_PATHS_HOME

RUN apk add --no-cache ca-certificates bash tzdata && \
    apk add --no-cache openssl musl-utils

COPY conf ./conf

RUN if [ ! $(getent group "$GF_GID") ]; then \
      addgroup -S -g $GF_GID grafana; \
    fi

RUN export GF_GID_NAME=$(getent group $GF_GID | cut -d':' -f1) && \
    mkdir -p "$GF_PATHS_HOME/.aws" && \
    adduser -S -u $GF_UID -G "$GF_GID_NAME" grafana && \
    mkdir -p "$GF_PATHS_PROVISIONING/datasources" \
             "$GF_PATHS_PROVISIONING/dashboards" \
             "$GF_PATHS_PROVISIONING/notifiers" \
             "$GF_PATHS_PROVISIONING/plugins" \
             "$GF_PATHS_LOGS" \
             "$GF_PATHS_PLUGINS" \
             "$GF_PATHS_DATA" && \
    cp "$GF_PATHS_HOME/conf/sample.ini" "$GF_PATHS_CONFIG" && \
    cp "$GF_PATHS_HOME/conf/ldap.toml" /etc/grafana/ldap.toml && \
    chown -R "grafana:$GF_GID_NAME" "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING" && \
    chmod -R 777 "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING"

COPY --from=go-builder /go/src/github.com/grafana/grafana/bin/linux-amd64/grafana-server /go/src/github.com/grafana/grafana/bin/linux-amd64/grafana-cli ./bin/
COPY --from=js-builder /usr/src/app/public ./public
COPY --from=js-builder /usr/src/app/tools ./tools

EXPOSE 3000

COPY ./packaging/docker/run.sh /run.sh

USER grafana
ENTRYPOINT [ "/run.sh" ]

# --------------------------------------------------
# Final stage for NGINX static files image
FROM nginx:alpine as grafana_static

# Copy the compiled static files from js-builder stage
COPY --from=js-builder /usr/src/app/public /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

```

</details><br>


#### Point 6
**Соберем отдельно образ с `nginx` и отдельно с приложением, выставить теги `grafana:app` и `grafana:static`, c использованием флага `-target`. Выведем список образов**

- Соберем образы (вывод показан сокращено):

Приложение `grafana:app`
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/grafana$ docker build -t grafana:app --target grafana_app -f Dockerfile.new .
Sending build context to Docker daemon  112.5MB
Step 1/37 : FROM node:14.15.1-alpine3.12 as js-builder
 ---> bc9a7579ff4a
Step 2/37 : WORKDIR /usr/src/app/
 ---> Using cache
 ---> be55b047b64f
...
...
Successfully built 7afa96cfe4b9
Successfully tagged grafana:app
```
  
  Приложение `grafana:static`

```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/grafana$ docker build --target grafana_static -t grafana:static . -f Dockerfile.new
Sending build context to Docker daemon  112.5MB
Step 1/41 : FROM node:14.15.1-alpine3.12 as js-builder
 ---> bc9a7579ff4a
Step 2/41 : WORKDIR /usr/src/app/
...
Step 41/41 : CMD ["nginx", "-g", "daemon off;"]
 ---> Running in feadf34fd256
 ---> Removed intermediate container feadf34fd256
 ---> 8d1a37a0aa3a
Successfully built 8d1a37a0aa3a
Successfully tagged grafana:static
```

- Выведите список образов:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/grafana$ docker images
REPOSITORY                                                        TAG                  IMAGE ID       CREATED          SIZE
grafana                                                           static               8d1a37a0aa3a   7 minutes ago    127MB
grafana                                                           app                  7afa96cfe4b9   30 minutes ago   182MB
<none>                                                            <none>               67742cb6c168   31 minutes ago   1.78GB
```