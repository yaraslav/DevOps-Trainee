#!/bin/bash

# Функция помощи
function show_help() {
    echo -e "\nИспользование: $0 <parent_prefix> <child_prefix> <start> <end>"
    echo
    echo "Создает директории с именами, основанными на префиксе, и файлы внутри этих директорий."
    echo "Директории будут иметь формат <prefix>.<номер>, а файлы будут называться description_<prefix>_<номер>.md."
    echo
    echo "Параметры:"
    echo "  <parent_prefix>  Префикс для названия директории (например, Tasks)"
    echo "  <child_prefix>  Префикс для названия директории (например, Task_1)"
    echo "  <start>   Начальный номер диапазона (например, 1)"
    echo "  <end>     Конечный номер диапазона (например, 10)"
    echo
    echo "Пример:"
    echo "  $0 Tasks Task_1 1 10"
    echo "  Этот пример создаст директории Task_1.1, Task_1.2, ..., Task_1.10 и файлы внутри них."
    echo
    exit 1
}

# Проверка на количество аргументов
if [ $# -ne 4 ]; then
    show_help
fi

parent_prefix=$1     # Префикс для  родительской директории(например, Tasks)
child_prefix=$2      # Префикс для директорий (например, Task_1)
start=$3      	     # Начало диапазона
end=$4               # Конец диапазона

# Процесс создания директорий и файлов
for i in $(seq $start $end); do
    child_dir="${parent_prefix}/${child_prefix}.${i}"
    file_name="description_${child_prefix}_${i}.md"
    
    # Создаем директорию
    mkdir -p "$child_dir"
    
    # Создаем файл в этой директории
    touch "$child_dir/$file_name"
    
    echo "Создано: $child_dir/$file_name"
done

echo "Все директории и файлы успешно созданы!"
