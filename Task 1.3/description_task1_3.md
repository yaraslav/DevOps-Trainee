### Чекпоинты:

[1) Написать Systemd unit, который будет раз в 15 секунд писать в файл вывод команды uptime. При убийстве процесса он должен перезапускаться. ](#Point-1)  
[2) Если значение Load Average за минуту больше 1, то вывод команды uptime должен записываться в файл overload. ](#Point-2)  
[3) Установить утилиту stress. Нагрузить свою систему, применив команду stress --cpu x --timeout 50s, где x - количество процессоров у виртуалки/системы. Проверить работоспособность 2 пунтка.](#Point-3)  
[4) Когда файл overload достигает размера в 50 кб, то он должен очищаться. В файл cleanup должны складываться логи об успешных очистках с временем самой очистки.](#Point-4)   
[5) Написать cron job, проверяющий каждые 10 минут статус вышесозданного юнита.](#Point-5)  
[6) Запустить утилиту ping, вывести запущенный процесс в background, проверить, что процесс находится в фоновом режиме, вернуть процесс в foreground. Остановить процесс, после чего удалить его. ](#Point-6)  


1. #### Point 1  
#### Написать Systemd unit, который будет раз в 15 секунд писать в файл вывод команды uptime. При убийстве процесса он должен перезапускаться. 


2. #### Point 2  
 #### Если значение Load Average за минуту больше 1, то вывод команды uptime должен записываться в файл overload.


3. #### Point 3  
 ####   Установить утилиту stress. Нагрузить свою систему, применив команду stress --cpu x --timeout 50s, где x - количество процессоров у виртуалки/системы. Проверить работоспособность 2 пунтка. 

```
sudo apt install stress-ng
```

4. #### Point 4  
 #### Когда файл overload достигает размера в 50 кб, то он должен очищаться. В файл cleanup должны складываться логи об успешных очистках с временем самой очистки.

    
5. #### Point 5  
 #### Написать cron job, проверяющий каждые 10 минут статус вышесозданного юнита.


6. #### Point 6  
 ####  Запустить утилиту ping, вывести запущенный процесс в background, проверить, что процесс находится в фоновом режиме, вернуть процесс в foreground. Остановить процесс, после чего удалить его. 

