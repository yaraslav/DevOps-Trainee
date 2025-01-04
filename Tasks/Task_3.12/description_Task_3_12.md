### Чекпоинты

[1) Скачай конфигурационный файл nginx. Запусти контейнер с указанными параметрами.](#Point-1)  
[2) Проверь работу контейнера, выполни подсчет md5sum конфигурационного файла nginx внутри контейнера.](#Point-2)  

---

1. #### Point 1  
#### Скачай конфигурационный файл nginx и запусти контейнер с указанными параметрами. Должен пробрасывать скачанный тобой конфигурационный файл nginx внутрь контейнера как основной конфигурационный файл, используемый образ - nginx:stable.  
   **Задача:**  
   1. Самый простой конфигурационный файл сервера для возрата сообщения
   `Welcome to the training program Innowise: Docker` следующий:

```bash
events {}

http {
    server {
        listen 80;
        server_name localhost;

        location / {
            return 200 'Welcome to the training program Innowise: Docker';
        }
    }
}
```
создадим его в домашней директории `/home/ubuntu/` через 
```bash
nano nginx.conf
```

   2. Запустим контейнер со следующими параметрами:  
      - должен работать в фоне;  
      - слушает на хосте `127.0.0.1:8889`;  
      - имеет имя `inno-dkr-02`;  
      - должен пробрасывать скачанный конфигурационный файл nginx внутрь контейнера как основной конфигурационный файл;  
      - образ — `nginx:stable`.
      
Запустим контейнер следующей командой:

```bash
ubuntu@ip-172-31-30-89:~$ docker run -d   --name inno-dkr-02   -p 8889:80   -v /home/ubuntu/nginx.conf:/etc/nginx/nginx.conf:ro   nginx:stable
1c52691cb59545759205022577282dc31a7cf07de41f7575335df810fccd0876
ubuntu@ip-172-31-30-89:~$
```

---

2. #### Point 2  
#### Проверь работу контейнера и подсчитай md5sum конфигурационного файла nginx.  
   **Задача:**  
   1. Проверим работу контейнера, обратившись к `127.0.0.1:8889`. В ответ должно возвращаться сообщение:  
      `Welcome to the training program Innowise: Docker`
```bash
ubuntu@ip-172-31-30-89:~$ curl http://127.0.0.1:8889
Welcome to the training program Innowise: Docker
```      
Проверим status контейнера и скачаный образ: 
```bash
ubuntu@ip-172-31-30-89:~$ docker image ls
REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
nginx         stable    29ef6eaebfc5   4 months ago    188MB
hello-world   latest    d2c94e258dcb   20 months ago   13.3kB
ubuntu@ip-172-31-30-89:~$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                     NAMES
1c52691cb595   nginx:stable   "/docker-entrypoint.…"   42 minutes ago   Up 42 minutes   0.0.0.0:8889->80/tcp, [::]:8889->80/tcp   inno-dkr-02
```

   2. Выполним подсчет `md5sum` конфигурационного файла nginx внутри контейнера и выведем его в файл `hash_conf.txt` с помощью команды  
      ```bash
      docker exec -ti inno-dkr-02 md5sum /etc/nginx/nginx.conf > hash_conf.txt && cat hash_conf.txt
      ```
Вывод результата команды:      
```bash
ubuntu@ip-172-31-30-89:~$ docker exec -ti inno-dkr-02 md5sum /etc/nginx/nginx.conf > hash_conf.txt && cat hash_conf.txt
cac734dc4ecc66c5e6ad6a5214a1bd51  /etc/nginx/nginx.conf
ubuntu@ip-172-31-30-89:~$
```