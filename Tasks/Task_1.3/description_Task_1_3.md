### Чекпоинты:

[1) Написать Systemd unit, который будет раз в 15 секунд писать в файл вывод команды uptime. При убийстве процесса он должен перезапускаться. ](#point-1)  
[2) Если значение Load Average за минуту больше 1, то вывод команды uptime должен записываться в файл overload. ](#point-2)  
[3) Установить утилиту stress. Нагрузить свою систему, применив команду stress --cpu x --timeout 50s, где x - количество процессоров у виртуалки/системы. Проверить работоспособность 2 пунтка.](#point-3)  
[4) Когда файл overload достигает размера в 50 кб, то он должен очищаться. В файл cleanup должны складываться логи об успешных очистках с временем самой очистки.](#point-4)   
[5) Написать cron job, проверяющий каждые 10 минут статус вышесозданного юнита.](#point-5)  
[6) Запустить утилиту ping, вывести запущенный процесс в background, проверить, что процесс находится в фоновом режиме, вернуть процесс в foreground. Остановить процесс, после чего удалить его. ](#point-6)  


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
  echo "$UPTIME_OUTPUT" >> "$OUTPUT_FILE"
  sleep 15
done
```
Делаем его исполняемым `chmod +x uptime_logger.sh`

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
   LOAD_AVERAGE=$(echo $UPTIME_OUTPUT | awk -F'load average: ' '{print $2}' | cut -d, -f1)

  # Если Load Average за минуту больше 1
  if awk "BEGIN {exit !($LOAD_AVERAGE > 1)}"; then
    echo "$UPTIME_OUTPUT" >> "$OVERLOAD_FILE"
  else
    echo "$UPTIME_OUTPUT" >> "$OUTPUT_FILE"
  fi
```

3. #### Point 3  
 ####   Установить утилиту stress. Нагрузить свою систему, применив команду stress --cpu x --timeout 50s, где x - количество процессоров у виртуалки/системы. Проверить работоспособность 2 пунтка. 
Буду использовать утилиту `stress-ng`
```bash
sudo apt install stress-ng
```
```bash
ubuntu@ip-172-31-30-89:~$ stress-ng --cpu 4 --timeout 50s
stress-ng: info:  [3803] setting to a 50 secs run per stressor
stress-ng: info:  [3803] dispatching hogs: 4 cpu
stress-ng: info:  [3803] skipped: 0
stress-ng: info:  [3803] passed: 4: cpu (4)
stress-ng: info:  [3803] failed: 0
stress-ng: info:  [3803] metrics untrustworthy: 0
stress-ng: info:  [3803] successful run completed in 50.01 secs
```

4. #### Point 4  
 #### Когда файл overload достигает размера в 50 кб, то он должен очищаться. В файл cleanup должны складываться логи об успешных очистках с временем самой очистки.
Добавляем в скрипт:
```bash
#!/bin/bash

OVERLOAD_FILE="$LOGS_PATH/overload.log"
CLEANUP_FILE="$LOGS_PATH/cleanup.log"

if [ $(stat -c%s "$OVERLOAD_FILE") -ge 51200 ]; then
    echo "$(date): Cleaning up overload file" >> $CLEANUP_FILE
    > $OVERLOAD_FILE
fi
```
Итого весь скрипт будет выглядеть так [uptime-logger.sh](uptime-logger.sh)
    
5. #### Point 5  
 #### Написать cron job, проверяющий каждые 10 минут статус вышесозданного юнита.

Создаем задачу в cron job создав новую запись в  `crontab -e` которая будет проверять сервис и перезапускать его если он не активен.

```bash
*/10 * * * * systemctl is-active --quiet uptime-logger.service || systemctl restart uptime_logger.service
```
проверяем создание записи `crontab -l`, работу проверяем в логах, например тут `sudo journalctl -u cron
`

6. #### Point 6  
 ####  Запустить утилиту ping, вывести запущенный процесс в background, проверить, что процесс находится в фоновом режиме, вернуть процесс в foreground. Остановить процесс, после чего удалить его.

Запустить утилиту ping и вывести запущенный процесс в background
```bash
ping google.com > ping_output.txt &
```
Проверить, что процесс находится в фоновом режиме
`jobs`

Вернуть процесс в foreground
`fg %1`

Остановить процесс
`Ctrl + C`

Удалить процесс `kill -9 ping`

Вывод выполнения команд:
```bash
ubuntu@ip-172-31-30-89:~$ ping google.com > ping_output.txt &
[1] 8281
ubuntu@ip-172-31-30-89:~$ ^C
ubuntu@ip-172-31-30-89:~$ jobs
[1]+  Running                 ping google.com > ping_output.txt &
ubuntu@ip-172-31-30-89:~$
ubuntu@ip-172-31-30-89:~$ fg %1
ping google.com > ping_output.txt
ubuntu@ip-172-31-30-89:~$ ^C
ubuntu@ip-172-31-30-89:~$ ps
    PID TTY          TIME CMD
   1614 pts/0    00:00:00 bash
   8484 pts/0    00:00:00 ps
ubuntu@ip-172-31-30-89:~$
ubuntu@ip-172-31-30-89:~$ ping google.com > ping_output.txt &
[1] 8509
ubuntu@ip-172-31-30-89:~$ ps
    PID TTY          TIME CMD
   1614 pts/0    00:00:00 bash
   8509 pts/0    00:00:00 ping
   8522 pts/0    00:00:00 ps
ubuntu@ip-172-31-30-89:~$ kill -9 ping
-bash: kill: ping: arguments must be process or job IDs
ubuntu@ip-172-31-30-89:~$ kill -9 8509
ubuntu@ip-172-31-30-89:~$ ps
    PID TTY          TIME CMD
   1614 pts/0    00:00:00 bash
   8701 pts/0    00:00:00 ps
[1]+  Killed                  ping google.com > ping_output.txt
ubuntu@ip-172-31-30-89:~$
ubuntu@ip-172-31-30-89:~$ ps
    PID TTY          TIME CMD
   1614 pts/0    00:00:00 bash
   8738 pts/0    00:00:00 ps
ubuntu@ip-172-31-30-89:~$
```