#!/bin/bash
LOGS_PATH= "/var/log/"
OUTPUT_FILE="$LOGS_PATH/uptime.log"
OVERLOAD_FILE="$LOGS_PATH/overload.log"
CLEANUP_FILE="$LOGS_PATH/cleanup.log"

# Проверка наличия файлов и создание их, если они не существуют
if [ ! -f "$OUTPUT_FILE" ]; then
  touch "$OUTPUT_FILE"
fi
if [ ! -f "$OVERLOAD_FILE" ]; then
  touch "$OVERLOAD_FILE"
fi
if [ ! -f "$CLEANUP_FILE" ]; then
  touch "$CLEANUP_FILE"
fi

while true; do

    # получение размера файла в байтах и если он больше 50кб, то очистить файл
  if [ $(stat -c%s "$OVERLOAD_FILE") -ge 51200 ]; then
      echo "$(date): Cleaning up overload file" >> "$CLEANUP_FILE"
      > "$OVERLOAD_FILE"
  fi
  
  UPTIME_OUTPUT=$(uptime)
  LOAD_AVERAGE=$(echo $UPTIME_OUTPUT | awk -F'load average: ' '{print $2}' | cut -d, -f1)

  # Если Load Average за минуту больше 1
  if awk "BEGIN {exit !($LOAD_AVERAGE > 1)}"; then
    echo "$UPTIME_OUTPUT" >> "$OVERLOAD_FILE"
  else
    echo "$UPTIME_OUTPUT" >> "$OUTPUT_FILE"
  fi

  sleep 15
done


