### Чекпоинты

[1) Объедини ветку develop с веткой master/main  из предыдущего задания.](#Point-1)  
[2) Клонируй репозиторий и смерджи ветку feature в ветку develop.](#Point-2)  
[3) Смерджи ветку develop в ветку master/main.](#Point-3)  
[4) Создай новый репозиторий на GitLab и загрузи изменения.](#Point-4)

---

1. #### Point 1  
#### Объедини ветку develop с веткой master/main из предыдущего задания.  
   **Задача:**  
   1. Объединим ветку `develop` с веткой `main`, используя команду `git merge develop`:  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git branch
* develop
  feature-new-site
  main
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git checkout main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git merge develop
Updating 315279d..f037508
Fast-forward
 nginx.conf | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ 
```  
   2. Разреши возможные конфликты и запушь изменения в удаленный репозиторий.
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$ git push origin
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
To https://bitbucket.org/yaraslau-alenchyk/devops-tasks.git
   315279d..f037508  main -> main
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/yaraslav/devops-tasks.git
   315279d..f037508  main -> main
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
To https://devops-gitlab.inno.ws/learn-labs/devops-tasks.git
   315279d..f037508  main -> main
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/devops-tasks$
```
---

2. #### Point 2  
#### Клонируй репозиторий и смерджи ветку feature в ветку develop.  
   **Задача:**  
   1. Клонируем репозиторий `https://devops-gitlab.inno.ws/ilya.sergienko1/git-merge` с помощью команды `git clone https://devops-gitlab.inno.ws/ilya.sergienko1/git-merge` и настроим отслеживание всех веток (создав локальные например `git checkout -b development origin/development`):  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ git clone https://devops-gitlab.inno.ws/ilya.sergienko1/git-merge.git
Cloning into 'git-merge'...
remote: Enumerating objects: 15, done.
remote: Counting objects: 100% (15/15), done.
remote: Compressing objects: 100% (14/14), done.
remote: Total 15 (delta 5), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (15/15), done.
Resolving deltas: 100% (5/5), done.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git branch
* master
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git branch --list
* master
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git remote show origin
* remote origin
  Fetch URL: https://devops-gitlab.inno.ws/ilya.sergienko1/git-merge.git
  Push  URL: https://devops-gitlab.inno.ws/ilya.sergienko1/git-merge.git
  HEAD branch: master
  Remote branches:
    development tracked
    feature     tracked
    master      tracked
  Local branch configured for 'git pull':
    master merges with remote master
  Local ref configured for 'git push':
    master pushes to master (up to date)
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git branch -r
  origin/HEAD -> origin/master
  origin/development
  origin/feature
  origin/master
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git checkout -b development origin/development
branch 'development' set up to track 'origin/development'.
Switched to a new branch 'development'
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git checkout -b feature origin/feature
branch 'feature' set up to track 'origin/feature'.
Switched to a new branch 'feature'
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ 
```  
   2. Перейдeм в репозиторий и смерджим ветку `feature` в ветку `develop`. Разрешим конфликты, выбирая последнее по времени изменение в обеих ветках, проверяя их с помощью `git log`.
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git checkout development
Switched to branch 'development'
Your branch is up to date with 'origin/development'.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git branch
* development
  feature
  master
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git merge feature
Auto-merging main.go
CONFLICT (content): Merge conflict in main.go
Automatic merge failed; fix conflicts and then commit the result.
```
Разрешим конфликты, выбирая последнее по времени изменение в обеих ветках, проверяя их с помощью `git log`:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git log feature 
commit a05e034704248f01971f6edb141e1245661d95c1 (origin/feature, feature)
Author: ilya.serhiyenka <ilya.sergienko1@innowise.com>
Date:   Tue May 7 13:10:18 2024 +0200

    refactor

commit 7c5ed06d8f5e4dc934c4ced98c9f31b8de463572
Author: ilya.serhiyenka <ilya.sergienko1@innowise.com>
Date:   Tue May 7 12:45:10 2024 +0200

    aaa

commit e7dd7effa91db01d2fed52241dabd70a5c52abe4 (origin/master, origin/HEAD, master)
Author: ilya.serhiyenka <ilya.sergienko1@innowise.com>
Date:   Tue May 7 12:43:29 2024 +0200

    readme added;

commit 7e91ab641980de80397287f8cd9dcbf8fb1dc893
Author: ilya.serhiyenka <ilya.sergienko1@innowise.com>
Date:   Tue May 7 12:42:07 2024 +0200

    initial
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git log 
commit 299eb633f9e721b3d8870dedcc55d8122d284f3e (HEAD -> development, origin/development)
Author: ilya.serhiyenka <ilya.sergienko1@innowise.com>
Date:   Tue May 7 13:07:07 2024 +0200

    simplified sum func

commit 7c5ed06d8f5e4dc934c4ced98c9f31b8de463572
Author: ilya.serhiyenka <ilya.sergienko1@innowise.com>
Date:   Tue May 7 12:45:10 2024 +0200

    aaa

commit e7dd7effa91db01d2fed52241dabd70a5c52abe4 (origin/master, origin/HEAD, master)
Author: ilya.serhiyenka <ilya.sergienko1@innowise.com>
Date:   Tue May 7 12:43:29 2024 +0200

    readme added;

commit 7e91ab641980de80397287f8cd9dcbf8fb1dc893
Author: ilya.serhiyenka <ilya.sergienko1@innowise.com>
Date:   Tue May 7 12:42:07 2024 +0200

    initial
```
Последний по времени коммит был в ветке `feature`, правим "конфликтный" файл `main.go`:
```bash 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ nano main.go
   func sum(a, b int) int {
<<<<<<< HEAD
        return a + b
=======
        t := b + a
        return t
>>>>>>> feature
}
```
и коммитим эти изменения (те что из ветки feature):
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git add main.go
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git commit                       
[development a8798b1] Merge branch 'feature' into development
```

---

3. #### Point 3  
#### Смерджи ветку develop в ветку master.  
   **Задача:**  
   1. Смерджи ветку `develop` в ветку `master`.  
      - При разрешении конфликта выбери последнее по времени изменение в ветках `develop` и `master`.  
      - Исключи из сравнения только что сделанный merge коммит, который появился в ветке `develop` после выполнения шага 2.  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git checkout master
Switched to branch 'master'
Your branch is up to date with 'origin/master'.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git branch
  development
  feature
* master
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git merge development
Updating e7dd7ef..a8798b1
Fast-forward
 main.go | 66 +++++++++++++++++++++++++++++++++---------------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)
```
Конфликтов при мерже веток не произошло.

```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git merge development
Updating e7dd7ef..a8798b1
Fast-forward
 main.go | 66 +++++++++++++++++++++++++++++++++---------------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)
```
---

4. #### Point 4  
#### Создай новый репозиторий на GitLab и загрузи изменения.  
   **Задача:**  
   1. Создадим новый репозиторий с именем `devops-task-merge` в своем аккаунте на GitLab. 
    Сделаем это через `cli` - для этого установим утилиту `glab` через `sudo apt install glab`.
    Далее авторизируемся используя ранее полученный токен (см. Task 2.1)
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ glab auth login
? What GitLab instance do you want to log into? GitLab Self-hosted Instance
? GitLab hostname: devops-gitlab.inno.ws
? API hostname: devops-gitlab.inno.ws
- Logging into devops-gitlab.inno.ws
? How would you like to login? Token
Tip: you can generate a Personal Access Token here https://devops-gitlab.inno.ws/-/profile/personal_access_tokens?scopes=api,write_repository
The minimum required scopes are 'api' and 'write_repository'.
? Paste your authentication token: ********************
? Choose default git protocol HTTPS
? Authenticate Git with your GitLab credentials? Yes
? Choose host API protocol HTTPS
- glab config set -h devops-gitlab.inno.ws git_protocol https
✓ Configured git protocol
- glab config set -h devops-gitlab.inno.ws api_protocol https
✓ Configured API protocol
✓ Logged in as yaraslau.alenchyk
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ 
```
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ glab auth status
devops-gitlab.inno.ws
  ✓ Logged in to devops-gitlab.inno.ws as yaraslau.alenchyk (/home/yarik/.config/glab-cli/config.yml)
  ✓ Git operations for devops-gitlab.inno.ws configured to use https protocol.
  ✓ API calls for devops-gitlab.inno.ws are made over https protocol
  ✓ REST API Endpoint: https://devops-gitlab.inno.ws/api/v4/
  ✓ GraphQL Endpoint: https://devops-gitlab.inno.ws/api/graphql/
  ✓ Token: **************************
```
Проверим доступ в аккаунт и посмотрим список репозиториев:
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ glab repo list
Showing 1 of 1 projects (Page 1 of 1)

learn-labs/devops-tasks  ssh://git@devops-gitlab.inno.ws:54042/learn-labs/devops-tasks.git
```
Чтобы создать новый проект-репозиторий с именем `devops-task-merge` в ранее созданной группе `learn-labs`выполним команду `glab repo create devops-task-merge --group learn-labs --internal --description "This is the devops-task-merge repository"`: 
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ glab repo create devops-task-merge --group learn-labs --int
ernal --description "This is the devops-task-merge repository"
✓ Created repository LearnLabs  / devops-task-merge on GitLab: https://devops-gitlab.inno.ws/learn-labs/devops-task-merge
? Create a local project directory for LearnLabs  / devops-task-merge? No
```
Локальный репозиторий не создаем т.к. у нас уже он есть, нужно только изменить `origin` для него. 
Проверяем созданный удаленный репозиторий и изменяем `remote origin` для локального:
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ glab repo list
Showing 2 of 2 projects (Page 1 of 1)

learn-labs/devops-task-merge  ssh://git@devops-gitlab.inno.ws:54042/learn-labs/dev...  This is the devops-task-merge repository
learn-labs/devops-tasks       ssh://git@devops-gitlab.inno.ws:54042/learn-labs/dev...                                          

(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git remote -v
origin      https://devops-gitlab.inno.ws/ilya.sergienko1/git-merge.git (fetch)
origin      https://devops-gitlab.inno.ws/ilya.sergienko1/git-merge.git (push)
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git remote remove old-origin 
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git remote rename origin old-origin
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git remote add origin https://devops-gitlab.inno.ws/learn-labs/devops-task-merge.git
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git remote -v
old-origin      https://devops-gitlab.inno.ws/ilya.sergienko1/git-merge.git (fetch)
old-origin      https://devops-gitlab.inno.ws/ilya.sergienko1/git-merge.git (push)
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-merge.git (fetch)
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-merge.git (push)
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git remote remove old-origin 
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git remote -v
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-merge.git (fetch)
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-merge.git (push)
```

   2. Загрузим все изменения, сделанные в репозиториях, в этот новый репозиторий с помощью команды `git push -u origin --all`:  
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ 
Enumerating objects: 16, done.
Counting objects: 100% (16/16), done.
Delta compression using up to 8 threads
Compressing objects: 100% (10/10), done.
Writing objects: 100% (16/16), 2.05 KiB | 701.00 KiB/s, done.
Total 16 (delta 5), reused 15 (delta 5), pack-reused 0
remote: 
remote: To create a merge request for development, visit:
remote:   https://devops-gitlab.inno.ws/learn-labs/devops-task-merge/-/merge_requests/new?merge_request%5Bsource_branch%5D=development
remote: 
remote: 
remote: To create a merge request for feature, visit:
remote:   https://devops-gitlab.inno.ws/learn-labs/devops-task-merge/-/merge_requests/new?merge_request%5Bsource_branch%5D=feature
remote: 
To https://devops-gitlab.inno.ws/learn-labs/devops-task-merge.git
 * [new branch]      development -> development
 * [new branch]      feature -> feature
 * [new branch]      master -> master
branch 'development' set up to track 'origin/development'.
branch 'feature' set up to track 'origin/feature'.
branch 'master' set up to track 'origin/master'.
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git push -u origin --tags
Everything up-to-date
```  
