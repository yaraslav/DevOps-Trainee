### Чекпоинты

[1) Создайте пустой репозиторий и добавьте в него WordPress как сабмодуль.](#Point-1)  
[2) Верните сабмодуль к состоянию с тегом 3.4.2 и зафиксируйте изменения.](#Point-2)    
[3) Скопируйте необходимые файлы из сабмодуля, очистите ненужные и настройте взаимодействие с сабмодулем. Зафиксируйте все изменения и запушьте репозиторий на devops-gitlab.inno.ws.](#Point-3)  

---

1. #### Point 1  
#### Создайте пустой репозиторий и добавьте в него WordPress как сабмодуль.  
   **Задача:**  
   1. Создадим и инициализируем новый Git-репозиторий:  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ mkdir git-submodule && cd git-submodule
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git init
Initialized empty Git repository in /mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule/.git/
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git status
On branch main

No commits yet

nothing to commit (create/copy files and use "git add" to track)
``` 
   2. Добавьте репозиторий WordPress как сабмодуль с именем `wordpress` командой `git submodule add https://github.com/WordPress/WordPress.git wordpress`:  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git submodule add https://github.com/WordPress/WordPress.git wordpress
Cloning into '/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule/wordpress'...
remote: Enumerating objects: 424112, done.
remote: Counting objects: 100% (67/67), done.
remote: Compressing objects: 100% (52/52), done.
remote: Total 424112 (delta 35), reused 15 (delta 15), pack-reused 424045 (from 2)
Receiving objects: 100% (424112/424112), 517.04 MiB | 19.94 MiB/s, done.
Resolving deltas: 100% (341274/341274), done.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ 
```  

   3. Инициализируйте и обновите сабмодуль:  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git submodule update --init --recursive
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ 
```  
   4. Проверьте статус сабмодуля:  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git submodule status
a79b4ef4c92a012cbb6ddeb925779d9d7bd84dcd wordpress (heads/master)
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ 
```

---

2. #### Point 2  
#### Верните сабмодуль к состоянию с тегом 3.4.2 и зафиксируйте изменения.  
   **Задача:**  
   1. Перейдите в директорию сабмодуля. Получите все теги, найти и на тег `3.4.2`:  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule/ cd wordpress
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule/wordpress$ git fetch -a
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule/wordpress$ git tag | grep 3.4.2
3.4.2
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule/wordpress$ git checkout 3.4.2

Updating files: 100% (4785/4785), done.
Note: switching to '3.4.2'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at 6dde3d91f2 Tag 3.4.2
```
   2. Создадим удаленный репозиторий 'devops-gitlab.inno.ws/learn-labs/devops-task-submodules.git' через Web-интерфейс и добавим удаленный репозиторий.

   3. Вернитесь в корневую директорию основного репозитория. Зафиксируйте изменения в основном репозитории и запушить в удаленный: 
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule/wordpress$ cd ..
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git add wordpress
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git commit -m "Зафиксирована версия сабмодуля WordPress на теге 3.4.2"
[main (root-commit) ea1dba8] Зафиксирована версия сабмодуля WordPress на теге 3.4.2
2 files changed, 4 insertions(+)
create mode 100644 .gitmodules
create mode 160000 wordpress
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git push origin main
To https://devops-gitlab.inno.ws/learn-labs/devops-task-submodules.git
 ! [rejected]        main -> main (non-fast-forward)
error: failed to push some refs to 'https://devops-gitlab.inno.ws/learn-labs/devops-task-submodules.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. If you want to integrate the remote changes,
hint: use 'git pull' before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```
Получаем ошибку т.к. история коммитов разная. Устраним ошибку таким образом:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git config pull.rebase true
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git pull --rebase origin main
From https://devops-gitlab.inno.ws/learn-labs/devops-task-submodules
 * branch            main       -> FETCH_HEAD
warning: unable to rmdir 'wordpress': Directory not empty
Successfully rebased and updated refs/heads/main.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$
```
и запушим снова изменения:
```bash 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git push origin main
Enumerating objects: 4, done.
Counting objects: 100% (4/4), done.
Delta compression using up to 8 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 483 bytes | 37.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
remote: 
remote: ========================================================================
remote: 
remote:   Gitlab recovered on jan 18th date. Thank you for understanding, and
remote:      I really hope that this doesn't affect our friendship. Cheers.
remote: 
remote: ========================================================================
remote: 
To https://devops-gitlab.inno.ws/learn-labs/devops-task-submodules.git
   6274145..80f8e45  main -> main
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git log
commit 80f8e45e20c382e9d46ce873bf3040d836f38a40 (HEAD -> main, origin/main)
Author: Yaroslav Alenchyk (Innowise) <yaraslau.alenchyk@innowise.com>
Date:   Wed Jan 22 14:30:58 2025 +0100

    Зафиксирована версия сабмодуля WordPress на теге 3.4.2

commit 62741458e6ec673ad1e81a942c0e4e0e9187951a
Author: yaraslau.alenchyk@innowise.com <yaraslau.alenchyk@innowise.com>
Date:   Wed Jan 22 13:34:28 2025 +0000

    Initial commit
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$
```
---

3. #### Point 3  
#### Скопируйте необходимые файлы из сабмодуля, очистите ненужные и настройте взаимодействие с сабмодулем. Зафиксируйте все изменения и запушьте репозиторий на devops-gitlab.inno.ws.  
   **Задача:**  
   1. Скопируйте необходимые файлы из сабмодуля в основной репозиторий 
```bash
cp wordpress/index.php index.php
cp wordpress/wp-config-sample.php wp-config.php
cp -Rf wordpress/wp-content .
```  
и удалим ненужные файлы и директории:  
```bash
rm -Rf wp-content/plugins/hello.php wp-content/themes/twentyten
```  
   3. Затем отредактируем файл и изменим строку 17 в `index.php` на:  
```php
require('wordpress/wp-blog-header.php');
```

```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ cp wordpress/index.php index.php
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ cp wordpress/wp-config-sample.php wp-config.php
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ cp -Rf wordpress/wp-content .
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ ls 
FETCH_HEAD  README.md  index.php  wordpress  wp-config.php  wp-content
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ rm -Rf wp-content/plugins/hello.php wp-content/themes/twentyten 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ nano index.php 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ nano -l index.php
```
Сохраним изменения, закоммитим их и запушим в удаленный репозиторий:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git add . 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git commit -m "Create config and index files"
[main bb3987a] Create config and index files
 87 files changed, 8562 insertions(+)
 create mode 100644 index.php
 create mode 100644 wp-config.php
 create mode 100644 wp-content/index.php
.....
 create mode 100644 wp-content/themes/twentyeleven/style.css
 create mode 100644 wp-content/themes/twentyeleven/tag.

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git push --set-upstream origin main
Enumerating objects: 100, done.
Counting objects: 100% (100/100), done.
Delta compression using up to 8 threads
Compressing objects: 100% (93/93), done.
Writing objects: 100% (99/99), 687.52 KiB | 2.46 MiB/s, done.
Total 99 (delta 14), reused 0 (delta 0), pack-reused 0
remote: 
remote: ========================================================================
remote: 
remote:   Gitlab recovered on jan 18th date. Thank you for understanding, and
remote:      I really hope that this doesn't affect our friendship. Cheers.
remote: 
remote: ========================================================================
remote: 
To https://devops-gitlab.inno.ws/learn-labs/devops-task-submodules.git
   80f8e45..bb3987a  main -> main
branch 'main' set up to track 'origin/main'.
```
Отредактируем и удалим некоторые файлы, закоммитим и запушим изменения:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ rm FETCH_HEAD 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git add . 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git commit -m "Deketed some files"
[main f278973] Deketed some files
 1 file changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 FETCH_HEAD
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git push
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Delta compression using up to 8 threads
Compressing objects: 100% (2/2), done.
Writing objects: 100% (2/2), 252 bytes | 31.00 KiB/s, done.
Total 2 (delta 1), reused 0 (delta 0), pack-reused 0
remote: 
remote: ========================================================================
remote: 
remote:   Gitlab recovered on jan 18th date. Thank you for understanding, and
remote:      I really hope that this doesn't affect our friendship. Cheers.
remote: 
remote: ========================================================================
remote: 
To https://devops-gitlab.inno.ws/learn-labs/devops-task-submodules.git
   bb3987a..f278973  main -> main
```
UPD:  В комментарии к коммиту допустид ошибку ("Deketed" вместо "Deleted"), поэтому идем и правим последний коммит и пушим через 'push --'force' если ветка позволяет:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git commit --amend

[main c35064f] Deleted some files
 Date: Wed Jan 22 15:00:00 2025 +0100
 1 file changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 FETCH_HEAD'
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ git push --force
Enumerating objects: 3, done.
Counting objects: 100% (3/3), done.
Delta compression using up to 8 threads
Compressing objects: 100% (2/2), done.
Writing objects: 100% (2/2), 255 bytes | 36.00 KiB/s, done.
Total 2 (delta 1), reused 0 (delta 0), pack-reused 0
remote: 
remote: ========================================================================
remote: 
remote:   Gitlab recovered on jan 18th date. Thank you for understanding, and
remote:      I really hope that this doesn't affect our friendship. Cheers.
remote: 
remote: ========================================================================
remote: 
To https://devops-gitlab.inno.ws/learn-labs/devops-task-submodules.git
 + f278973...c35064f main -> main (forced update)
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-submodule$ 

```  
---