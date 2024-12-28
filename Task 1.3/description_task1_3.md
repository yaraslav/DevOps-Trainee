### Чекпоинты:

[1) Написать Systemd unit, который будет раз в 15 секунд писать в файл вывод команды uptime. При убийстве процесса он должен перезапускаться. ](#Point-1)  
[2) Если значение Load Average за минуту больше 1, то вывод команды uptime должен записываться в файл overload. ](#Point-2)  
[3) Установить утилиту stress. Нагрузить свою систему, применив команду stress --cpu x --timeout 50s, где x - количество процессоров у виртуалки/системы. Проверить работоспособность 2 пунтка.](#Point-3)  
[4) Когда файл overload достигает размера в 50 кб, то он должен очищаться. В файл cleanup должны складываться логи об успешных очистках с временем самой очистки.](#Point-4)   
[5) Написать cron job, проверяющий каждые 10 минут статус вышесозданного юнита.](#Point-5)  
[6) Запустить утилиту ping, вывести запущенный процесс в background, проверить, что процесс находится в фоновом режиме, вернуть процесс в foreground. Остановить процесс, после чего удалить его. ](#Point-6)  


1. #### Point 1  
#### Написать Systemd unit, который будет раз в 15 секунд писать в файл вывод команды uptime. При убийстве процесса он должен перезапускаться. 

Создаем скрипт для получения вывода команды `uptime_logger.sh` каждые 15 секунд:

```bash
#!/bin/bash

LOGS_PATH= "/var/log/"
OUTPUT_FILE="$LOGS_PATH/uptime.log"

# Проверка наличия файлов и создание их, если они не существуют
if [ ! -f "$OUTPUT_FILE" ]; then
  touch "$OUTPUT_FILE"
fi

while true; do
  UPTIME_OUTPUT=$(uptime)
  sleep 15
done
```

Создаем Systemd service unit `uptime-logger.service`, чтобы этот сервис мог работать для всей системы, например, для всех пользователей или с правами суперпользователя, создаем его в каталоге `/etc/systemd/system/` :

```bash
ubuntu@ip-172-31-30-89:~$ sudo touch /etc/systemd/system/uptime-logger.service
ubuntu@ip-172-31-30-89:~$ ls -la /etc/systemd/system/uptime-logger.service
-rw-r--r-- 1 root root 0 Dec 28 18:54 /etc/systemd/system/uptime-logger.service
```
и редактируем его следующим порядком ```sudo nano /etc/systemd/system/uptime-logger.service``` внеся информацию, что ниже:
```ini
[Unit]
Description=Uptime Logger Service
After=network.target

[Service]
ExecStart=/home/ubuntu/uptime-logger.sh
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

Включаем глобально и запускаем службу:
```bash
sudo systemctl daemon-reload
sudo systemctl enable uptime-logger.service
sudo systemctl start uptime-logger.service
```

2. #### Point 2  
 #### Если значение Load Average за минуту больше 1, то вывод команды uptime должен записываться в файл overload.

Вывод значения Load Average за минуту можно получить командой
```bash
uptime | awk -F'load average: ' '{print $2}' | cut -d, -f1
```
    ubuntu@ip-172-31-30-89:~$ uptime | awk -F'load average: ' '{print $2}' | cut -d, -f1
    0.64

Для проверки значения Load Average  превышающего `1.0` за минуту добавляем в скрипт следующее:
```bash
  # Если Load Average за минуту больше 1
  if awk "BEGIN {exit !($LOAD_AVERAGE > 1)}"; then
    echo "$UPTIME_OUTPUT" >> "$OVERLOAD_FILE"
  else
    echo "$UPTIME_OUTPUT" >> "$OUTPUT_FILE"
  fi
```

3. #### Point 3  
 ####   Установить утилиту stress. Нагрузить свою систему, применив команду stress --cpu x --timeout 50s, где x - количество процессоров у виртуалки/системы. Проверить работоспособность 2 пунтка. 

```
sudo apt install stress-ng
```

4. #### Point 4  
 #### Когда файл overload достигает размера в 50 кб, то он должен очищаться. В файл cleanup должны складываться логи об успешных очистках с временем самой очистки.
Добавляем в скрипт:
```bash
#!/bin/bash

OVERLOAD_FILE="/path/to/overload"
CLEANUP_FILE="/path/to/cleanup"

if [ $(stat -c%s "$OVERLOAD_FILE") -ge 51200 ]; then
    echo "$(date): Cleaning up overload file" >> $CLEANUP_FILE
    > $OVERLOAD_FILE
fi
```

    
5. #### Point 5  
 #### Написать cron job, проверяющий каждые 10 минут статус вышесозданного юнита.

Create a cron job:
```bash
*/10 * * * * systemctl is-active --quiet uptime-logger.service || systemctl restart uptime_logger.service
```

6. #### Point 6  
 ####  Запустить утилиту ping, вывести запущенный процесс в background, проверить, что процесс находится в фоновом режиме, вернуть процесс в foreground. Остановить процесс, после чего удалить его.


