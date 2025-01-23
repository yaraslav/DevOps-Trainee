### Чекпоинты

[1) Запусти контейнер с параметрами, включая случайное имя.](#Point-1)  
[2) Запусти второй контейнер и проверь его работу.](#Point-2)  
[3) Выполни команды для остановки и удаления контейнеров.](#Point-3)  

---

1. #### Point 1  
#### Запусти контейнер с параметрами, включая случайное имя.  
   **Задача:**  
   1. Запустим контейнер со следующими параметрами:  
      - должен работать в фоне;  
      - имеет имя `inno-dkr-05-run-X`, где X — набор из 10 случайных букв и/или цифр, который должен генерироваться в момент запуска контейнера
`(можно использовать команду: cat /dev/urandom | tr -cd 'a-f0-9' | head -c 10)`;  
      - образ — `nginx:stable`;  
      - команда для запуска контейнера должна быть одинаковой (выполнить одинаковую команду дважды подряд). 
Создадим контейнер командой `docker run -d --name inno-dkr-05-run-$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 10) nginx:stable`, проверим созданные контейнеры и возможность создания случайных имен:

```bash     
ubuntu@ip-172-31-19-243:~$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                     NAMES
91541bbb53bf   nginx:stable   "/docker-entrypoint.…"   6 minutes ago   Up 6 minutes   0.0.0.0:8891->80/tcp, [::]:8891->80/tcp   inno-dkr-04

ubuntu@ip-172-31-19-243:~$ docker run -d --name inno-dkr-05-run-$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 10) nginx:stable
65d36410875d13f56c399d7ae8fbc73217e42cb62031ead0f6a3007bdd67e26b

ubuntu@ip-172-31-19-243:~$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                                     NAMES
65d36410875d   nginx:stable   "/docker-entrypoint.…"   2 seconds ago   Up 2 seconds   80/tcp                                    inno-dkr-05-run-e4a8786ea0
91541bbb53bf   nginx:stable   "/docker-entrypoint.…"   6 minutes ago   Up 6 minutes   0.0.0.0:8891->80/tcp, [::]:8891->80/tcp   inno-dkr-04

ubuntu@ip-172-31-19-243:~$ docker run -d --name inno-dkr-05-run-$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 10) nginx:stable
9aea78b0c7db8b0346b7a042121d41a1d2dcde4ef177c8f30f49ad48164265ed
ubuntu@ip-172-31-19-243:~$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                     NAMES
9aea78b0c7db   nginx:stable   "/docker-entrypoint.…"   3 seconds ago    Up 2 seconds    80/tcp                                    inno-dkr-05-run-3ada8d3e87
65d36410875d   nginx:stable   "/docker-entrypoint.…"   18 seconds ago   Up 18 seconds   80/tcp                                    inno-dkr-05-run-e4a8786ea0
91541bbb53bf   nginx:stable   "/docker-entrypoint.…"   6 minutes ago    Up 6 minutes    0.0.0.0:8891->80/tcp, [::]:8891->80/tcp   inno-dkr-04
ubuntu@ip-172-31-19-243:~$
```
---

2. #### Point 2  
#### Запусти второй (с фиксированным именем) контейнер и проверь его работу.  
   **Задача:**  
   1. Запусти второй контейнер со следующими параметрами:  
      - должен работать в фоне;  
      - имеет имя `inno-dkr-05-stop`;  
      - образ — `nginx:stable`;  
   Выполним команду `docker run -d --name inno-dkr-05-stop nginx:stable`
```bash
ubuntu@ip-172-31-19-243:~$ docker run -d --name inno-dkr-05-stop nginx:stable
cf328d4486e489e98dbc94bb58d4c24c73e371ee8af7bf73435b65d3466b2a29
```
   2. Выполни команду `docker ps`, вывод перенаправь в файл `/home/user/ps.txt` с помощью команды `tee`:  
```bash   
ubuntu@ip-172-31-19-243:~$ docker ps | tee ~/ps.txt
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                     NAMES
cf328d4486e4   nginx:stable   "/docker-entrypoint.…"   5 seconds ago    Up 4 seconds    80/tcp                                    inno-dkr-05-stop
9aea78b0c7db   nginx:stable   "/docker-entrypoint.…"   3 minutes ago    Up 3 minutes    80/tcp                                    inno-dkr-05-run-3ada8d3e87
65d36410875d   nginx:stable   "/docker-entrypoint.…"   3 minutes ago    Up 3 minutes    80/tcp                                    inno-dkr-05-run-e4a8786ea0
91541bbb53bf   nginx:stable   "/docker-entrypoint.…"   10 minutes ago   Up 10 minutes   0.0.0.0:8891->80/tcp, [::]:8891->80/tcp   inno-dkr-04
ubuntu@ip-172-31-19-243:~$ cat ps.txt
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                     NAMES
cf328d4486e4   nginx:stable   "/docker-entrypoint.…"   5 seconds ago    Up 4 seconds    80/tcp                                    inno-dkr-05-stop
9aea78b0c7db   nginx:stable   "/docker-entrypoint.…"   3 minutes ago    Up 3 minutes    80/tcp                                    inno-dkr-05-run-3ada8d3e87
65d36410875d   nginx:stable   "/docker-entrypoint.…"   3 minutes ago    Up 3 minutes    80/tcp                                    inno-dkr-05-run-e4a8786ea0
91541bbb53bf   nginx:stable   "/docker-entrypoint.…"   10 minutes ago   Up 10 minutes   0.0.0.0:8891->80/tcp, [::]:8891->80/tcp   inno-dkr-04
ubuntu@ip-172-31-19-243:~
```
---

3. #### Point 3  
#### Выполни команды для остановки и удаления контейнеров.  
   **Задача:**  
   1. Остановим контейнер `inno-dkr-05-stop` и выведи список всех контейнеров.
```bash
ubuntu@ip-172-31-19-243:~$ docker stop inno-dkr-05-stop
inno-dkr-05-stop
ubuntu@ip-172-31-19-243:~$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                     NAMES
9aea78b0c7db   nginx:stable   "/docker-entrypoint.…"   4 minutes ago    Up 4 minutes    80/tcp                                    inno-dkr-05-run-3ada8d3e87
65d36410875d   nginx:stable   "/docker-entrypoint.…"   5 minutes ago    Up 5 minutes    80/tcp                                    inno-dkr-05-run-e4a8786ea0
91541bbb53bf   nginx:stable   "/docker-entrypoint.…"   11 minutes ago   Up 11 minutes   0.0.0.0:8891->80/tcp, [::]:8891->80/tcp   inno-dkr-04
ubuntu@ip-172-31-19-243:~$
```  
   2. Одной командой остановим все запущенные контейнеры. 
Это можно сделать например так: 
```bash
ubuntu@ip-172-31-19-243:~$ docker stop $(docker ps -aq)
cf328d4486e4
9aea78b0c7db
65d36410875d
91541bbb53bf
ubuntu@ip-172-31-19-243:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
ubuntu@ip-172-31-19-243:~$ docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS                          PORTS     NAMES
cf328d4486e4   nginx:stable   "/docker-entrypoint.…"   2 minutes ago    Exited (0) About a minute ago             inno-dkr-05-stop
9aea78b0c7db   nginx:stable   "/docker-entrypoint.…"   5 minutes ago    Exited (0) 6 seconds ago                  inno-dkr-05-run-3ada8d3e87
65d36410875d   nginx:stable   "/docker-entrypoint.…"   5 minutes ago    Exited (0) 6 seconds ago                  inno-dkr-05-run-e4a8786ea0
91541bbb53bf   nginx:stable   "/docker-entrypoint.…"   12 minutes ago   Exited (0) 6 seconds ago                  inno-dkr-04
ubuntu@ip-172-31-19-243:~$
```
или например вот так 
```bash
ubuntu@ip-172-31-19-243:~$ docker ps -aq | xargs docker stop
cf328d4486e4
9aea78b0c7db
65d36410875d
91541bbb53bf
``` 
   3. Одной командой удали все контейнеры (любой из разобранных методов).
Например так (чуть усложним команду из предыдущего действия)
```bash
ubuntu@ip-172-31-19-243:~$ docker ps -aq | xargs -I {} docker rm {}
cf328d4486e4
9aea78b0c7db
65d36410875d
91541bbb53bf
ubuntu@ip-172-31-19-243:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
ubuntu@ip-172-31-19-243:~$
```
или например вот так:
```bash
ubuntu@ip-172-31-19-243:~$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS     NAMES
2e1b32afd5ba   nginx:stable   "/docker-entrypoint.…"   8 seconds ago    Up 7 seconds    80/tcp    inno-dkr-05-run-f77402c5c4
f9289828b9e6   nginx:stable   "/docker-entrypoint.…"   10 seconds ago   Up 9 seconds    80/tcp    inno-dkr-05-run-8cbbd73fb4
9126dab92178   nginx:stable   "/docker-entrypoint.…"   12 seconds ago   Up 11 seconds   80/tcp    inno-dkr-05-run-4ef56c292f
f271ad1c893c   nginx:stable   "/docker-entrypoint.…"   21 seconds ago   Up 21 seconds   80/tcp    inno-dkr-05-stop
ubuntu@ip-172-31-19-243:~$
ubuntu@ip-172-31-19-243:~$ docker ps -aq | xargs docker stop
2e1b32afd5ba
f9289828b9e6
9126dab92178
f271ad1c893c
ubuntu@ip-172-31-19-243:~$ docker container prune
WARNING! This will remove all stopped containers.
Are you sure you want to continue? [y/N] y
Deleted Containers:
2e1b32afd5ba168ed36aea76c3b66e63eaf821e1e5cac18fa2d03f9950bf59fc
f9289828b9e6e98baa26eee6f23d5e2515cd9fa91c8608103d6399487f733e5a
9126dab92178c18375ef08a7a9101b04fae7d8a5f90c6e5cab78891a7d4ed33b
f271ad1c893c04d3544cadee1a76f451c240c977a4d83ba90d00b7e2b9bdfb62

Total reclaimed space: 4.372kB
ubuntu@ip-172-31-19-243:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
ubuntu@ip-172-31-19-243:~$ 
```