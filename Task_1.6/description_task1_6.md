### Чекпоинты:

[1) Создать сервер t2.micro(Ubuntu), он должен иметь публичный ip и доступ в интернет. При создании использовать User Data cкрипт(приложен ниже user_data.sh). Разрешить http и https трафик в security group, ассоциированной с данным сервером.](#Point-1)  
[2) Зарегистрироваться на сайте: Free Dynamic DNS - Managed DNS - Managed Email - Domain Registration - No-IP , разобраться в типах DNS записей, сделать DNS записать типа A для созданного сервера.Получить сертификат для своего сервера, используя letsencrypt. Разобраться в цепочках сертификатов.](#Point-2)  
[3) Установить Nginx на сервер. Написать конфигурацию nginx для обслуживания на 80 и 443 портах. 80 порт должен делать редирект на 443(сайт должен работать только по HTTPS). Веб-сервер должен раздавать /var/www/html/index.nginx-debian.html, который был сгенерирован User Data скриптом.Проверить работоспособность. При вводе домена в поисковую строку должен выдаваться текст: Welcome to my web server. My private IP is *********. ](#Point-3)  
[4) Нужно изменять страницу nginx и конфигурационный файл: Клиент нажимает на слово-ссылку, после чего его перенаправляет на html-страницу с картинкой. Клиент нажимает на слово-ссылку, по которой можно скачать файл mp3 с музыкой. Сделать регулярное выражение для отображения картинок(png, jpg). Если формат jpg, то перевернуть картинку с помощью nginx. ](#Point-4)   
[5) Создать второй сервер t2.micro, установить Apache и PHP(fpm), взять за основу info.php файл. Настроить Apache на обслуживание данного файла.](#Point-5)  
[6) Создать слово-ссылку в html-странице, которая будет перенаправлять запрос с Nginx-cервера на Apache-сервер.](#Point-6)  


1. #### Point 1  
#### Создать сервер t2.micro(Ubuntu), он должен иметь публичный ip и доступ в интернет. При создании использовать User Data cкрипт(приложен ниже user_data.sh). Разрешить http и https трафик в security group, ассоциированной с данным сервером.

2. #### Point 2  
 #### Зарегистрироваться на сайте: Free Dynamic DNS - Managed DNS - Managed Email - Domain Registration - No-IP , разобраться в типах DNS записей, сделать DNS записать типа A для созданного сервера.Получить сертификат для своего сервера, используя letsencrypt. Разобраться в цепочках сертификатов.


3. #### Point 3 
   #### Установить Nginx на сервер. Написать конфигурацию nginx для обслуживания на 80 и 443 портах. 80 порт должен делать редирект на 443(сайт должен работать только по HTTPS). Веб-сервер должен раздавать /var/www/html/index.nginx-debian.html, который был сгенерирован User Data скриптом.Проверить работоспособность. При вводе домена в поисковую строку должен выдаваться текст: Welcome to my web server. My private IP is *********.

3. #### Point 4  
 #### Нужно изменять страницу nginx и конфигурационный файл: Клиент нажимает на слово-ссылку, после чего его перенаправляет на html-страницу с картинкой. Клиент нажимает на слово-ссылку, по которой можно скачать файл mp3 с музыкой. Сделать регулярное выражение для отображения картинок(png, jpg). Если формат jpg, то перевернуть картинку с помощью nginx. 
  
  
5. #### Point 5  
 #### Создать второй сервер t2.micro, установить Apache и PHP(fpm), взять за основу info.php файл. Настроить Apache на обслуживание данного файла.

6. #### Point 6  
 ####  Создать слово-ссылку в html-странице, которая будет перенаправлять запрос с Nginx-cервера на Apache-сервер.


<details>
<summary> <b>Смотрим лог </b></summary>
</details><br>