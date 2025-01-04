#!/bin/bash

# Функция помощи
function show_help() {
    echo -e "\nИспользование: $0 <prefix> <start> <end>"
    echo
    echo "Создает директории с именами, основанными на префиксе, и файлы внутри этих директорий."
    echo "Директории будут иметь формат <prefix>.<номер>, а файлы будут называться description_<prefix>_<номер>.md."
    echo
    echo "Параметры:"
    echo "  <prefix>  Префикс для названия директории (например, Task_1)"
    echo "  <start>   Начальный номер диапазона (например, 1)"
    echo "  <end>     Конечный номер диапазона (например, 10)"
    echo
    echo "Пример:"
    echo "  $0 Task_1 1 10"
    echo "  Этот пример создаст директории Task_1.1, Task_1.2, ..., Task_1.10 и файлы внутри них."
    echo
    exit 1
}

# Проверка на количество аргументов
if [ $# -ne 3 ]; then
    show_help
fi

prefix=$1     # Префикс для директорий (например, Task_1)
start=$2      # Начало диапазона
end=$3        # Конец диапазона

# Процесс создания директорий и файлов
for i in $(seq $start $end); do
    task_dir="${prefix}.${i}"
    file_name="description_${prefix}_${i}.md"
    
    # Создаем директорию
    mkdir -p "$task_dir"
    
    # Создаем файл в этой директории
    touch "$task_dir/$file_name"
    
    echo "Создано: $task_dir/$file_name"
done

echo "Все директории и файлы успешно созданы!"
