### Чекпоинты

[1) Создай две новые ветки и измени nginx.conf в ветке develop.](#point-1)  
[2) Добавь изменения в ветке feature/new-site. Добавить файл .gitignore и проверить изменения.](#point-2)  
[3) Добавь легковесный тег `v0.1` на последний коммит в ветке `develop`.](#point-3)  
[4) Загрузи изменения на GitLab.](#point-4)  
[5) Загрузи тег на хостинг и проверь его наличие.](#point-5)  
[6) Проверь присутствие директории tmp в ветке feature/new-site.](#point-6)

---

1. #### Point 1  
#### Создай две новые ветки и измени nginx.conf в ветке develop.  
   **Задача:**  
   1. В репозитории `devops-task1` создадим две новые ветки:  
      - `develop`;  
      - `feature/new-site`;  
Создадим их командой `for i in "develop" "feature-new-site"; do git branch "$i"; done`
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ for i in "develop" "feature-new-site"; do git branch "$i"; done 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git branch --list
  develop
  feature-new-site
* main
```
если находимся в ветке `main`, или с указанием начальной точки (другой исходной ветки), например так - `for i in "dev" "feature-new-site"; do git branch "$i" main; done`

   2. Перейдем в ветку `develop` с помощью команды `git checkout develop`:  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git checkout develop
Switched to branch 'develop'
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git branch
* develop
  feature-new-site
  main
```  
   3. В ветке `develop` изменим настройки в `nginx.conf` и закоммитим изменения.
```bash
cat << EOF > nginx.conf
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    tcp_nopush     on;

    keepalive_timeout  65;

    gzip  on;

    server {
        listen 80;

        location = / {
            add_header Content-Type text/plain always;
            return 200 'Welcome to the training program Innowise: Docker! Again!\n';
        }
    }
}
EOF
```
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git add .
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git commit -m 'add new config'
[develop c6d126d] add new config
 1 file changed, 34 insertions(+), 5 deletions(-)
```
   
   4. В ветке `develop` изменим `nginx.conf`, включив сжатие ответа для типа `application/json` и замени `worker_connections на 16384` и закоммить изменения.
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git add .
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git commit -m 'add some changes to config'
[develop f037508] add some changes to config
 1 file changed, 2 insertions(+), 2 deletions(-)
```
---

2. #### Point 2  
#### Добавь изменения в ветке feature/new-site добавив файл conf.d/mysite.domain.com.conf с базовым описанием статического сайта и закоммить изменения. Добавить файл .gitignore и проверить изменения.  
   **Задача:**  
   1. В ветке `feature/new-site` добавь файл `conf.d/mysite.domain.com.conf` с базовым описанием статического сайта и закоммить изменения.
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git checkout feature-new-site
Switched to branch 'feature-new-site'
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git branch
  develop
* feature-new-site
  main
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ mkdir -p conf.d
cat << EOF > conf.d/mysite.domain.com.conf
server {
    listen 80;
    server_name mysite.domain.com;

    root /var/www/mysite.domain.com;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    error_log /var/log/nginx/mysite.error.log;
    access_log /var/log/nginx/mysite.access.log;
}
EOF
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ cat conf.d/mysite.domain.com.conf
server {
    listen 80;
    server_name mysite.domain.com;

    root /var/www/mysite.domain.com;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    error_log /var/log/nginx/mysite.error.log;
    access_log /var/log/nginx/mysite.access.log;
}
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ 
```
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git add . 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git commit -m "add new site's config"
[feature-new-site 4dd8cd3] add new site's config
 1 file changed, 14 insertions(+)
 create mode 100644 conf.d/mysite.domain.com.conf
```
   2. Добавить файл `.gitignore`, который исключает из репозитория папку `tmp` и все ее содержимое.  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ cat << EOF > .gitignore
tmp/  
EOF
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git add .gitignore 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git commit -m "add .gitignore config"
[feature-new-site 5206ff7] add .gitignore config
 1 file changed, 1 insertion(+)
 create mode 100644 .gitignore
```
   3. Создай локально папку `tmp` с несколькими файлами в ней, используя команды:  
```bash
mkdir tmp
touch tmp/file1 tmp/file2
```
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ mkdir tmp
touch tmp/file1 tmp/file2
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ ls
README.md  conf.d  nginx.conf  tmp
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ ls tmp/
file1  file2
```
   4. Закоммить изменения, включая файл `.gitignore` и папку `tmp`.
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git add . 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git commit -m "add all changes"
[feature-new-site c869cd6] add all changes
 3 files changed, 1 insertion(+), 1 deletion(-)
 delete mode 100644 tmp/file1
 delete mode 100644 tmp/file2
```
---

3. #### Point 3  
#### Добавь легковесный тег `v0.1` на последний коммит в ветке `develop` (где изменялся `nginx.conf`). 
   **Задача:**  
    Вернемся в ветку `develop` и добавим  тег используя команду `git tag v0.1`:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git checkout develop
Switched to branch 'develop'
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git tag v0.1
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git tag 
v0.1
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git show v0.1
commit f03750886e56ce71adbea0e937d4c7042f95f07c (HEAD -> develop, tag: v0.1)
Author: Yaroslav Alenchyk <jxz2e3r4b7ihpo37dmrl2aptsxlfux@bots.bitbucket.org>
Date:   Mon Jan 13 14:35:50 2025 +0100

    add some changes to config

diff --git a/nginx.conf b/nginx.conf
index d7ec8d0..6a8bf2f 100644
--- a/nginx.conf
+++ b/nginx.conf
@@ -5,12 +5,12 @@ error_log  /var/log/nginx/error.log warn;
 pid        /var/run/nginx.pid;
 
 events {
-    worker_connections  1024;
+    worker_connections  16384;
 }
 
 http {
     include       /etc/nginx/mime.types;
-    default_type  application/octet-stream;
+    default_type  application/json;
 
     log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                       '$status $body_bytes_sent "$http_referer" '
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ 
```
---
4. #### Point 4  
#### Загрузи изменения на GitLab.  
   **Задача:**  
   1. Загрузим обе ветки (`develop` и `feature/new-site`) на удаленные репозитории (GitLab/Github/Bitbacket) с помощью команд:  
```bash
git push origin develop
git push origin feature-new-site
```  
<details>
<summary><b>Вывод лога загрузки в уделенный репозиторий</b></summary>

```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git push origin develop
git push origin feature/new-site
Enumerating objects: 8, done.
Counting objects: 100% (8/8), done.
Delta compression using up to 8 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (6/6), 1.04 KiB | 48.00 KiB/s, done.
Total 6 (delta 1), reused 0 (delta 0), pack-reused 0
remote: 
remote: Create pull request for develop:
remote:   https://bitbucket.org/yaraslau-alenchyk/devops-tasks/pull-requests/new?source=develop&t=1
remote: 
To https://bitbucket.org/yaraslau-alenchyk/devops-tasks.git
 * [new branch]      develop -> develop
Enumerating objects: 8, done.
Counting objects: 100% (8/8), done.
Delta compression using up to 8 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (6/6), 1.04 KiB | 55.00 KiB/s, done.
Total 6 (delta 1), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (1/1), done.
remote: 
remote: Create a pull request for 'develop' on GitHub by visiting:
remote:      https://github.com/yaraslav/devops-tasks/pull/new/develop
remote: 
To https://github.com/yaraslav/devops-tasks.git
 * [new branch]      develop -> develop
Enumerating objects: 8, done.
Counting objects: 100% (8/8), done.
Delta compression using up to 8 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (6/6), 1.04 KiB | 66.00 KiB/s, done.
Total 6 (delta 1), reused 0 (delta 0), pack-reused 0
remote: 
remote: To create a merge request for develop, visit:
remote:   https://devops-gitlab.inno.ws/learn-labs/devops-tasks/-/merge_requests/new?merge_request%5Bsource_branch%5D=develop
remote: 
To https://devops-gitlab.inno.ws/learn-labs/devops-tasks.git
 * [new branch]      develop -> develop
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git push origin feature-new-site
Enumerating objects: 15, done.
Counting objects: 100% (15/15), done.
Delta compression using up to 8 threads
Compressing objects: 100% (11/11), done.
Writing objects: 100% (14/14), 1.41 KiB | 40.00 KiB/s, done.
Total 14 (delta 2), reused 0 (delta 0), pack-reused 0
remote: 
remote: Create pull request for feature-new-site:
remote:   https://bitbucket.org/yaraslau-alenchyk/devops-tasks/pull-requests/new?source=feature-new-site&t=1
remote: 
To https://bitbucket.org/yaraslau-alenchyk/devops-tasks.git
 * [new branch]      feature-new-site -> feature-new-site
Enumerating objects: 15, done.
Counting objects: 100% (15/15), done.
Delta compression using up to 8 threads
Compressing objects: 100% (11/11), done.
Writing objects: 100% (14/14), 1.41 KiB | 46.00 KiB/s, done.
Total 14 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), done.
remote: 
remote: Create a pull request for 'feature-new-site' on GitHub by visiting:
remote:      https://github.com/yaraslav/devops-tasks/pull/new/feature-new-site
remote: 
To https://github.com/yaraslav/devops-tasks.git
 * [new branch]      feature-new-site -> feature-new-site
Enumerating objects: 15, done.
Counting objects: 100% (15/15), done.
Delta compression using up to 8 threads
Compressing objects: 100% (11/11), done.
Writing objects: 100% (14/14), 1.41 KiB | 42.00 KiB/s, done.
Total 14 (delta 2), reused 0 (delta 0), pack-reused 0
remote: 
remote: To create a merge request for feature-new-site, visit:
remote:   https://devops-gitlab.inno.ws/learn-labs/devops-tasks/-/merge_requests/new?merge_request%5Bsource_branch%5D=feature-new-site
remote: 
To https://devops-gitlab.inno.ws/learn-labs/devops-tasks.git
 * [new branch]      feature-new-site -> feature-new-site
```
</details><br>
---

5. #### Point 5  
#### Загрузи тег на хостинг и проверь его наличие.  
   **Задача:**  
   1. Загрузи тег `v0.1` на хостинг `https://devops-gitlab.inno.ws` с помощью команды  `git push origin v0.1`:  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git push origin v0.1
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
To https://bitbucket.org/yaraslau-alenchyk/devops-tasks.git
 * [new tag]         v0.1 -> v0.1
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/yaraslav/devops-tasks.git
 * [new tag]         v0.1 -> v0.1
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
To https://devops-gitlab.inno.ws/learn-labs/devops-tasks.git
 * [new tag]         v0.1 -> v0.1
```  
   2. Проверь наличие тега в репозитории на GitLab.
   Тег присутствует в удаленных репозиториях.
---

6. #### Point 6  
#### Проверь присутствие директории tmp в ветке feature/new-site.  
   **Задача:**  
   1. Проверь, присутствует ли директория `tmp` в ветке `feature/new-site`.  
   Директория отсутствует в удаленном репозитории.
