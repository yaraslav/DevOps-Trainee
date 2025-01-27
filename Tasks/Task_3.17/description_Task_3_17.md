### Чекпоинты:

[Выполни загрузку образа nginx:stable-alpine на свой локальный хост. Добавь к загруженному образу новый тег inno-dkr-07. Выведи список образов на твоем хосте.](#Point-1)
[Запусти контейнер с новым образом и выведи список запущенных контейнеров - контейнер должен быть запущен.](#Point-2)

---

1. #### Point 1  
#### Выполни загрузку образа nginx:stable-alpine на свой локальный хост. Добавь к загруженному образу новый тег inno-dkr-07. Выведи список образов на твоем хосте.  
   **Задача:** 
```bash 
ubuntu@ip-172-31-19-243:~$ docker pull nginx:stable-alpine
stable-alpine: Pulling from library/nginx
66a3d608f3fa: Pull complete
425c7b6b0584: Pull complete
bc3151b8c483: Pull complete
32c1c5ad4705: Pull complete
acc3b7ea73b8: Pull complete
b527c1980d34: Pull complete
ea697fe9913f: Pull complete
2504415565d4: Pull complete
Digest: sha256:b9e1705b69f778dca93cbbbe97d2c2562fb26cac1079cdea4e40d1dad98f14fe
Status: Downloaded newer image for nginx:stable-alpine
docker.io/library/nginx:stable-alpine
ubuntu@ip-172-31-19-243:~$ docker tag nginx:stable-alpine nginx:inno-dkr-07
ubuntu@ip-172-31-19-243:~$ docker image ls
REPOSITORY   TAG             IMAGE ID       CREATED        SIZE
nginx        inno-dkr-07     4ebaceb1bd2e   5 months ago   43.3MB
nginx        stable-alpine   4ebaceb1bd2e   5 months ago   43.3MB
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$
```
---

2. #### Point 2
#### Запусти контейнер с новым образом и выведи список запущенных контейнеров - контейнер должен быть запущен.
```bash
ubuntu@ip-172-31-19-243:~$ docker run -d --name my_nginx_container nginx:inno-dkr-07
c401660c640d6489bc8112d3898f881048b18cc6e716420a568281283c76ec47
ubuntu@ip-172-31-19-243:~$ docker ps
CONTAINER ID   IMAGE               COMMAND                  CREATED         STATUS         PORTS     NAMES
c401660c640d   nginx:inno-dkr-07   "/docker-entrypoint.…"   6 seconds ago   Up 5 seconds   80/tcp    my_nginx_container
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$ docker ps -a
CONTAINER ID   IMAGE               COMMAND                  CREATED         STATUS         PORTS     NAMES
c401660c640d   nginx:inno-dkr-07   "/docker-entrypoint.…"   9 seconds ago   Up 9 seconds   80/tcp    my_nginx_container
ubuntu@ip-172-31-19-243:~$
```
---