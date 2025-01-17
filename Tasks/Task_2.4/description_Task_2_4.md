### Чекпоинты

[1) Переместить коммиты между ветками с помощью rebase.](#Point-1)  
[2) Объединить FIX-коммиты с родительским в один.](#Point-2)  
[3) Перенести коммит "Formatted code" в ветку master.](#Point-3)

---

1. #### Point 1  
#### Переместить коммиты между ветками с помощью rebase.  
   **Задача:**  
   1. Клонируй репозиторий `git-rebase``.

```bash
git clone https://devops-gitlab.inno.ws/devops-board/git-rebase.git
```
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ git clone  https://devops-gitlab.inno.ws/devops-board/git-rebase.git && cd git-rebase
Cloning into 'git-rebase'...
remote: Enumerating objects: 18, done.
remote: Counting objects: 100% (18/18), done.
remote: Compressing objects: 100% (17/17), done.
remote: Total 18 (delta 6), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (18/18), done.
Resolving deltas: 100% (6/6), done.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git branch -r
  origin/HEAD -> origin/master
  origin/develop
  origin/feature
  origin/master
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git branch
* master
```  

   2. Перемести коммиты из ветки `feature` в ветку `develop`. Для это выполним по очереди команды:  
```bash
git checkout -b feature origin/feature
git checkout -b develop origin/develop
git rebase feature
```
<details>
<summary><b>вывод результата выполнения команд</b></summary>

```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git checkout -b feature origin/feature
branch 'feature' set up to track 'origin/feature'.
Switched to a new branch 'feature'
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git branch
* feature
  master
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git log
commit 27366c81eef3edcd7fa6c123a30c4b966fb687cf (HEAD -> feature, origin/feature)
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:46:38 2019 +0300

    Added unit tests for server in feature branch

commit 61447bcc7de9443536578065f7337cb3aadc958a
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:58 2019 +0300

    Formatted go code

commit ddd4c0fd181ad4ce170c2db6fcb13675f4e5bcac
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:16 2019 +0300

    Added main server file

commit 14dd2901737b121a2292f42dd5ff88734ddfd279
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:03 2019 +0300

    Initial commit
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git checkout -b develop origin/develop
branch 'develop' set up to track 'origin/develop'.
Switched to a new branch 'develop'
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git branch
* develop
  feature
  master
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git log
commit 438ccf5206d99e6d8e7f47c13a75e3487987695f (HEAD -> develop, origin/develop)
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:45:24 2019 +0300

    Simplified sum function in develop branch

commit 61447bcc7de9443536578065f7337cb3aadc958a
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:58 2019 +0300

    Formatted go code

commit ddd4c0fd181ad4ce170c2db6fcb13675f4e5bcac
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:16 2019 +0300

    Added main server file

commit 14dd2901737b121a2292f42dd5ff88734ddfd279
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:03 2019 +0300

    Initial commit
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git rebase feature
Successfully rebased and updated refs/heads/develop.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git log
commit b6a7ec6d1a4498eb73c9a48845d1b22fef589a78 (HEAD -> develop)
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:45:24 2019 +0300

    Simplified sum function in develop branch

commit 27366c81eef3edcd7fa6c123a30c4b966fb687cf (origin/feature, feature)
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:46:38 2019 +0300

    Added unit tests for server in feature branch

commit 61447bcc7de9443536578065f7337cb3aadc958a
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:58 2019 +0300

    Formatted go code

commit ddd4c0fd181ad4ce170c2db6fcb13675f4e5bcac
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:16 2019 +0300

    Added main server file

commit 14dd2901737b121a2292f42dd5ff88734ddfd279
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:03 2019 +0300

    Initial commit
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ 
```  
</details><br>

   3. Перемести коммиты из ветки `develop` в ветку `master`. Аналогично п.2:  
```bash
git checkout master
git rebase develop
```  
<details>
<summary><b>вывод результата выполнения команд</b></summary>

```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git checkout master
Switched to branch 'master'
Your branch is up to date with 'origin/master'.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git log
commit a0b7a1fdad231cb5926f420d545db263fe229e31 (HEAD -> master, origin/master, origin/HEAD)
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:47:11 2019 +0300

    Changed listen port in master branch

commit 61447bcc7de9443536578065f7337cb3aadc958a
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:58 2019 +0300

    Formatted go code

commit ddd4c0fd181ad4ce170c2db6fcb13675f4e5bcac
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:16 2019 +0300

    Added main server file

commit 14dd2901737b121a2292f42dd5ff88734ddfd279
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:03 2019 +0300

    Initial commit
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git rebase develop
Successfully rebased and updated refs/heads/master.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git log
commit 1ae25ef68001ad4dc8006a00b3cbf6c8603931d7 (HEAD -> master)
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:47:11 2019 +0300

    Changed listen port in master branch

commit b6a7ec6d1a4498eb73c9a48845d1b22fef589a78 (develop)
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:45:24 2019 +0300

    Simplified sum function in develop branch

commit 27366c81eef3edcd7fa6c123a30c4b966fb687cf (origin/feature, feature)
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:46:38 2019 +0300

    Added unit tests for server in feature branch

commit 61447bcc7de9443536578065f7337cb3aadc958a
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:58 2019 +0300

    Formatted go code

commit ddd4c0fd181ad4ce170c2db6fcb13675f4e5bcac
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:16 2019 +0300

    Added main server file

commit 14dd2901737b121a2292f42dd5ff88734ddfd279
Author: Vasiliy I Ozerov <vasiliyozerov@gmail.com>
Date:   Wed Jan 9 01:44:03 2019 +0300

    Initial commit
```
</details><br>

   4. Создай новый репозиторий в своем аккаунте, добавь его как удаленный и загрузи изменения:

Сделаем как в Task 2.3 через `glab`. Создадим репозиторый (project) с именем `devops-task-rebase` в ранее созданной группе `learn-labs` выполнив команду `glab repo create devops-task-rebase --group learn-labs --internal --description "This is the devops-task-rebase repository" `.

```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ glab repo list
Showing 2 of 2 projects (Page 1 of 1)

learn-labs/devops-task-merge  ssh://git@devops-gitlab.inno.ws:54042/learn-labs/devops-task-merge.git  This is the devops-task-merge repository
learn-labs/devops-tasks       ssh://git@devops-gitlab.inno.ws:54042/learn-labs/devops-tasks.git                                               

(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ glab repo create devops-task-rebase --group learn-labs --internal --description "This is the devops-task-rebase repository"
✓ Created repository LearnLabs  / devops-task-rebase on GitLab: https://devops-gitlab.inno.ws/learn-labs/devops-task-rebase
? Create a local project directory for LearnLabs  / devops-task-rebase? No
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ glab repo list
Showing 3 of 3 projects (Page 1 of 1)

learn-labs/devops-task-rebase  ssh://git@devops-gitlab.inno.ws:54042/learn-labs/devops-task-rebase.git  This is the devops-task-rebase repository
learn-labs/devops-task-merge   ssh://git@devops-gitlab.inno.ws:54042/learn-labs/devops-task-merge.git   This is the devops-task-merge repository 
learn-labs/devops-tasks        ssh://git@devops-gitlab.inno.ws:54042/learn-labs/devops-tasks.git                                                 
```
добавми новый репозиторий как remote для текущего локального:
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git remote -v
origin  https://devops-gitlab.inno.ws/devops-board/git-rebase.git (fetch)
origin  https://devops-gitlab.inno.ws/devops-board/git-rebase.git (push)
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git remote remove origin
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git remote -v
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git remote add origin https://devops-gitlab.inno.ws/learn-labs/devops-task-rebase.git
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ 
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git remote -v
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-rebase.git (fetch)
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-rebase.git (push)
```
и загррузим изменения:
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git push -u origin master
Enumerating objects: 18, done.
Counting objects: 100% (18/18), done.
Delta compression using up to 8 threads
Compressing objects: 100% (15/15), done.
Writing objects: 100% (18/18), 2.47 KiB | 316.00 KiB/s, done.
Total 18 (delta 4), reused 12 (delta 2), pack-reused 0
To https://devops-gitlab.inno.ws/learn-labs/devops-task-rebase.git
 * [new branch]      master -> master
branch 'master' set up to track 'origin/master'.
```
---

2. #### Point 2  
#### Объединить FIX-коммиты с родительским в один.  
   **Задача:**  
   1. Клонирууем репозиторий `https://devops-gitlab.inno.ws/ilya.sergienko1/git-squash`.  
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ git clone https://devops-gitlab.inno.ws/ilya.sergienko1/git-squash.git && cd git-squash
Cloning into 'git-squash'...
remote: Enumerating objects: 12, done.
remote: Counting objects: 100% (12/12), done.
remote: Compressing objects: 100% (8/8), done.
remote: Total 12 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (12/12), done.
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git branch -r
origin/HEAD -> origin/main
origin/main
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ 
git clone https://devops-gitlab.inno.ws/ilya.sergienko1/git-squash
```  
   2. Есть только ветка `main`, просмотри историю коммитов:  
```bash
git log --oneline
```  
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git log --oneline
a60ddff (HEAD -> main, origin/main, origin/HEAD) third fix commit
70774aa second fix commit
5e166bf first fix commit
abac525 Initial commit
```
   3. Выполни squash для объединения всех `FIX-коммитов` с родительским (в нашем случае это будет `first fix commit`).  
```bash
git rebase -i HEAD~3  
```  
      Выберем `squash` (или `s`) для нужных FIX-коммитов и определим сообщение итогового коммита:
```bash
pick 5e166bf first fix commit
squash 70774aa second fix commit
squash a60ddff third fix commit
```
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git rebase -i HEAD~3
[detached HEAD 8b3a2ea]  This is a combination of 3 commits.
 Author: ilya.serhiyenka <ilya.sergienko1@innowise.com>
 Date: Tue May 7 13:45:37 2024 +0200
 1 file changed, 3 insertions(+)
 create mode 100644 sum.py
Successfully rebased and updated refs/heads/main.
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git log --oneline
8b3a2ea (HEAD -> main)  This is a combination of 3 commits.
abac525 Initial commit
```

   4. Создадим новый репозиторий в своем аккаунте, добавим его как удаленный и загрузим изменения. Создадим ветку `develop`, сделаем в ней несколько коммитов и сделаем `merge` из этой ветки используя `squash`.
   Сделаем как в Task 2.3 через `glab`. Создадим репозиторый (project) с именем `devops-task-squash` в ранее созданной группе `learn-labs` выполнив команду `glab repo create devops-task-squash --group learn-labs --internal --description "This is the devops-task-squash repository" `
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ glab repo create devops-task-squash --group learn-labs --internal --description "This is the devops-task-squash repository"

✓ Created repository LearnLabs  / devops-task-squash on GitLab: https://devops-gitlab.inno.ws/learn-labs/devops-task-squash
```
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git remote remove origin
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git remote add origin https://devops-gitlab.inno.ws/learn-labs/devops-task-squa
sh.git
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git remote -v
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-squash.git (fetch)
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-squash.git (push)

(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git push -u origin main
Enumerating objects: 6, done.
Counting objects: 100% (6/6), done.
Delta compression using up to 8 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (6/6), 3.15 KiB | 805.00 KiB/s, done.
Total 6 (delta 0), reused 5 (delta 0), pack-reused 0
To https://devops-gitlab.inno.ws/learn-labs/devops-task-squash.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```
Создадим ветку `develop`:
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git checkout -b develop
git push -u origin develop
Switched to a new branch 'develop'
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
remote: 
remote: To create a merge request for develop, visit:
remote:   https://devops-gitlab.inno.ws/learn-labs/devops-task-squash/-/merge_requests/new?merge_request%5Bsource_branch%5D=develop
remote: 
To https://devops-gitlab.inno.ws/learn-labs/devops-task-squash.git
 * [new branch]      develop -> develop
branch 'develop' set up to track 'origin/develop'.
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git branch 
* develop
  main
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ 
```
Внесем изменения и сделаем несколько коммитов:
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git log --oneline
69b4988 (HEAD -> develop) add new defs and deleted all  libs
706e641 add import io lib
1a680e4 add import json lib
8b3a2ea (origin/main, origin/develop, main)  This is a combination of 3 commits.
abac525 Initial commit
```
Перейдем в ветку `main` смержим изменения выполнив squash всех коммитов ветки-источника и создав новый коммит в целевой:
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git merge --squash develop
Updating 8b3a2ea..69b4988
Fast-forward
Squash commit -- not updating HEAD
 sum.py | 8 ++++++++
 1 file changed, 8 insertions(+)
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git commit -m "new math functions"
[main e12f97a] new math functions
 1 file changed, 8 insertions(+)
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ 
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ 
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ 
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git log --oneline
e12f97a (HEAD -> main) new math functions
8b3a2ea (origin/main, origin/develop)  This is a combination of 3 commits.
abac525 Initial commit
```
и выгрузим в удаленный репозиторий:
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git push 
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 8 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 372 bytes | 62.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
To https://devops-gitlab.inno.ws/learn-labs/devops-task-squash.git
   8b3a2ea..e12f97a  main -> main
```

---

3. #### Point 3  
#### Перенести коммит "Formatted code" в ветку master.  
   **Задача:**  
   1. Клонируем репозиторий `https://devops-gitlab.inno.ws/ilya.sergienko1/git-cherry-pick/`.

```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ git clone https://devops-gitlab.inno.ws/ilya.sergienko1/git-cherry-pick.git
Cloning into 'git-cherry-pick'...
remote: Enumerating objects: 12, done.
remote: Counting objects: 100% (12/12), done.
remote: Compressing objects: 100% (11/11), done.
remote: Total 12 (delta 2), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (12/12), 4.10 KiB | 699.00 KiB/s, done.
Resolving deltas: 100% (2/2), done.
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ cd git-cherry-pick/
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ ls
README.md  main.go
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ git branch -r
  origin/HEAD -> origin/main
  origin/develop
  origin/main
```  

   2. Найди идентификатор коммита "Formatted code" в ветке `develop`, например, с помощью:  
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ git log --oneline
601c4aa (HEAD -> main, origin/main, origin/HEAD) add main file
0526fd0 Initial commit
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ git checkout -b develop origin/develop
branch 'develop' set up to track 'origin/develop'.
Switched to a new branch 'develop' 
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ git branch
* develop
  main
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ git log --oneline
e4a9855 (HEAD -> develop, origin/develop) Formatted code
fc5d3e2 add main file
601c4aa (origin/main, origin/HEAD, main) add main file
0526fd0 Initial commit
```  
   3. Перенеси коммит в ветку `main` с помощью команды `git cherry-pick`, разрешить конфликт если потребуется:  
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ git checkout main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ git cherry-pick e4a9855
Auto-merging main.go
CONFLICT (content): Merge conflict in main.go
error: could not apply e4a9855... Formatted code
hint: After resolving the conflicts, mark them with
hint: "git add/rm <pathspec>", then run
hint: "git cherry-pick --continue".
hint: You can instead skip this commit with "git cherry-pick --skip".
hint: To abort and get back to the state before "git cherry-pick",
hint: run "git cherry-pick --abort".
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ nano main.go 
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ git add main.go 
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ git cherry-pick --continue
[main fb8eeff] Formatted code
 Author: ilya.serhiyenka <ilya.sergienko1@innowise.com>
 Date: Tue May 7 13:54:43 2024 +0200
 1 file changed, 33 insertions(+), 32 deletions(-)
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ 
      git checkout master
      git cherry-pick <ID коммита>
```  
   4. Создай новый репозиторий в своем аккаунте, добавь его как удаленный и загрузи изменения. Выполняем как в предыдущих пунктах:
```bash
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ glab repo create devops-task-cherry --group learn-labs --internal --description "This is the devops-task-cherry repository"
✓ Created repository LearnLabs  / devops-task-cherry on GitLab: https://devops-gitlab.inno.ws/learn-labs/devops-task-cherry
? Create a local project directory for LearnLabs  / devops-task-cherry? No
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ 
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ git remote remove origin
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ git remote add origin https://devops-gitlab.inno.ws/learn-labs/devops-task-cherry
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ git remote -v
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-cherry (fetch)
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-cherry (push)
(netops) yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-cherry-pick$ git push --set-upstream origin main
warning: redirecting to https://devops-gitlab.inno.ws/learn-labs/devops-task-cherry.git/
Enumerating objects: 9, done.
Counting objects: 100% (9/9), done.
Delta compression using up to 8 threads
Compressing objects: 100% (8/8), done.
Writing objects: 100% (9/9), 3.88 KiB | 497.00 KiB/s, done.
Total 9 (delta 1), reused 5 (delta 0), pack-reused 0
To https://devops-gitlab.inno.ws/learn-labs/devops-task-cherry
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```
