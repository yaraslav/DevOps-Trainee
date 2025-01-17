### Чекпоинты:

[1) Создать сервер t2.micro(Ubuntu), он должен иметь публичный ip и доступ в интернет. При создании использовать User Data cкрипт(приложен ниже user_data.sh). Разрешить http и https трафик в security group, ассоциированной с данным сервером.](#Point-1)  
[2) Зарегистрироваться на сайте: Free Dynamic DNS - Managed DNS - Managed Email - Domain Registration - No-IP , разобраться в типах DNS записей, сделать DNS записать типа A для созданного сервера.Получить сертификат для своего сервера, используя letsencrypt. Разобраться в цепочках сертификатов.](#Point-2)  
[3) Установить Nginx на сервер. Написать конфигурацию nginx для обслуживания на 80 и 443 портах. 80 порт должен делать редирект на 443(сайт должен работать только по HTTPS). Веб-сервер должен раздавать /var/www/html/index.nginx-debian.html, который был сгенерирован User Data скриптом.Проверить работоспособность. При вводе домена в поисковую строку должен выдаваться текст: Welcome to my web server. My private IP is *********. ](#Point-3)  
[4) Нужно изменять страницу nginx и конфигурационный файл: Клиент нажимает на слово-ссылку, после чего его перенаправляет на html-страницу с картинкой. Клиент нажимает на слово-ссылку, по которой можно скачать файл mp3 с музыкой. Сделать регулярное выражение для отображения картинок(png, jpg). Если формат jpg, то перевернуть картинку с помощью nginx. ](#Point-4)   
[5) Создать второй сервер t2.micro, установить Apache и PHP(fpm), взять за основу info.php файл. Настроить Apache на обслуживание данного файла.](#Point-5)  
[6) Создать слово-ссылку в html-странице, которая будет перенаправлять запрос с Nginx-cервера на Apache-сервер.](#Point-6)  


1. #### Point 1  
#### Создать сервер t2.micro(Ubuntu), он должен иметь публичный ip и доступ в интернет. При создании использовать User Data cкрипт(приложен ниже user_data.sh). Разрешить http и https трафик в security group, ассоциированной с данным сервером.

Настроим сервер на основе ранее созданного yellow_server, изменим в конфигурационном файле `main.tf` тип инстанса и `user_data.sh` скрипт на этот:
```bash 
#!/bin/bash
sudo apt-get update -y

sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

sudo rm -r /var/www/html/index.nginx-debian.html

TOKEN=$(curl --request PUT "http://169.254.169.254/latest/api/token" --header "X-aws-ec2-metadata-token-ttl-seconds: 3600")
LOCAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 --header "X-aws-ec2-metadata-token: $TOKEN") 

echo "This is My private IP is $LOCAL_IP" | sudo tee /var/www/html/index.nginx-debian.html

if sudo nginx -t; then
    echo "Nginx configuration is valid. Reloading Nginx..."
    sudo systemctl reload nginx
    echo "Nginx reloaded successfully."
else
    echo "Nginx configuration is invalid. Please fix the issues and try again."
fi
```
Кроме того, импортируем заранее созданый Elastic IP адрес для привязки его к инстансу. Для этого создадим ресурс в `main.tf`
```bash
resource "aws_eip" "https_server" {
}
```
и импортируем сам ресурс в terraform
```bash
terraform import aws_eip.https_server eipalloc-<resources_id>
```

Затем создадим новые ресурсы и пересоздадим ранее созданый инстанс командами:
```bash
terraform taint aws_instance.yellow_server
terraform plan
terraform apply
```
Так как мы используем ранее созданную security group разрешающую http/https трафик, сервер должен быть доступен сразу после создания. Подключаемся к серверу и проверяем работу ngnix через запрос на локальный адрес :
```bash
ubuntu@ip-172-31-28-239:~$ curl http://localhost
This is My private IP is 172.31.28.239
``` 
Затем проверяем с локальной машины:
```bash
yarik@Innowise-work:~$ curl http://3.72.70.48
This is My private IP is 172.31.28.239
yarik@Innowise-work:~$
```

2. #### Point 2  
 #### Зарегистрироваться на сайте: Free Dynamic DNS - Managed DNS - Managed Email - Domain Registration - No-IP , разобраться в типах DNS записей, сделать DNS записать типа A для созданного сервера.Получить сертификат для своего сервера, используя letsencrypt. Разобраться в цепочках сертификатов.
Регистрируемся на сайте www.noip.com и получаем DNS 'type A' запись для ip-адреса - `mylearndevops.sytes.net`. 
Проверяем работу:
```bash
yarik@Innowise-work:~$ curl -s http://mylearndevops.sytes.net/
This is My private IP is 172.31.28.239
```
Настраиваем nginx:
```bash
sudo nano /etc/nginx/sites-available/default
```
```bash
server {
        listen 80;
        listen [::]:80;

        server_name server_name mylearndevops.sytes.net www.mylearndevops.sytes.net;

        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;

        location / {
                try_files $uri $uri/ =404;
        }
}

```

```bash
sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
ubuntu@ip-172-31-28-239:~$
```

Далее используем ресурс `Let's Encrypt` для получения сертификата и настройки SSL. Для этого идем на сайт https://certbot.eff.org/ и следуя мануалу настраиваем получение сертификата для нашего сайта:
```bash

ubuntu@ip-172-31-28-239:~$ sudo snap install --classic certbot
certbot 3.0.1 from Certbot Project (certbot-eff✓) installed
ubuntu@ip-172-31-28-239:~$

sudo ln -s /snap/bin/certbot /usr/bin/certbot #symbol link to use "certbot"

```
```bash
ubuntu@ip-172-31-28-239:~$ sudo certbot --nginx -d mylearndevops.sytes.net
```
```bash
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Enter email address (used for urgent renewal and security notices)
 (Enter 'c' to cancel): yaraslau.alenchyk@innowise.com

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please read the Terms of Service at
https://letsencrypt.org/documents/LE-SA-v1.4-April-3-2024.pdf. You must agree in
order to register with the ACME server. Do you agree?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: yes

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Would you be willing, once your first certificate is successfully issued, to
share your email address with the Electronic Frontier Foundation, a founding
partner of the Let's Encrypt project and the non-profit organization that
develops Certbot? We'd like to send you email about our work encrypting the web,
EFF news, campaigns, and ways to support digital freedom.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: yes
Account registered.
Requesting a certificate for mylearndevops.sytes.net

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/mylearndevops.sytes.net/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/mylearndevops.sytes.net/privkey.pem
This certificate expires on 2025-04-07.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.

Deploying certificate
Successfully deployed certificate for mylearndevops.sytes.net to /etc/nginx/sites-enabled/default
Congratulations! You have successfully enabled HTTPS on https://mylearndevops.sytes.net

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ubuntu@ip-172-31-28-239:~$
```
проверяем автоматическую настройку файла `/etc/nginx/sites-enabled/default` и редактируюм если есть необходимость, приведя к виду:
```bash
server {
    listen 80;
    listen [::]:80;

    server_name mylearndevops.sytes.net www.mylearndevops.sytes.net;

    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl ipv6only=on; # managed by Certbot

    server_name mylearndevops.sytes.net www.mylearndevops.sytes.net;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    ssl_certificate /etc/letsencrypt/live/mylearndevops.sytes.net/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/mylearndevops.sytes.net/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    location / {
        try_files $uri $uri/ =404;
    }
}
```
или возможно получить только сертификаты и произвести настройки nginx как приведено выше 
```bash
sudo certbot certonly --nginx
```
После проверки правильности настройки перегружаем nginx:
```bash
sudo nginx -t
sudo systemctl reload nginx
```
И в завершении проверяем автоматическое обновление сертификатов командой 
```bash
sudo certbot renew --dry-run
```
и проверяем установку таймеров на автоматический запуск в `systemctl list-timers`:
```bash
ubuntu@ip-172-31-28-239:~$ sudo systemctl list-timers | grep certbot
Wed 2025-01-08 01:01:00 UTC      5h 14min -                                      - snap.certbot.renew.timer       snap.certbot.renew.service
ubuntu@ip-172-31-28-239:~$ sudo systemctl status snap.certbot.renew.service
○ snap.certbot.renew.service - Service for snap application certbot.renew
     Loaded: loaded (/etc/systemd/system/snap.certbot.renew.service; static)
     Active: inactive (dead)
TriggeredBy: ● snap.certbot.renew.timer
``` 

**UPDATE:**
Если сертификат в формате .p12  извлекаем следующим образом:
```bash
# Извлечение сертификата
openssl pkcs12 -nokeys -in your_certificate.p12 -out server-cert.pem

# Извлечение приватного ключа
openssl pkcs12 -nocerts -nodes -in your_certificate.p12 -out server.key

```

3. #### Point 3 
#### Установить Nginx на сервер. Написать конфигурацию nginx для обслуживания на 80 и 443 портах. 80 порт должен делать редирект на 443(сайт должен работать только по HTTPS). Веб-сервер должен раздавать /var/www/html/index.nginx-debian.html, который был сгенерирован User Data скриптом.Проверить работоспособность. При вводе домена в поисковую строку должен выдаваться текст: Welcome to my web server. My private IP is *********.
Сервер был установлен и настроен ранее (см.п.1 и 2)

Проверяем работу редиректа с http на https и корректного отображения web-страницы:
```bash
ubuntu@ip-172-31-28-239:~$ curl http://mylearndevops.sytes.net
<html>
<head><title>301 Moved Permanently</title></head>
<body>
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx/1.24.0 (Ubuntu)</center>
</body>
</html>
ubuntu@ip-172-31-28-239:~$ curl -L http://mylearndevops.sytes.net
This is My private IP is 172.31.28.239
ubuntu@ip-172-31-28-239:~$ curl  https://mylearndevops.sytes.net
This is My private IP is 172.31.28.239
```

**UPDATE:**

При попытке перейти на сайт по IP-адресу:
```bash

ubuntu@ip-172-31-28-239:~$ curl -Iv http://3.72.70.48
*   Trying 3.72.70.48:80...
* Connected to 3.72.70.48 (3.72.70.48) port 80
> HEAD / HTTP/1.1
> Host: 3.72.70.48
> User-Agent: curl/8.5.0
> Accept: */*
>
< HTTP/1.1 301 Moved Permanently
HTTP/1.1 301 Moved Permanently
< Server: nginx/1.24.0 (Ubuntu)
Server: nginx/1.24.0 (Ubuntu)
< Date: Fri, 17 Jan 2025 19:02:53 GMT
Date: Fri, 17 Jan 2025 19:02:53 GMT
< Content-Type: text/html
Content-Type: text/html
< Content-Length: 178
Content-Length: 178
< Connection: keep-alive
Connection: keep-alive
< Location: https://3.72.70.48/
Location: https://3.72.70.48/

<
* Connection #0 to host 3.72.70.48 left intact
ubuntu@ip-172-31-28-239:~$ curl -Iv https://3.72.70.48
*   Trying 3.72.70.48:443...
* Connected to 3.72.70.48 (3.72.70.48) port 443
* ALPN: curl offers h2,http/1.1
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
*  CAfile: /etc/ssl/certs/ca-certificates.crt
*  CApath: /etc/ssl/certs
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384 / X25519 / id-ecPublicKey
* ALPN: server accepted http/1.1
* Server certificate:
*  subject: CN=mylearndevops.sytes.net
*  start date: Jan  7 17:04:11 2025 GMT
*  expire date: Apr  7 17:04:10 2025 GMT
*  subjectAltName does not match 3.72.70.48
* SSL: no alternative certificate subject name matches target host name '3.72.70.48'
* Closing connection
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
* old SSL session ID is stale, removing
* TLSv1.3 (OUT), TLS alert, close notify (256):
curl: (60) SSL: no alternative certificate subject name matches target host name '3.72.70.48'
More details here: https://curl.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
ubuntu@ip-172-31-28-239:~$

```
Видим информацию о владельце, имя и т.д. 
В web-браузере можно перейти в незащещенное подключение. Чтобы это исправить и запретить доступ по ip-адресу добавляем в конфиг:
```bash
server {
	listen 80 default_server; # Сервер по умолчанию для 80 порта.
	deny all; # Запретить доступ всем.
	return 444; # Закрыть соединение без ответа.
}
server {
	listen 443 ssl default_server; # Сервер по умолчанию для 443 порта.
	http2 on; # Разрешить использовать HTTP/2, для версии выше 1.94
	ssl_reject_handshake on; # Отклонить рукопожатие.
}
```
проверяем 
```bash
ubuntu@ip-172-31-28-239:~$ curl -Iv https://3.72.70.48
*   Trying 3.72.70.48:443...
* Connected to 3.72.70.48 (3.72.70.48) port 443
* ALPN: curl offers h2,http/1.1
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
*  CAfile: /etc/ssl/certs/ca-certificates.crt
*  CApath: /etc/ssl/certs
* TLSv1.3 (IN), TLS alert, unrecognized name (624):
* OpenSSL/3.0.13: error:0A000458:SSL routines::tlsv1 unrecognized name
* Closing connection
curl: (35) OpenSSL/3.0.13: error:0A000458:SSL routines::tlsv1 unrecognized name

```

3. #### Point 4  
 #### Нужно изменять страницу nginx и конфигурационный файл: Клиент нажимает на слово-ссылку, после чего его перенаправляет на html-страницу с картинкой. Клиент нажимает на слово-ссылку, по которой можно скачать файл mp3 с музыкой. Сделать регулярное выражение для отображения картинок(png, jpg). Если формат jpg, то перевернуть картинку с помощью nginx. 
  
  
5. #### Point 5  
 #### Создать второй сервер t2.micro, установить Apache и PHP(fpm), взять за основу info.php файл. Настроить Apache на обслуживание данного файла.

Создадим сервер `green_server` добавив еще один в конфигурацию `main.tf` аналогично предыдущим. Для начальной установки web-сервера Apache заменим `user_data.sh` скрипт на этот: 

```bash
  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update -y
  sudo apt-get install -y apache2 php php-fpm
  sudo apt-get install libapache2-mod-php -y
  sudo a2enmod proxy_fcgi setenvif
  sudo a2enconf php8.3-fpm
  sudo systemctl start apache2
  sudo systemctl enable apache2

  echo "<?php phpinfo(); ?>" > /var/www/html/info.php
  EOF
```
После создания и запуска сервера, проверяем правильность установки Apache-сервера:
```bash
ubuntu@ip-172-31-20-170:~$ sudo systemctl status apache2
● apache2.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/apache2.service; enabled; preset: enabled)
     Active: active (running) since Fri 2025-01-10 17:41:24 UTC; 15min ago
       Docs: https://httpd.apache.org/docs/2.4/
    Process: 11809 ExecReload=/usr/sbin/apachectl graceful (code=exited, status=0/SUCCESS)
   Main PID: 10697 (apache2)
      Tasks: 7 (limit: 1130)
     Memory: 13.1M (peak: 22.5M)
        CPU: 172ms
     CGroup: /system.slice/apache2.service
             ├─10697 /usr/sbin/apache2 -k start
             ├─11814 /usr/sbin/apache2 -k start
             ├─11815 /usr/sbin/apache2 -k start
             ├─11816 /usr/sbin/apache2 -k start
             ├─11817 /usr/sbin/apache2 -k start
             ├─11818 /usr/sbin/apache2 -k start
             └─11827 /usr/sbin/apache2 -k start

Jan 10 17:41:24 ip-172-31-20-170 systemd[1]: Starting apache2.service - The Apache HTTP Server...
Jan 10 17:41:24 ip-172-31-20-170 systemd[1]: Started apache2.service - The Apache HTTP Server.
Jan 10 17:47:22 ip-172-31-20-170 systemd[1]: Reloading apache2.service - The Apache HTTP Server...
Jan 10 17:47:22 ip-172-31-20-170 systemd[1]: Reloaded apache2.service - The Apache HTTP Server.
ubuntu@ip-172-31-20-170:~$
```
и правильность установки PHP(fpm):

```bash

ubuntu@ip-172-31-20-170:~$ sudo systemctl status php8.3-fpm
● php8.3-fpm.service - The PHP 8.3 FastCGI Process Manager
     Loaded: loaded (/usr/lib/systemd/system/php8.3-fpm.service; enabled; preset: enabled)
     Active: active (running) since Fri 2025-01-10 17:41:24 UTC; 7min ago
       Docs: man:php-fpm8.3(8)
   Main PID: 10659 (php-fpm8.3)
     Status: "Processes active: 0, idle: 2, Requests: 0, slow: 0, Traffic: 0req/sec"
      Tasks: 3 (limit: 1130)
     Memory: 7.5M (peak: 8.4M)
        CPU: 69ms
     CGroup: /system.slice/php8.3-fpm.service
             ├─10659 "php-fpm: master process (/etc/php/8.3/fpm/php-fpm.conf)"
             ├─10660 "php-fpm: pool www"
             └─10661 "php-fpm: pool www"
```

Проверяем работу сервера запросом через браузер или curl `curl http://localhost` :
<details>
<summary> <b>Смотрим html-страницу в ответе </b></summary>

```bash
ubuntu@ip-172-31-20-170:~$ curl http://localhost
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <!--
    Modified from the Debian original for Ubuntu
    Last updated: 2022-03-22
    See: https://launchpad.net/bugs/1966004
  -->
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Apache2 Ubuntu Default Page: It works</title>
    <style type="text/css" media="screen">
  * {
    margin: 0px 0px 0px 0px;
    padding: 0px 0px 0px 0px;
  }

  body, html {
    padding: 3px 3px 3px 3px;

    background-color: #D8DBE2;

    font-family: Ubuntu, Verdana, sans-serif;
    font-size: 11pt;
    text-align: center;
  }

  div.main_page {
    position: relative;
    display: table;

    width: 800px;

    margin-bottom: 3px;
    margin-left: auto;
    margin-right: auto;
    padding: 0px 0px 0px 0px;

    border-width: 2px;
    border-color: #212738;
    border-style: solid;

    background-color: #FFFFFF;

    text-align: center;
  }

  div.page_header {
    height: 180px;
    width: 100%;

    background-color: #F5F6F7;
  }

  div.page_header span {
    margin: 15px 0px 0px 50px;

    font-size: 180%;
    font-weight: bold;
  }

  div.page_header img {
    margin: 3px 0px 0px 40px;

    border: 0px 0px 0px;
  }

  div.banner {
    padding: 9px 6px 9px 6px;
    background-color: #E9510E;
    color: #FFFFFF;
    font-weight: bold;
    font-size: 112%;
    text-align: center;
    position: absolute;
    left: 40%;
    bottom: 30px;
    width: 20%;
  }

  div.table_of_contents {
    clear: left;

    min-width: 200px;

    margin: 3px 3px 3px 3px;

    background-color: #FFFFFF;

    text-align: left;
  }

  div.table_of_contents_item {
    clear: left;

    width: 100%;

    margin: 4px 0px 0px 0px;

    background-color: #FFFFFF;

    color: #000000;
    text-align: left;
  }

  div.table_of_contents_item a {
    margin: 6px 0px 0px 6px;
  }

  div.content_section {
    margin: 3px 3px 3px 3px;

    background-color: #FFFFFF;

    text-align: left;
  }

  div.content_section_text {
    padding: 4px 8px 4px 8px;

    color: #000000;
    font-size: 100%;
  }

  div.content_section_text pre {
    margin: 8px 0px 8px 0px;
    padding: 8px 8px 8px 8px;

    border-width: 1px;
    border-style: dotted;
    border-color: #000000;

    background-color: #F5F6F7;

    font-style: italic;
  }

  div.content_section_text p {
    margin-bottom: 6px;
  }

  div.content_section_text ul, div.content_section_text li {
    padding: 4px 8px 4px 16px;
  }

  div.section_header {
    padding: 3px 6px 3px 6px;

    background-color: #8E9CB2;

    color: #FFFFFF;
    font-weight: bold;
    font-size: 112%;
    text-align: center;
  }

  div.section_header_grey {
    background-color: #9F9386;
  }

  .floating_element {
    position: relative;
    float: left;
  }

  div.table_of_contents_item a,
  div.content_section_text a {
    text-decoration: none;
    font-weight: bold;
  }

  div.table_of_contents_item a:link,
  div.table_of_contents_item a:visited,
  div.table_of_contents_item a:active {
    color: #000000;
  }

  div.table_of_contents_item a:hover {
    background-color: #000000;

    color: #FFFFFF;
  }

  div.content_section_text a:link,
  div.content_section_text a:visited,
   div.content_section_text a:active {
    background-color: #DCDFE6;

    color: #000000;
  }

  div.content_section_text a:hover {
    background-color: #000000;

    color: #DCDFE6;
  }

  div.validator {
  }
    </style>
  </head>
  <body>
    <div class="main_page">
      <div class="page_header floating_element">
        <img src="icons/ubuntu-logo.png" alt="Ubuntu Logo"
             style="width:184px;height:146px;" class="floating_element" />
        <div>
          <span style="margin-top: 1.5em;" class="floating_element">
            Apache2 Default Page
          </span>
        </div>
        <div class="banner">
          <div id="about"></div>
          It works!
        </div>

      </div>
      <div class="content_section floating_element">
        <div class="content_section_text">
          <p>
                This is the default welcome page used to test the correct
                operation of the Apache2 server after installation on Ubuntu systems.
                It is based on the equivalent page on Debian, from which the Ubuntu Apache
                packaging is derived.
                If you can read this page, it means that the Apache HTTP server installed at
                this site is working properly. You should <b>replace this file</b> (located at
                <tt>/var/www/html/index.html</tt>) before continuing to operate your HTTP server.
          </p>

          <p>
                If you are a normal user of this web site and don't know what this page is
                about, this probably means that the site is currently unavailable due to
                maintenance.
                If the problem persists, please contact the site's administrator.
          </p>

        </div>
        <div class="section_header">
          <div id="changes"></div>
                Configuration Overview
        </div>
        <div class="content_section_text">
          <p>
                Ubuntu's Apache2 default configuration is different from the
                upstream default configuration, and split into several files optimized for
                interaction with Ubuntu tools. The configuration system is
                <b>fully documented in
                /usr/share/doc/apache2/README.Debian.gz</b>. Refer to this for the full
                documentation. Documentation for the web server itself can be
                found by accessing the <a href="/manual">manual</a> if the <tt>apache2-doc</tt>
                package was installed on this server.
          </p>
          <p>
                The configuration layout for an Apache2 web server installation on Ubuntu systems is as follows:
          </p>
          <pre>
/etc/apache2/
|-- apache2.conf
|       `--  ports.conf
|-- mods-enabled
|       |-- *.load
|       `-- *.conf
|-- conf-enabled
|       `-- *.conf
|-- sites-enabled
|       `-- *.conf
          </pre>
          <ul>
                        <li>
                           <tt>apache2.conf</tt> is the main configuration
                           file. It puts the pieces together by including all remaining configuration
                           files when starting up the web server.
                        </li>

                        <li>
                           <tt>ports.conf</tt> is always included from the
                           main configuration file. It is used to determine the listening ports for
                           incoming connections, and this file can be customized anytime.
                        </li>

                        <li>
                           Configuration files in the <tt>mods-enabled/</tt>,
                           <tt>conf-enabled/</tt> and <tt>sites-enabled/</tt> directories contain
                           particular configuration snippets which manage modules, global configuration
                           fragments, or virtual host configurations, respectively.
                        </li>

                        <li>
                           They are activated by symlinking available
                           configuration files from their respective
                           *-available/ counterparts. These should be managed
                           by using our helpers
                           <tt>
                                a2enmod,
                                a2dismod,
                           </tt>
                           <tt>
                                a2ensite,
                                a2dissite,
                            </tt>
                                and
                           <tt>
                                a2enconf,
                                a2disconf
                           </tt>. See their respective man pages for detailed information.
                        </li>

                        <li>
                           The binary is called apache2 and is managed using systemd, so to
                           start/stop the service use <tt>systemctl start apache2</tt> and
                           <tt>systemctl stop apache2</tt>, and use <tt>systemctl status apache2</tt>
                           and <tt>journalctl -u apache2</tt> to check status.  <tt>system</tt>
                           and <tt>apache2ctl</tt> can also be used for service management if
                           desired.
                           <b>Calling <tt>/usr/bin/apache2</tt> directly will not work</b> with the
                           default configuration.
                        </li>
          </ul>
        </div>

        <div class="section_header">
            <div id="docroot"></div>
                Document Roots
        </div>

        <div class="content_section_text">
            <p>
                By default, Ubuntu does not allow access through the web browser to
                <em>any</em> file outside of those located in <tt>/var/www</tt>,
                <a href="http://httpd.apache.org/docs/2.4/mod/mod_userdir.html" rel="nofollow">public_html</a>
                directories (when enabled) and <tt>/usr/share</tt> (for web
                applications). If your site is using a web document root
                located elsewhere (such as in <tt>/srv</tt>) you may need to whitelist your
                document root directory in <tt>/etc/apache2/apache2.conf</tt>.
            </p>
            <p>
                The default Ubuntu document root is <tt>/var/www/html</tt>. You
                can make your own virtual hosts under /var/www.
            </p>
        </div>

        <div class="section_header">
          <div id="bugs"></div>
                Reporting Problems
        </div>
        <div class="content_section_text">
          <p>
                Please use the <tt>ubuntu-bug</tt> tool to report bugs in the
                Apache2 package with Ubuntu. However, check <a
                href="https://bugs.launchpad.net/ubuntu/+source/apache2"
                rel="nofollow">existing bug reports</a> before reporting a new bug.
          </p>
          <p>
                Please report bugs specific to modules (such as PHP and others)
                to their respective packages, not to the web server itself.
          </p>
        </div>

      </div>
    </div>
    <div class="validator">
    </div>
  </body>
</html>
```
</details><br>

6. #### Point 6  
 ####  Создать слово-ссылку в html-странице, которая будет перенаправлять запрос с Nginx-cервера на Apache-сервер.

Сначала настроим сервер NGINX как прокси и настроить ссылку. Редактируем для этого `/etc/nginx/sites-enabled/default` добавляя путь `/proxy`:
```bash
location /proxy {
    proxy_pass http://<IP-адрес-Apache>:<порт-Apache>/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}

```
полный конфиг здесь [nginx.conf](nginx.conf).

Далее правим html-страницу:

```bash
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Proxy Example</title>
</head>
<body>
    <h1>Welcome to the Proxy Example</h1>
    <p>Click the link below to visit the Apache server via Nginx:</p>
    <a href="/proxy">Go to Apache Server</a>
</body>
</html>

```
проверяем конфигурацию, перезапускаем nginx и проверяем `curl https://mylearndevops.sytes.net/proxy` или в браузере

<details>
<summary> <b>Смотрим html-страницу в ответе </b></summary>

```bash
ubuntu@ip-172-31-28-239:~$ curl https://mylearndevops.sytes.net/proxy
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <!--
    Modified from the Debian original for Ubuntu
    Last updated: 2022-03-22
    See: https://launchpad.net/bugs/1966004
  -->
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Apache2 Ubuntu Default Page: It works</title>
    <style type="text/css" media="screen">
  * {
    margin: 0px 0px 0px 0px;
    padding: 0px 0px 0px 0px;
  }

  body, html {
    padding: 3px 3px 3px 3px;

    background-color: #D8DBE2;

    font-family: Ubuntu, Verdana, sans-serif;
    font-size: 11pt;
    text-align: center;
  }

  div.main_page {
    position: relative;
    display: table;

    width: 800px;

    margin-bottom: 3px;
    margin-left: auto;
    margin-right: auto;
    padding: 0px 0px 0px 0px;

    border-width: 2px;
    border-color: #212738;
    border-style: solid;

    background-color: #FFFFFF;

    text-align: center;
  }

  div.page_header {
    height: 180px;
    width: 100%;

    background-color: #F5F6F7;
  }

  div.page_header span {
    margin: 15px 0px 0px 50px;

    font-size: 180%;
    font-weight: bold;
  }

  div.page_header img {
    margin: 3px 0px 0px 40px;

    border: 0px 0px 0px;
  }

  div.banner {
    padding: 9px 6px 9px 6px;
    background-color: #E9510E;
    color: #FFFFFF;
    font-weight: bold;
    font-size: 112%;
    text-align: center;
    position: absolute;
    left: 40%;
    bottom: 30px;
    width: 20%;
  }

  div.table_of_contents {
    clear: left;

    min-width: 200px;

    margin: 3px 3px 3px 3px;

    background-color: #FFFFFF;

    text-align: left;
  }

  div.table_of_contents_item {
    clear: left;

    width: 100%;

    margin: 4px 0px 0px 0px;

    background-color: #FFFFFF;

    color: #000000;
    text-align: left;
  }

  div.table_of_contents_item a {
    margin: 6px 0px 0px 6px;
  }

  div.content_section {
    margin: 3px 3px 3px 3px;

    background-color: #FFFFFF;

    text-align: left;
  }

  div.content_section_text {
    padding: 4px 8px 4px 8px;

    color: #000000;
    font-size: 100%;
  }

  div.content_section_text pre {
    margin: 8px 0px 8px 0px;
    padding: 8px 8px 8px 8px;

    border-width: 1px;
    border-style: dotted;
    border-color: #000000;

    background-color: #F5F6F7;

    font-style: italic;
  }

  div.content_section_text p {
    margin-bottom: 6px;
  }

  div.content_section_text ul, div.content_section_text li {
    padding: 4px 8px 4px 16px;
  }

  div.section_header {
    padding: 3px 6px 3px 6px;

    background-color: #8E9CB2;

    color: #FFFFFF;
    font-weight: bold;
    font-size: 112%;
    text-align: center;
  }

  div.section_header_grey {
    background-color: #9F9386;
  }

  .floating_element {
    position: relative;
    float: left;
  }

  div.table_of_contents_item a,
  div.content_section_text a {
    text-decoration: none;
    font-weight: bold;
  }

  div.table_of_contents_item a:link,
  div.table_of_contents_item a:visited,
  div.table_of_contents_item a:active {
    color: #000000;
  }

  div.table_of_contents_item a:hover {
    background-color: #000000;

    color: #FFFFFF;
  }

  div.content_section_text a:link,
  div.content_section_text a:visited,
   div.content_section_text a:active {
    background-color: #DCDFE6;

    color: #000000;
  }

  div.content_section_text a:hover {
    background-color: #000000;

    color: #DCDFE6;
  }

  div.validator {
  }
    </style>
  </head>
  <body>
    <div class="main_page">
      <div class="page_header floating_element">
        <img src="icons/ubuntu-logo.png" alt="Ubuntu Logo"
             style="width:184px;height:146px;" class="floating_element" />
        <div>
          <span style="margin-top: 1.5em;" class="floating_element">
            Apache2 Default Page
          </span>
        </div>
        <div class="banner">
          <div id="about"></div>
          It works!
        </div>

      </div>
      <div class="content_section floating_element">
        <div class="content_section_text">
          <p>
                This is the default welcome page used to test the correct
                operation of the Apache2 server after installation on Ubuntu systems.
                It is based on the equivalent page on Debian, from which the Ubuntu Apache
                packaging is derived.
                If you can read this page, it means that the Apache HTTP server installed at
                this site is working properly. You should <b>replace this file</b> (located at
                <tt>/var/www/html/index.html</tt>) before continuing to operate your HTTP server.
          </p>

          <p>
                If you are a normal user of this web site and don't know what this page is
                about, this probably means that the site is currently unavailable due to
                maintenance.
                If the problem persists, please contact the site's administrator.
          </p>

        </div>
        <div class="section_header">
          <div id="changes"></div>
                Configuration Overview
        </div>
        <div class="content_section_text">
          <p>
                Ubuntu's Apache2 default configuration is different from the
                upstream default configuration, and split into several files optimized for
                interaction with Ubuntu tools. The configuration system is
                <b>fully documented in
                /usr/share/doc/apache2/README.Debian.gz</b>. Refer to this for the full
                documentation. Documentation for the web server itself can be
                found by accessing the <a href="/manual">manual</a> if the <tt>apache2-doc</tt>
                package was installed on this server.
          </p>
          <p>
                The configuration layout for an Apache2 web server installation on Ubuntu systems is as follows:
          </p>
          <pre>
/etc/apache2/
|-- apache2.conf
|       `--  ports.conf
|-- mods-enabled
|       |-- *.load
|       `-- *.conf
|-- conf-enabled
|       `-- *.conf
|-- sites-enabled
|       `-- *.conf
          </pre>
          <ul>
                        <li>
                           <tt>apache2.conf</tt> is the main configuration
                           file. It puts the pieces together by including all remaining configuration
                           files when starting up the web server.
                        </li>

                        <li>
                           <tt>ports.conf</tt> is always included from the
                           main configuration file. It is used to determine the listening ports for
                           incoming connections, and this file can be customized anytime.
                        </li>

                        <li>
                           Configuration files in the <tt>mods-enabled/</tt>,
                           <tt>conf-enabled/</tt> and <tt>sites-enabled/</tt> directories contain
                           particular configuration snippets which manage modules, global configuration
                           fragments, or virtual host configurations, respectively.
                        </li>

                        <li>
                           They are activated by symlinking available
                           configuration files from their respective
                           *-available/ counterparts. These should be managed
                           by using our helpers
                           <tt>
                                a2enmod,
                                a2dismod,
                           </tt>
                           <tt>
                                a2ensite,
                                a2dissite,
                            </tt>
                                and
                           <tt>
                                a2enconf,
                                a2disconf
                           </tt>. See their respective man pages for detailed information.
                        </li>

                        <li>
                           The binary is called apache2 and is managed using systemd, so to
                           start/stop the service use <tt>systemctl start apache2</tt> and
                           <tt>systemctl stop apache2</tt>, and use <tt>systemctl status apache2</tt>
                           and <tt>journalctl -u apache2</tt> to check status.  <tt>system</tt>
                           and <tt>apache2ctl</tt> can also be used for service management if
                           desired.
                           <b>Calling <tt>/usr/bin/apache2</tt> directly will not work</b> with the
                           default configuration.
                        </li>
          </ul>
        </div>

        <div class="section_header">
            <div id="docroot"></div>
                Document Roots
        </div>

        <div class="content_section_text">
            <p>
                By default, Ubuntu does not allow access through the web browser to
                <em>any</em> file outside of those located in <tt>/var/www</tt>,
                <a href="http://httpd.apache.org/docs/2.4/mod/mod_userdir.html" rel="nofollow">public_html</a>
                directories (when enabled) and <tt>/usr/share</tt> (for web
                applications). If your site is using a web document root
                located elsewhere (such as in <tt>/srv</tt>) you may need to whitelist your
                document root directory in <tt>/etc/apache2/apache2.conf</tt>.
            </p>
            <p>
                The default Ubuntu document root is <tt>/var/www/html</tt>. You
                can make your own virtual hosts under /var/www.
            </p>
        </div>

        <div class="section_header">
          <div id="bugs"></div>
                Reporting Problems
        </div>
        <div class="content_section_text">
          <p>
                Please use the <tt>ubuntu-bug</tt> tool to report bugs in the
                Apache2 package with Ubuntu. However, check <a
                href="https://bugs.launchpad.net/ubuntu/+source/apache2"
                rel="nofollow">existing bug reports</a> before reporting a new bug.
          </p>
          <p>
                Please report bugs specific to modules (such as PHP and others)
                to their respective packages, not to the web server itself.
          </p>
        </div>

      </div>
    </div>
    <div class="validator">
    </div>
  </body>
</html>
```

</details><br>