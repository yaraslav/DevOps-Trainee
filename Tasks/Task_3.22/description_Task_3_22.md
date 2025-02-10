#### Чекпоинты:

[1) Загрузить образ `nginx:stable-alpine` и добавить к нему новый тег `inno-dkr-12`. Вывести список образов на хосте, удалить образ `nginx:stable-alpine`.](#point-1)  
[2) Повторно загрузить образ `nginx:stable-alpine`. Вывести список образов и сохранить его в файл. Удалить все образы `nginx` одной командой.](#point-2)  
[3) Запустить контейнер с определенными параметрами. Попробовать удалить образ `nginx:stable-alpine` без флагов, затем с флагом `--force`.](#point-3)  
[4) Перезапустить контейнер и убедиться, что он продолжает работать.](#point-4)
[5) Остановка и удаление контейнера.] (#point-5)  

---

#### Point 1  
**Загрузить образ `nginx:stable-alpine` и добавить к нему новый тег `inno-dkr-12`.**  

  - Загрузите образ:
```bash
docker pull nginx:stable-alpine
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker pull nginx:stable-alpine
stable-alpine: Pulling from library/nginx
66a3d608f3fa: Pull complete
23b1af26b4b2: Pull complete
8f954e2deca1: Pull complete
35cccf6d6e81: Pull complete
30959a781812: Pull complete
4db9d886b7a5: Pull complete
2e0d682fb99f: Pull complete
d2cb508961ba: Pull complete
Digest: sha256:d05f6fee67a3521d2fe000d471ac9b5af1900847f25b837e167f2213e95ddf0f
Status: Downloaded newer image for nginx:stable-alpine
docker.io/library/nginx:stable-alpine
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker images 
REPOSITORY                      TAG             IMAGE ID       CREATED        SIZE
nginx                           stable-alpine   bb941add9a4c   4 days ago     47.2MB
```
  - Добавьте новый тег и выведите список образов::
```bash
docker tag nginx:stable-alpine inno-dkr-12
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker tag nginx:stable-alpine inno-dkr-12
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker images
REPOSITORY                      TAG             IMAGE ID       CREATED        SIZE
inno-dkr-12                     latest          bb941add9a4c   4 days ago     47.2MB
nginx                           stable-alpine   bb941add9a4c   4 days ago     47.2MB
```
  - Удалите образ `nginx:stable-alpine`:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker image rm nginx:stable-alpine 
Untagged: nginx:stable-alpine
Untagged: nginx@sha256:d05f6fee67a3521d2fe000d471ac9b5af1900847f25b837e167f2213e95ddf0f
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker images
REPOSITORY                      TAG          IMAGE ID       CREATED        SIZE
inno-dkr-12                     latest       bb941add9a4c   4 days ago     47.2MB
```
---

#### Point 2  
**Повторно загрузить образ `nginx:stable-alpine`. Вывести список образов и сохранить его в файл. Удалить все образы `nginx` одной командой.**  

  - Загрузите образ:
```bash
docker pull nginx:stable-alpine
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker pull nginx:stable-alpine
stable-alpine: Pulling from library/nginx
Digest: sha256:d05f6fee67a3521d2fe000d471ac9b5af1900847f25b837e167f2213e95ddf0f
Status: Downloaded newer image for nginx:stable-alpine
docker.io/library/nginx:stable-alpine
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker images
REPOSITORY                      TAG             IMAGE ID       CREATED        SIZE
nginx                           stable-alpine   bb941add9a4c   4 days ago     47.2MB
inno-dkr-12                     latest          bb941add9a4c   4 days ago     47.2MB
```
  - Выведите список образов и сохраните его в файл:
```bash
docker images | tee images.txt
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker images | tee images.txt
REPOSITORY                      TAG             IMAGE ID       CREATED        SIZE
inno-dkr-12                     latest          bb941add9a4c   4 days ago     47.2MB
nginx                           stable-alpine   bb941add9a4c   4 days ago     47.2MB
```
  - Удалите все образы `nginx` одной командой (буду удалять по ID image `docker images | grep 'nginx' | awk '{print $3}' | xargs docker rmi -f` ):
```bash
docker images | grep 'nginx' | awk '{print $3}' | xargs docker rmi -f
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker images | grep 'nginx' | awk '{print $3}' | xargs docker rmi -f
Untagged: inno-dkr-12:latest
Untagged: nginx:stable-alpine
Untagged: nginx@sha256:d05f6fee67a3521d2fe000d471ac9b5af1900847f25b837e167f2213e95ddf0f
Deleted: sha256:bb941add9a4cc40481425ec89ba31464be1c30842d107836445e72a079a75bd6
Deleted: sha256:6d77fd90b5ed8976ebf008945b82e9abd286c2dc09e01e1de3dfc1748ec7ebaf
Deleted: sha256:57ee8d616094b3ef0ee901bb58a8603d3537f3cfde1cc0406451863f5707bd5b
Deleted: sha256:31ceb2e2ec2ca0533bc5ada7334c2987d022e381e17fd7f498d6a5cd47b7fc6f
Deleted: sha256:0d9edf250c5947e256c0ad4759f1ad8f723bac2dd1a35bcfebb1b9cedc85b923
Deleted: sha256:c39638899825727c7d30c9792f9b3e0fbb5e85fbabcdcf16fe7789882e85f486
Deleted: sha256:48115b307facd43673243ba9955999aa7d23bd081aed65ec7447f1da90d6c517
Deleted: sha256:bc24b91e7d219e36ce2460e0994dc10e7410d986376180473c1768e6a5d1480c
Deleted: sha256:ce5a8cde9eeef09160653b9c3d14f0c1c0e2900033476a5f2a9fc950161c0eb2
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker images
REPOSITORY                      TAG          IMAGE ID       CREATED        SIZE

```

---

#### Point 3  
**Запустить контейнер с определенными параметрами. Попробовать удалить образ `nginx:stable-alpine` без флагов, затем с флагом `--force`.**  

  - Запустите контейнер:
```bash
docker run -d --name inno-dkr-12 nginx:stable-alpine
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker run -d --name inno-dkr-12 nginx:stable-alpine
Unable to find image 'nginx:stable-alpine' locally
stable-alpine: Pulling from library/nginx
66a3d608f3fa: Pull complete
23b1af26b4b2: Pull complete
8f954e2deca1: Pull complete
35cccf6d6e81: Pull complete
30959a781812: Pull complete
4db9d886b7a5: Pull complete
2e0d682fb99f: Pull complete
d2cb508961ba: Pull complete
Digest: sha256:d05f6fee67a3521d2fe000d471ac9b5af1900847f25b837e167f2213e95ddf0f
Status: Downloaded newer image for nginx:stable-alpine
528507757f1fe158e5d4550258f2576a8c4b5ae29c352ea1118676f6002c763e
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker ps 
CONTAINER ID   IMAGE                 COMMAND                  CREATED         STATUS         PORTS     NAMES
528507757f1f   nginx:stable-alpine   "/docker-entrypoint.…"   8 seconds ago   Up 7 seconds   80/tcp    inno-dkr-12
```
  - Попробуйте удалить образ без флагов:
```bash
docker rmi nginx:stable-alpine
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker rmi nginx:stable-alpine
Error response from daemon: conflict: unable to remove repository reference "nginx:stable-alpine" (must force) - container 528507757f1f is using its referenced image bb941add9a4c
```
  - Удаляем с флагом `--force`:
```bash
docker rmi --force nginx:stable-alpine
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker rmi --force nginx:stable-alpine
Untagged: nginx:stable-alpine
Untagged: nginx@sha256:d05f6fee67a3521d2fe000d471ac9b5af1900847f25b837e167f2213e95ddf0f
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker images
REPOSITORY                      TAG          IMAGE ID       CREATED        SIZE
<none>                          <none>       bb941add9a4c   4 days ago     47.2MB
```
  - Проверяем работу контейнера:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS     NAMES
528507757f1f   bb941add9a4c   "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes   80/tcp    inno-dkr-12
```

---

#### Point 4  
**Перезапустить контейнер и убедиться, что он продолжает работать.**  

  - Перезапустите контейнер и проверьте статус контейнер:
```bash
docker restart inno-dkr-12
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker restart inno-dkr-12
inno-dkr-12
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS     NAMES
528507757f1f   bb941add9a4c   "/docker-entrypoint.…"   2 minutes ago   Up 3 seconds   80/tcp    inno-dkr-12
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ 
```

#### Point 5
**Удалить контейнер любым удобным способом**

  - Остановите и удалите контейнер и проверьте статус контейнера:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker rm -f inno-dkr-12 
inno-dkr-12
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
  - и удалим оставшийся "висячий" образ:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker images
REPOSITORY                      TAG          IMAGE ID       CREATED        SIZE
<none>                          <none>       bb941add9a4c   4 days ago     47.2MB
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker rmi bb941add9a4c
Deleted: sha256:bb941add9a4cc40481425ec89ba31464be1c30842d107836445e72a079a75bd6
Deleted: sha256:6d77fd90b5ed8976ebf008945b82e9abd286c2dc09e01e1de3dfc1748ec7ebaf
Deleted: sha256:57ee8d616094b3ef0ee901bb58a8603d3537f3cfde1cc0406451863f5707bd5b
Deleted: sha256:31ceb2e2ec2ca0533bc5ada7334c2987d022e381e17fd7f498d6a5cd47b7fc6f
Deleted: sha256:0d9edf250c5947e256c0ad4759f1ad8f723bac2dd1a35bcfebb1b9cedc85b923
Deleted: sha256:c39638899825727c7d30c9792f9b3e0fbb5e85fbabcdcf16fe7789882e85f486
Deleted: sha256:48115b307facd43673243ba9955999aa7d23bd081aed65ec7447f1da90d6c517
Deleted: sha256:bc24b91e7d219e36ce2460e0994dc10e7410d986376180473c1768e6a5d1480c
Deleted: sha256:ce5a8cde9eeef09160653b9c3d14f0c1c0e2900033476a5f2a9fc950161c0eb2
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_3.22$ docker images
REPOSITORY                      TAG          IMAGE ID       CREATED        SIZE

```

