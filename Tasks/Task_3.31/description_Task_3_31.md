### Чекпоинты:

[1) Запусти 4 контейнера для каждой политики рестарта.](#point-1)  
[2) Вызови docker kill для каждого контейнера и выведи список с дублированием в файл kill_15.txt.](#point-2)  
[3) Запусти неактивные контейнеры и выведи список контейнеров.](#point-3)  
[4) Вызови docker kill для каждого контейнера и выведи список с дублированием в файл kill.txt. Проверить работу перезпуска контейнеров при рестарте демона docker.](#point-4)  

---

### 1. Point 1
**Запусти 4 контейнера для каждой политики рестарта - `no`, `always`, `unless-stopped`, `on-failure` .**
 - Запустим контейнеры со следующими параметрами:
    - должно работать в фоне,
    - имеет имя по шаблону inno-dkr-23-$RESTART_POLICY
    - образ - nginx:stable-alpine.

```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ docker run -d --name inno-dkr-23-no --restart no nginx:stable-alpine
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
1b7fe304646151539cb81ba3926657fed8d55bdd4a8791d6375236da3027c9dc
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ docker run -d --name inno-dkr-23-always --restart always nginx:stable-alpine
f46b3dc50aaed0a74a68e375f06bce0d0acf72c86d3124cc242edb9907eded84
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ docker run -d --name inno-dkr-23-unless-stopped --restart unless-stopped  nginx:stable-alpine       
75320e383de325cd73dc7b8cdff161daa762aabe5495907913ecbd175e247bb4
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ docker run -d --name inno-dkr-23-onn-failure --restart on-failure  nginx:stable-alpine
03c5b6d692f40ccdda6bde471b6515b25a7ae183d938ac1e38b317207180fe2b
```
 - Проверяем образ:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ docker images
REPOSITORY   TAG             IMAGE ID       CREATED      SIZE
nginx        stable-alpine   bb941add9a4c   8 days ago   47.2MB
```
и запущенные контейнеры:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ docker ps
CONTAINER ID   IMAGE                 COMMAND                  CREATED         STATUS         PORTS     NAMES
03c5b6d692f4   nginx:stable-alpine   "/docker-entrypoint.…"   3 minutes ago   Up 3 minutes   80/tcp    inno-dkr-23-onn-failure
75320e383de3   nginx:stable-alpine   "/docker-entrypoint.…"   3 minutes ago   Up 3 minutes   80/tcp    inno-dkr-23-unless-stopped
f46b3dc50aae   nginx:stable-alpine   "/docker-entrypoint.…"   4 minutes ago   Up 4 minutes   80/tcp    inno-dkr-23-always
1b7fe3046461   nginx:stable-alpine   "/docker-entrypoint.…"   4 minutes ago   Up 4 minutes   80/tcp    inno-dkr-23-no
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$
```
---

### 2. Point 2
**Вызовем docker kill для каждого контейнера и выведем список с дублированием в файл kill_15.txt.**

  - Для каждого контейнера вызови команду `docker kill -s 15` с сигналом `SIGTERM (код 15)` для корректнного завершения, для этого сделаем небольшой скрипт:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ docker ps -q | xargs docker kill -s 15
03c5b6d692f4
75320e383de3
f46b3dc50aae
1b7fe3046461
```

  - Выведем список всех контейнеров и продублируем вывод в файл `kill_15.txt`:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ docker ps -a | tee kill_15.txt
CONTAINER ID   IMAGE                 COMMAND                  CREATED          STATUS                     PORTS     NAMES
03c5b6d692f4   nginx:stable-alpine   "/docker-entrypoint.…"   26 minutes ago   Exited (0) 5 minutes ago             inno-dkr-23-onn-failure
75320e383de3   nginx:stable-alpine   "/docker-entrypoint.…"   27 minutes ago   Exited (0) 5 minutes ago             inno-dkr-23-unless-stopped
f46b3dc50aae   nginx:stable-alpine   "/docker-entrypoint.…"   28 minutes ago   Up 2 seconds               80/tcp    inno-dkr-23-always
1b7fe3046461   nginx:stable-alpine   "/docker-entrypoint.…"   28 minutes ago   Exited (0) 5 minutes ago             inno-dkr-23-no
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ ls -l kill_15.txt 
-rwxrwxrwx 1 yarik yarik 679 Feb 14 16:57 kill_15.txt
```
---

### 3. Point 3
**Запустим неактивные контейнеры и выведем список контейнеров.**

  - Запустим все неактивные контейнеры через скрипт `docker ps -aq -f "status=exited" | xargs docker restart` и выведем список:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ docker ps -aq -f "status=exited" | xargs docker restart
03c5b6d692f4
75320e383de3
1b7fe3046461
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ docker ps -a
CONTAINER ID   IMAGE                 COMMAND                  CREATED          STATUS          PORTS     NAMES
03c5b6d692f4   nginx:stable-alpine   "/docker-entrypoint.…"   29 minutes ago   Up 51 seconds   80/tcp    inno-dkr-23-onn-failure
75320e383de3   nginx:stable-alpine   "/docker-entrypoint.…"   30 minutes ago   Up 51 seconds   80/tcp    inno-dkr-23-unless-stopped
f46b3dc50aae   nginx:stable-alpine   "/docker-entrypoint.…"   30 minutes ago   Up 8 minutes    80/tcp    inno-dkr-23-always
1b7fe3046461   nginx:stable-alpine   "/docker-entrypoint.…"   31 minutes ago   Up 51 seconds   80/tcp    inno-dkr-23-no
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ 
```

---

### 4. Point 4
**Вызовeм `docker kill` без доп. флагов (с сигналом `SIGKILL` (код 9)) для каждого контейнера и выведем список с дублированием в файл kill.txt.**

  - Для каждого контейнера вызовем команду `docker kill` через скрипт `docker ps -q | xargs docker kill`:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ docker ps -q | xargs docker kill
03c5b6d692f4
75320e383de3
f46b3dc50aae
1b7fe3046461
```
 - Выведи список всех контейнеров и дублируй вывод в файл `kill.txt`:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ docker ps -a | tee kill.txt
CONTAINER ID   IMAGE                 COMMAND                  CREATED       STATUS                            PORTS     NAMES
03c5b6d692f4   nginx:stable-alpine   "/docker-entrypoint.…"   2 hours ago   Exited (137) About a minute ago             inno-dkr-23-onn-failure
75320e383de3   nginx:stable-alpine   "/docker-entrypoint.…"   2 hours ago   Exited (137) About a minute ago             inno-dkr-23-unless-stopped
f46b3dc50aae   nginx:stable-alpine   "/docker-entrypoint.…"   2 hours ago   Exited (137) About a minute ago             inno-dkr-23-always
1b7fe3046461   nginx:stable-alpine   "/docker-entrypoint.…"   2 hours ago   Exited (137) About a minute ago             inno-dkr-23-no
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$
```

видим, что контейнеры не перезапускаются т.к. принудительно остановлены. Перезапуск демона `sudo systemctl restart docker.service` не изменил ничего.
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ sudo systemctl restart docker.service 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ docker ps -a
CONTAINER ID   IMAGE                 COMMAND                  CREATED       STATUS                       PORTS     NAMES
03c5b6d692f4   nginx:stable-alpine   "/docker-entrypoint.…"   2 hours ago   Exited (137) 6 minutes ago             inno-dkr-23-onn-failure
75320e383de3   nginx:stable-alpine   "/docker-entrypoint.…"   2 hours ago   Exited (137) 6 minutes ago             inno-dkr-23-unless-stopped
f46b3dc50aae   nginx:stable-alpine   "/docker-entrypoint.…"   2 hours ago   Exited (137) 6 minutes ago             inno-dkr-23-always
1b7fe3046461   nginx:stable-alpine   "/docker-entrypoint.…"   2 hours ago   Exited (137) 6 minutes ago             inno-dkr-23-no
```
---
### !!!! Возможно всё дело в работе docker daemon на WSL (Ubuntu) под Windows-11 !!!!
---
**Проверяем те же настройки на "чистом" Linux - Ubuntu 24.04.1 LTS на EC2 AWS (четыре контейнера с разными `restart policy`):**

 - Запускаем контейнеры (заранее подготовленные):
```bash
ubuntu@ip-172-31-30-234:~$ docker ps
CONTAINER ID   IMAGE                                   COMMAND                  CREATED         STATUS                   PORTS                                       NAMES
06bfea0ebde3   prometheuscommunity/postgres-exporter   "/bin/postgres_expor…"   2 minutes ago   Up 8 seconds             0.0.0.0:9187->9187/tcp, :::9187->9187/tcp   postgresql-exporter
1f59ac6798aa   postgres:15.4                           "docker-entrypoint.s…"   2 minutes ago   Up 7 seconds (healthy)   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgresql
455bf6d88f3c   prom/prometheus                         "/bin/prometheus --c…"   2 minutes ago   Up 7 seconds             0.0.0.0:9090->9090/tcp, :::9090->9090/tcp   prometheus
a3c404095188   grafana/grafana                         "/run.sh"                2 minutes ago   Up 6 seconds             0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   grafana
```
и проверяем `restart policy` в них:

```bash
ubuntu@ip-172-31-30-234:~$ docker ps -aq | xargs -I {} docker inspect {} | jq '.[0] | {Name: .Name, RestartPolicy: .HostConfig.RestartPolicy}'
{
  "Name": "/postgresql-exporter",
  "RestartPolicy": {
    "Name": "no",
    "MaximumRetryCount": 0
  }
}
{
  "Name": "/postgresql",
  "RestartPolicy": {
    "Name": "always",
    "MaximumRetryCount": 0
  }
}
{
  "Name": "/prometheus",
  "RestartPolicy": {
    "Name": "on-failure",
    "MaximumRetryCount": 0
  }
}
{
  "Name": "/grafana",
  "RestartPolicy": {
    "Name": "unless-stopped",
    "MaximumRetryCount": 0
  }
}
```
 - Затем проверим применение команды `docker kill -s 15` c последующим перезапуском демона docker :
```bash
ubuntu@ip-172-31-30-234:~$ docker ps -aq | xargs docker kill -s 15
06bfea0ebde3
1f59ac6798aa
455bf6d88f3c
a3c404095188
ubuntu@ip-172-31-30-234:~$ docker ps -a
CONTAINER ID   IMAGE                                   COMMAND                  CREATED         STATUS                      PORTS                                       NAMES
06bfea0ebde3   prometheuscommunity/postgres-exporter   "/bin/postgres_expor…"   4 minutes ago   Exited (0) 17 seconds ago                                               postgresql-exporter
1f59ac6798aa   postgres:15.4                           "docker-entrypoint.s…"   4 minutes ago   Up 16 seconds (healthy)     0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgresql
455bf6d88f3c   prom/prometheus                         "/bin/prometheus --c…"   4 minutes ago   Exited (0) 17 seconds ago                                               prometheus
a3c404095188   grafana/grafana                         "/run.sh"                4 minutes ago   Exited (0) 17 seconds ago                                               grafana
```
Видим, что те контейнеры что остановились с кодом `0` -  процесс завершился без ошибкой при принудительной остановке. Перезапустим демон docker и увидим, что:
```bash
ubuntu@ip-172-31-30-234:~$ sudo systemctl restart docker.service
ubuntu@ip-172-31-30-234:~$ docker ps -a
CONTAINER ID   IMAGE                                   COMMAND                  CREATED          STATUS                      PORTS                                       NAMES
06bfea0ebde3   prometheuscommunity/postgres-exporter   "/bin/postgres_expor…"   20 minutes ago   Exited (2) 34 seconds ago                                               postgresql-exporter
1f59ac6798aa   postgres:15.4                           "docker-entrypoint.s…"   20 minutes ago   Up 10 seconds (healthy)     0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgresql
455bf6d88f3c   prom/prometheus                         "/bin/prometheus --c…"   20 minutes ago   Exited (0) 34 seconds ago                                               prometheus
a3c404095188   grafana/grafana                         "/run.sh"                20 minutes ago   Exited (0) 34 seconds ago                                               grafana
```
и видим, что состояние контейнеров не изменилось.
- Запустим все остановленные контейнеры:
```bash
ubuntu@ip-172-31-30-234:~$ docker ps -aq -f "status=exited" | xargs docker restart
06bfea0ebde3
455bf6d88f3c
a3c404095188
ubuntu@ip-172-31-30-234:~$ docker ps -a
CONTAINER ID   IMAGE                                   COMMAND                  CREATED         STATUS                    PORTS                                       NAMES
06bfea0ebde3   prometheuscommunity/postgres-exporter   "/bin/postgres_expor…"   5 minutes ago   Up 3 seconds              0.0.0.0:9187->9187/tcp, :::9187->9187/tcp   postgresql-exporter
1f59ac6798aa   postgres:15.4                           "docker-entrypoint.s…"   5 minutes ago   Up 59 seconds (healthy)   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgresql
455bf6d88f3c   prom/prometheus                         "/bin/prometheus --c…"   5 minutes ago   Up 2 seconds              0.0.0.0:9090->9090/tcp, :::9090->9090/tcp   prometheus
a3c404095188   grafana/grafana                         "/run.sh"                5 minutes ago   Up 2 seconds              0.0.0.0:3000->3000/tcp, :::3000->3000/tcp   grafana
```
 - Теперь проверим применение команды `docker kill -s 9` c последующим перезапуском демона docker:
```bash
ubuntu@ip-172-31-30-234:~$ docker ps -aq | xargs docker kill -s 9
06bfea0ebde3
1f59ac6798aa
455bf6d88f3c
a3c404095188
ubuntu@ip-172-31-30-234:~$ docker ps -a
CONTAINER ID   IMAGE                                   COMMAND                  CREATED         STATUS                       PORTS     NAMES
06bfea0ebde3   prometheuscommunity/postgres-exporter   "/bin/postgres_expor…"   6 minutes ago   Exited (137) 3 seconds ago             postgresql-exporter
1f59ac6798aa   postgres:15.4                           "docker-entrypoint.s…"   6 minutes ago   Exited (137) 3 seconds ago             postgresql
455bf6d88f3c   prom/prometheus                         "/bin/prometheus --c…"   6 minutes ago   Exited (137) 3 seconds ago             prometheus
a3c404095188   grafana/grafana                         "/run.sh"                6 minutes ago   Exited (137) 3 seconds ago             grafana
ubuntu@ip-172-31-30-234:~$
```
Видим, что контейнеры остановились с кодом `137` -  контейнер завершился с ошибкой при принудительной остановке. Перезапустим демон docker и увидим, что:
```bash
ubuntu@ip-172-31-30-234:~$ sudo systemctl restart docker.service
ubuntu@ip-172-31-30-234:~$ docker ps -a
CONTAINER ID   IMAGE                                   COMMAND                  CREATED         STATUS                            PORTS                                       NAMES
06bfea0ebde3   prometheuscommunity/postgres-exporter   "/bin/postgres_expor…"   7 minutes ago   Exited (137) 49 seconds ago                                                   postgresql-exporter
1f59ac6798aa   postgres:15.4                           "docker-entrypoint.s…"   7 minutes ago   Up 2 seconds (health: starting)   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgresql
455bf6d88f3c   prom/prometheus                         "/bin/prometheus --c…"   7 minutes ago   Up 2 seconds                      0.0.0.0:9090->9090/tcp, :::9090->9090/tcp   prometheus
a3c404095188   grafana/grafana                         "/run.sh"                7 minutes ago   Exited (137) 49 seconds ago                                                   grafana
```
Видим, что перезапустились контейнеры с политикой перезапуска -  `always` и `on-failure`.

---


**UPD: команды для проверки статуса перезапуска в контейнерах:**
```bash
docker inspect inno-dkr-23-always | jq '.[0].HostConfig.RestartPolicy'
```
```bash
docker ps -aq | xargs -I {} docker inspect {} | jq '.[0] | {Name: .Name, RestartPolicy: .HostConfig.RestartPolicy}'
```
```bash
docker ps -aq | xargs -I {} docker inspect {} | awk '/"Name":/ {print "Name:", $2} /"RestartPolicy":/ {print "RestartPolicy:", $2}'
```