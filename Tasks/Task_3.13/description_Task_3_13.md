### Чекпоинты

[1) Скачай конфигурационный файл nginx. Запусти контейнер с указанными параметрами.](#Point-1)  
[2) Проверить работу контейнера и подсчитай md5sum конфигурационного файла nginx.](#Point-2)  
[3) Скачать новый конфигурационный файл nginx и измени конфигурацию сервера.](#Point-3)  
[4) Сравнить результаты изменения конфигурационного файла nginx.](#Point-4)  

---

1. #### Point 1  
#### Скачай конфигурационный файл nginx и запусти контейнер с указанными параметрами.  
   **Задача:**  
   1. Скачай конфигурационный файл nginx.  
   2. Запусти контейнер со следующими параметрами:  
      - должен работать в фоне;  
      - слушает на хосте `127.0.0.1:8890`;  
      - имеет имя `inno-dkr-03`;  
      - должен пробрасывать скачанный конфигурационный файл внутрь контейнера как основной конфигурационный файл;  
      - образ — `nginx:stable`.  
Используем контейнер созданый ранее (в Task 3.12) и проброс файла конфига с хостовой системы. Стартуем контейнер (если он остановлен):
```bash
ubuntu@ip-172-31-19-243:~$ docker start  inno-dkr-02
inno-dkr-02
ubuntu@ip-172-31-19-243:~$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS         PORTS                                     NAMES
82cac1b8f3bb   nginx:stable   "/docker-entrypoint.…"   54 minutes ago   Up 5 seconds   0.0.0.0:8889->80/tcp, [::]:8889->80/tcp   inno-dkr-02
ubuntu@ip-172-31-19-243:~$
```

---

2. #### Point 2  
#### Проверь работу контейнера и подсчитай md5sum конфигурационного файла nginx.  
   **Задача:**  
   1. Проверим работу контейнера, обратившись к `127.0.0.1:8889`. В ответ будет возвращаться сообщение:  

```bash
ubuntu@ip-172-31-19-243:~$ curl http://localhost:8889
Welcome to the training program Innowise: Docker
```  
   2. Выведем в консоли список запущенных контейнеров.  
```bash
ubuntu@ip-172-31-19-243:~$ docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                     NAMES
82cac1b8f3bb   nginx:stable   "/docker-entrypoint.…"   48 minutes ago   Up 35 minutes   0.0.0.0:8889->80/tcp, [::]:8889->80/tcp   inno-dkr-02
```

   3. Выполни команду для подсчета `md5sum` конфигурационного файла nginx внутри контейнера:  

```bash
docker exec -it inno-dkr-03 md5sum /etc/nginx/nginx.conf > hash_conf.txt && cat hash_conf.
```
Вывод результата команды: 
```bash
ubuntu@ip-172-31-30-89:~$ docker exec -ti inno-dkr-02 md5sum /etc/nginx/nginx.conf > hash_conf.txt && cat hash_conf.txt
3c3c615cb19ac6911b1acff0d071851e  /etc/nginx/nginx.conf
ubuntu@ip-172-31-30-89:~$
```
---

3. #### Point 3  
#### Скачай новый конфигурационный файл nginx и измени конфигурацию сервера.  
   **Задача:**  
   1. Скачай новый конфигурационный файл nginx.  
   2. Измени проброшенный конфигурационный файл, размещенный на хостовой системе, на новый.  
   3. Проведи эксперименты с различными способами изменения конфигурационного файла:  
      - через команду `cp`;  
      - через `vim` (плюс 2 балла в карму);  
      - через `nano`.  
Отредактируем файл конфига на хост-машине через `nano nginx.conf` откоректировав содержание в соответствии с [nginx.conf](Tasks/Task_3.13/nginx.conf). Перед этим сохранив его как  `cp nginx.conf nginx.old.conf`.

   4. Выполним команду reload nginx без остановки контейнера с помощью `docker exec`.  
Проверим конфигурацию и перезапустим сам сервер nginx  внутри контейнера:

```bash
ubuntu@ip-172-31-19-243:~$ docker exec  -it inno-dkr-02 nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
ubuntu@ip-172-31-19-243:~$ docker exec inno-dkr-02 nginx -s reload
2025/01/08 12:37:47 [notice] 41#41: signal process started
```

проверим 
```bash
ubuntu@ip-172-31-19-243:~$ curl http://localhost:8889
Welcome to the training program Innowise: Docker! Again!
ubuntu@ip-172-31-19-243:~$
```

   **UPD:**

Кроме команды `exec` для доступа `внутрь` контейнера и подключения к `stdout/stdin/stderr` запущенного приложения можно использовать команду `attach`. Но для этого контейнер должен быть запущен с `-it` флагом, поэтому пересоздаем контайнер например так:
```bash
ubuntu@ip-172-31-19-243:~$ docker rm -f inno-dkr-02 &&  docker run  -dit   --name inno-dkr-02   -p 8889:80   -v /home/ubuntu/nginx.conf:/etc/nginx/nginx.conf:ro   nginx:stable
inno-dkr-02
3761ea7aba145e03aa21527473ceca0335f260e670cf0469fba42eb757f8ace9
```
и подключаемся к терминалу приложения например вот так, получая доступ к выводу лога ngnix-сервера в реальном времени:
```bash
ubuntu@ip-172-31-19-243:~$ docker attach inno-dkr-02
85.221.149.113 - - [08/Jan/2025:14:12:17 +0000] "GET / HTTP/1.1" 200 57 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
85.221.149.113 - - [08/Jan/2025:14:12:17 +0000] "\x16\x03\x01\x06\xE0\x01\x00\x06\xDC\x03\x03\x061Y\x85\xD7\x1B5\x22_\x0BR\xB11\xE47\xA7\x7F\xF0\x8A\xF8\x9E\xA2i\x83^\x08\x8D\x87N\x10d& r[\x87\x9D\xE6\x9F\x91\xF1\xF6\xF1\xBEk\xAEY\x9B" 400 157 "-" "-" "-"
85.221.149.113 - - [08/Jan/2025:14:12:17 +0000] "\x16\x03\x01\x06\xE0\x01\x00\x06\xDC\x03\x03\x22\x19\x99\xCC8\x87\x0C\x0FcMd~\xDD\xF9\xC6\xF2q\x11\xB8n\xAD!\xEA\xB5B\x8A\x96\xCA\x8E\xC7\x14J \xCE\xE8\xB3\xB6\xF8\x8F\x8D\xC9h\x10\x9Ct\x9D[\xE4\xF2}\xAEC\x80~\xD0\xF1\xA0\xD8\x85\xC1\xB99\xB9^7\x00 \xEA\xEA\x13\x01\x13\x02\x13\x03\xC0+\xC0/\xC0,\xC00\xCC\xA9\xCC\xA8\xC0\x13\xC0\x14\x00\x9C\x00\x9D\x00/\x005\x01\x00\x06s**\x00\x00\x00\x10\x00\x0E\x00\x0C\x02h2\x08http/1.1\x00\x0B\x00\x02\x01\x00\x003\x04\xEF\x04\xEDjj\x00\x01\x00\x11\xEC\x04\xC0\xB7\xACQ\xF2B\x109\xEBZ8\x9Cv\xBE\xD7G\x9F\x02tqJe\x97\xD8\xB2\xCC5?T\xC4G\xC3l\xB9p1\xA44\xD4\x9E\xC27\xC9\xA4\x5C\xC2\xFBP\x0C\xBE\x91\xC6\xD9\x12a\xEF\x986\xB3\x1A\xB8uv#5YP\x18\x90S@\x10\xB6\x1F\x18\x7F@@\x81\xCBW\x96\xC2L\xB7A\xA2Q\xFB\x84L \x8A\x92\x80p\x80\xAF\xF8k\x9EE+\x9Fsu\xFF\xDA\x11\xB2\x88\x8C\xA3\x01!\xBF\xD5#\xBD\x8A\x18\xF6\xB1[\xD21\x5CF\x9AP\x97\xAA\xCF\x80\xE4\xAC\x89\xDB\xC9\xAF`Q\xAB\xA5*\xD9\x1ByQv\x03\xD5isb\xF6wl\xD8pr'd[\x12~\xDF\xC7\xB02c7\xB5'\x88q\xF4\x17\xF9\xC7\xB5*\x91\x17}\x94p\xDE\xC6\x9C\xAFHo\x16\x11\x92\x1CV\x0F\xC70\xAAh#n\xB1,H\xDD\x12\x01\xF3'\x9F\xB8\xFC5d\xB0S\xAC\xE0.5xQ\xA8\xD7E\x94{\x7F\xF7\xF3\x5C\x1C\xC2\x86~\x9AS\xB7\xD9\x07\xB7\xCB\x99\xE8\x08{\x84\x18I\x9B\x96o-;#\x5C:@\xB4\xE9\x96\xFA\x88w\x96\x94<E\xB5\x8B\x9DA\xC2\xDE\xA7\xA35!\x82s\x97\x1E~\xD5|\x1FlH.V\x5C\x8C\x93\xC38%\x85\x8F\xE0Qj*\x01D!\xC7\xAB\x84Q\xE9L`n\x93\x80\x87\xBA}:\xBA\x86\x1FRk\x83\x11u]PE`!\x0B\x1Fc\xB5\xBFA,n\x9B\xCE\x9C2\x17!(\xCE\xCDa\xC9_f\xCA:\xF1jj\xC8\x8Fik|\x92\x95D\x9F9\x91l\x9C\x12\xBAc\xB2\xB4$\x8E\xC2\x18\xBE%\x17t\x9Ay\x00" 400 157 "-" "-" "-"
85.221.149.113 - - [08/Jan/2025:14:12:19 +0000] "GET / HTTP/1.1" 200 57 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
85.221.149.113 - - [08/Jan/2025:14:12:21 +0000] "GET / HTTP/1.1" 200 57 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
85.221.149.113 - - [08/Jan/2025:14:12:22 +0000] "GET / HTTP/1.1" 200 57 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
85.221.149.113 - - [08/Jan/2025:14:12:23 +0000] "GET / HTTP/1.1" 200 57 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
85.221.149.113 - - [08/Jan/2025:14:12:27 +0000] "GET / HTTP/1.1" 200 57 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-"
read escape sequence
ubuntu@ip-172-31-19-243:~$ 
```

*Attached:* скрипт перезапуска нового контейнера [re-run_nginx.sh](Tasks/Task_3.13/re-run_nginx.sh)

--- 

4. #### Point 4  
#### Сравнить результаты изменения конфигурационного файла nginx.  
   **Задача:**  
   1. Выполни команду для подсчета `md5sum` конфигурационного файла nginx внутри контейнера и сравним с hash предыдущего конфига:  
```bash
ubuntu@ip-172-31-19-243:~$ docker exec -ti inno-dkr-02 md5sum /etc/nginx/nginx.conf >> hash_conf.txt && cat hash_conf.txt
3c3c615cb19ac6911b1acff0d071851e  /etc/nginx/nginx.conf
e9914ee9d3c1fbedca68494ecf14028e  /etc/nginx/nginx.conf
```
   2. Сравни результаты изменения файла `nginx.conf` разными командами.  
Сравним два конфига `nginx.conf` и `nginx.old.conf` через `diff` или `colordiff`:
   ```bash
   ubuntu@ip-172-31-19-243:~$ diff nginx.old.conf nginx.conf
16a17,30
>     log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
>                       '$status $body_bytes_sent "$http_referer" '
>                       '"$http_user_agent" "$http_x_forwarded_for"';
>
>     access_log  /var/log/nginx/access.log  main;
>
>     sendfile        on;
>     tcp_nopush     on;
>
>     keepalive_timeout  65;
>
>     gzip  on;
>
>
22c36
<             return 200 'Welcome to the training program Innowise: Docker!\n';
---
>             return 200 'Welcome to the training program Innowise: Docker! Again!\n';
```
или через `grep` чтобы узнать какие строки были добавлены в новый файл

```bash
ubuntu@ip-172-31-19-243:~$ grep -F -x -v -f nginx.old.conf nginx.conf
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    tcp_nopush     on;
    keepalive_timeout  65;
    gzip  on;
            return 200 'Welcome to the training program Innowise: Docker! Again!\n';
```
Для более наглядного визуального многооконного отображения различий можно использовать утилиту  `mc` (Midnight Commander) если она установлена или через `vim`  командой `vimdiff nginx.conf nginx.old.conf` доступной по-умолчанию в большинстве дистрибутивов.

