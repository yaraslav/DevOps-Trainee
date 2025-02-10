#### Чекпоинты:

[1) Склонировать репозиторий `fat_free_crm`.](#point-1)  
[2) Добавить в репозиторий файл `.dockerignore` с определенными правилами игнорирования.](#point-2)  

---



#### Point 1
- Склонировать репозиторий:
```bash
git clone https://github.com/fatfreecrm/fat_free_crm.git
cd fat_free_crm
```
#### Point 2
- Создать .gitinore который должен содержать:
    - директорию .git
    - все скрытые файлы (начинаются с .) с расширением yml
    - все yml-файлы в директории config, кроме settings.default.yml database.sqlite.yml database.postgres.docker.yml
    - все файлы во всех подпапках ./public/avatars/ с расширением gif

```ini
.git
**/*.yml
!config/settings.default.yml
!config/database.sqlite.yml
!config/database.postgres.docker.yml
public/avatars/**/*.gif

```

Созданый по этим требованиям файл можно получить здесь [.gitignore](.gitignore)