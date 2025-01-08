### Чекпоинты:

[1) Установить консольный git-клиент. Настроить git-клиент, указав параметры user.name и user.email, соответствующие вашим данным. Создать репозиторий devops-task1 с помощью git init. Создать файл nginx.conf, содержащий конфигурацию nginx (базовую, которая появляется после установки пакета в linux /etc/nginx/nginx.conf). ](#Point-1)  
[2) Создать файл README.md с описанием того, что находится в репозитории (пример: "В данном репозитории находится дефолтный конфигурационный файл nginx"). Добавить файл README.md в репозиторий с помощью команды git commit. Добавить файл nginx.conf в репозиторий с помощью команды git commit. ](#Point-2)  
[3) С помощью команды git log проверить, отображаются ли в истории два коммита. С помощью команды git status проверить, что в данной папке не осталось больше файлов/папок, которые не добавлены в репозиторий.](#Point-3)  
[4) Зарегистрироваться в двух публичных хостингах git-репозиториев bitbucket и github. Доступ к devops-gitlab.inno.ws ты должен был получить в начале курса. Если возникли какие-то проблемы с доступом, свяжись с ментором.](#Point-4)   
[5) Создать на каждом из хостингов репозиторий devops-task1; bitbucket и github - публичные (public) репозитории, devops-gitlab.inno.ws - внутренний (internal). В репозиторий, созданный в первом задании, добавить 3 удаленных сервера с помощью git remote add. Загрузить репозиторий во все git-хостинги с помощью git push.](#Point-5)  
[6) Клонировать репозиторий. Переключиться на 3-й от начала коммит (e8b3ec06b). Просмотреть содержимое файла deleted.txt. Проверить, что все созданные репозитории публичные, кроме репозитория на devops-gitlab.inno.ws ](#Point-6)  

1. #### Point 1  
#### Установить консольный git-клиент. Настроить git-клиент, указав параметры user.name и user.email, соответствующие вашим данным. Создать репозиторий devops-task1 с помощью git init. Создать файл nginx.conf, содержащий конфигурацию nginx (базовую, которая появляется после установки пакета в linux /etc/nginx/nginx.conf).  

Репозиторий devops-tasks

2. #### Point 2  
 #### Создать файл README.md с описанием того, что находится в репозитории (пример: "В данном репозитории находится дефолтный конфигурационный файл nginx"). Добавить файл README.md в репозиторий с помощью команды git commit. Добавить файл nginx.conf в репозиторий с помощью команды git commit.

Done

3. #### Point 3  
 ####   С помощью команды git log проверить, отображаются ли в истории два коммита. С помощью команды git status проверить, что в данной папке не осталось больше файлов/папок, которые не добавлены в репозиторий.
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git log
commit 68ea5ccc62572b8ea7bbd41ebcf166643a44c8db (HEAD -> main, origin/main)
Author: Yaroslav Alenchyk <4wdpmmg3f2vq9iuxqzp63qdwnencsv@bots.bitbucket.org>
Date:   Mon Dec 30 21:09:10 2024 +0100

    second commit

commit 72df8dde3da6fb703b6baa21d45caa04f3d88815
Author: Yaroslav Alenchyk <alenchyk.yaroslav@gmail.com>
Date:   Mon Dec 30 15:48:55 2024 +0100

    This first commit. Create ngnix.conf and project README file
```
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git status 
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

4. #### Point 4  
 #### Зарегистрироваться в двух публичных хостингах git-репозиториев bitbucket и github. Доступ к devops-gitlab.inno.ws ты должен был получить в начале курса. Если возникли какие-то проблемы с доступом, свяжись с ментором.

github - done  https://bitbucket.org/yaraslau-alenchyk/devops-tasks.git
bitbucket - done https://github.com/yaraslav/devops-tasks.git
gitlab - done  https://devops-gitlab.inno.ws/learn-labs/devops-tasks.git
    
5. #### Point 5  
 #### Создать на каждом из хостингов репозиторий devops-task1; bitbucket и github - публичные (public) репозитории, devops-gitlab.inno.ws - внутренний (internal). В репозиторий, созданный в первом задании, добавить 3 удаленных сервера с помощью git remote add. Загрузить репозиторий во все git-хостинги с помощью git push.


```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git push 
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 8 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 680 bytes | 52.00 KiB/s, done.
Total 4 (delta 0), reused 0 (delta 0), pack-reused 0
To https://bitbucket.org/yaraslau-alenchyk/devops-tasks.git
   f4af5a6..315279d  main -> main
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 8 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 680 bytes | 45.00 KiB/s, done.
Total 4 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/yaraslav/devops-tasks.git
   f4af5a6..315279d  main -> main
Enumerating objects: 14, done.
Counting objects: 100% (14/14), done.
Delta compression using up to 8 threads
Compressing objects: 100% (11/11), done.
Writing objects: 100% (14/14), 1.61 KiB | 40.00 KiB/s, done.
Total 14 (delta 0), reused 0 (delta 0), pack-reused 0
To https://devops-gitlab.inno.ws/learn-labs/devops-tasks.git
 * [new branch]      main -> main
```

6. #### Point 6  
 ####  Клонировать репозиторий https://devops-gitlab.inno.ws/devops-board/git-checkout. Переключиться на 3-й от начала коммит (e8b3ec06b). Просмотреть содержимое файла deleted.txt. Проверить, что все созданные репозитории публичные, кроме репозитория на devops-gitlab.inno.ws
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ git clone https://devops-gitlab.inno.ws/devops-board/git-checkout.git
Cloning into 'git-checkout'...
remote: Enumerating objects: 21, done.
remote: Counting objects: 100% (21/21), done.
remote: Compressing objects: 100% (18/18), done.
remote: Total 21 (delta 4), reused 1 (delta 0), pack-reused 0
Receiving objects: 100% (21/21), done.
Resolving deltas: 100% (4/4), done.
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ cd git-checkout/
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-checkout$ ls
README.md  curl.txt  mirror.txt  tg.txt
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-checkout$ git checkout e8b3ec06b
Note: switching to 'e8b3ec06b'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at e8b3ec0 Removed info about cashbox
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-checkout$ ls
README.md  curl.txt  deleted.txt
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-checkout$ cat deleted.txt 
969507679bbd60f2429968ce06036a5b
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-checkout$
```