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
```
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

3. #### Point 4  
 #### Нужно изменять страницу nginx и конфигурационный файл: Клиент нажимает на слово-ссылку, после чего его перенаправляет на html-страницу с картинкой. Клиент нажимает на слово-ссылку, по которой можно скачать файл mp3 с музыкой. Сделать регулярное выражение для отображения картинок(png, jpg). Если формат jpg, то перевернуть картинку с помощью nginx. 
  
  
5. #### Point 5  
 #### Создать второй сервер t2.micro, установить Apache и PHP(fpm), взять за основу info.php файл. Настроить Apache на обслуживание данного файла.

6. #### Point 6  
 ####  Создать слово-ссылку в html-странице, которая будет перенаправлять запрос с Nginx-cервера на Apache-сервер.


<details>
<summary> <b>Смотрим лог </b></summary>
</details><br>