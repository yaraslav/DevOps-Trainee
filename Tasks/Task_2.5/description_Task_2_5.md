### Чекпоинты

[1) Загрузить репозиторий git-squash, выполнить squash и принудительную загрузку изменений.](#Point-1)  
[2) Создать pull requests для веток feature и develop в репозитории git-rebase.](#Point-2)  
[3) Создать pull request из ветки feature в develop в репозитории git-merge.](#Point-3)  
[4) Выполнить fork репозитория git-checkout, добавить файл и создать pull request.](#Point-4)  

---

1. #### Point 1  
#### Загрузить репозиторий git-squash, выполнить squash и принудительную загрузку изменений.  
   **Задача:**  
   1. Клонируй репозиторий `https://devops-gitlab.inno.ws/ilya.sergienko1/git-squash`:  
```bash
git clone https://devops-gitlab.inno.ws/ilya.sergienko1/git-squash
```  
Выполнено в п.2.4

   2. Создай репозиторий `devops-task-force` в своем аккаунте.  
    Создаем как в предыдущих задачах:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ glab repo create devops-task-force  --group learn-labs --internal --description "This is the devops-task-force repository"
✓ Created repository LearnLabs  / devops-task-force on GitLab: https://devops-gitlab.inno.ws/learn-labs/devops-task-force
? Create a local project directory for LearnLabs  / devops-task-force? No
```
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ glab repo list
Showing 6 of 6 projects (Page 1 of 1)

learn-labs/devops-task-force   ssh://git@devops-gitlab.inno.ws:54042/learn-labs/devops-task-force.git   This is the devops-task-force repository 
learn-labs/devops-task-cherry  ssh://git@devops-gitlab.inno.ws:54042/learn-labs/devops-task-cherry.git  This is the devops-task-cherry repository
learn-labs/devops-task-squash  ssh://git@devops-gitlab.inno.ws:54042/learn-labs/devops-task-squash.git  This is the devops-task-squash repository
learn-labs/devops-task-rebase  ssh://git@devops-gitlab.inno.ws:54042/learn-labs/devops-task-rebase.git  This is the devops-task-rebase repository
learn-labs/devops-task-merge   ssh://git@devops-gitlab.inno.ws:54042/learn-labs/devops-task-merge.git   This is the devops-task-merge repository 
learn-labs/devops-tasks        ssh://git@devops-gitlab.inno.ws:54042/learn-labs/devops-tasks.git                                                 

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ 
```

   3. Добавь его как удаленный:  

```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git remote add origin https://devops-gitlab.inno.ws/learn-labs/devops-task-force.git
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git remote -v
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-force.git (fetch)
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-force.git (push)
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ 
```  

   4. Залей весь репозиторий git-squash в devops-task-force:  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git push -u origin main
Enumerating objects: 9, done.
Counting objects: 100% (9/9), done.
Delta compression using up to 8 threads
Compressing objects: 100% (7/7), done.
Writing objects: 100% (9/9), 3.48 KiB | 323.00 KiB/s, done.
Total 9 (delta 0), reused 5 (delta 0), pack-reused 0
remote: 
remote: ========================================================================
remote: 
remote:   Gitlab recovered on jan 18th date. Thank you for understanding, and
remote:      I really hope that this doesn't affect our friendship. Cheers.
remote: 
remote: ========================================================================
remote: 
To https://devops-gitlab.inno.ws/learn-labs/devops-task-force.git
* [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ 
```  
   5. Перейди в ветку `develop`, объедини все коммиты в один с помощью squash:  
```bash
git checkout develop
git rebase -i HEAD~N  
```  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git checkout develop
Switched to branch 'develop'
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git log --oneline
69b4988 (HEAD -> develop) add new defs and deleted all  libs
706e641 add import io lib
1a680e4 add import json lib
8b3a2ea  This is a combination of 3 commits.
abac525 Initial commit
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$
```
Выбери `squash` (или `s`) для всех коммитов.
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git rebase -i HEAD~4
Successfully rebased and updated refs/heads/develop.

s 8b3a2ea This is a combination of 3 commits.
s 1a680e4 add import json lib
s 706e641 add import io lib 
s 69b4988 add new defs and deleted all  libs
```
        
   6. Попробуй выполнить обычный push:

```bash
git push
```  
Сохрани текст ошибки.  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git push
fatal: You are not currently on a branch.
To push the history leading to the current (detached HEAD)
state now, use

    git push origin HEAD:<name-of-remote-branch>

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git branch
* (no branch, rebasing develop)
  develop
  main
```
Траблшутим ошибку:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git status
interactive rebase in progress; onto abac525
No commands done.
Next commands to do (4 remaining commands):
   s 8b3a2ea This is a combination of 3 commits.
   s 1a680e4 add import json lib
  (use "git rebase --edit-todo" to view and edit)
You are currently editing a commit while rebasing branch 'develop' on 'abac525'.
  (use "git commit --amend" to amend the current commit)
  (use "git rebase --continue" once you are satisfied with your changes)

nothing to commit, working tree clean
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git rebase --continue
error: cannot 'squash' without a previous commit
error: cannot 'squash' without a previous commit
error: cannot 'squash' without a previous commit
error: please fix this using 'git rebase --edit-todo'.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$
```
и исправляем её:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git rebase --edit-todo
pick 8b3a2ea This is a combination of 3 commits.
squash 1a680e4 add import json lib
squash 706e641 add import io lib
s 69b4988 add new defs and deleted all  libs

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git rebase --continue
[detached HEAD 687b7a0]  This is a combination of 3 commits.
 Author: ilya.serhiyenka <ilya.sergienko1@innowise.com>
 Date: Tue May 7 13:45:37 2024 +0200
 1 file changed, 11 insertions(+)
 create mode 100644 sum.py
Successfully rebased and updated refs/heads/develop.
```
   7. Выполни принудительный push:  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ git push -u origin develop
Enumerating objects: 4, done.
Counting objects: 100% (4/4), done.
Delta compression using up to 8 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 474 bytes | 67.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
remote: 
remote: ========================================================================
remote: 
remote:   Gitlab recovered on jan 18th date. Thank you for understanding, and
remote:      I really hope that this doesn't affect our friendship. Cheers.
remote: 
remote: ========================================================================
remote: 
remote: 
remote: To create a merge request for develop, visit:
remote:   https://devops-gitlab.inno.ws/learn-labs/devops-task-force/-/merge_requests/new?merge_request%5Bsource_branch%5D=develop
remote: 
To https://devops-gitlab.inno.ws/learn-labs/devops-task-force.git
* [new branch]      develop -> develop
branch 'develop' set up to track 'origin/develop'.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-squash$ 
```  

---

2. #### Point 2  
#### Создать pull requests для веток feature и develop в репозитории git-rebase.  
   **Задача:**  
   1. Клонируй репозиторий `git-rebase`:  
```bash
git clone <репозиторий git-rebase>
```  
   2. Создай новый репозиторий в своем аккаунте.  
Используем ранее созданный:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ cd git-rebase/
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ ls
README.md  main.go  main_test.go
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git branch
  develop
  feature
* master
```
   3. Добавь его как удаленный и залей изменения: 
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git remote -v
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-rebase.git (fetch)
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-rebase.git (push)
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git push -u origin --all
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
remote: 
remote: ========================================================================
remote: 
remote:   Gitlab recovered on jan 18th date. Thank you for understanding, and
remote:      I really hope that this doesn't affect our friendship. Cheers.
remote: 
remote: ========================================================================
remote: 
remote: 
remote: To create a merge request for develop, visit:
remote:   https://devops-gitlab.inno.ws/learn-labs/devops-task-rebase/-/merge_requests/new?merge_request%5Bsource_branch%5D=develop
remote: 
remote: 
remote: To create a merge request for feature, visit:
remote:   https://devops-gitlab.inno.ws/learn-labs/devops-task-rebase/-/merge_requests/new?merge_request%5Bsource_branch%5D=feature
remote: 
To https://devops-gitlab.inno.ws/learn-labs/devops-task-rebase.git
 * [new branch]      develop -> develop
 * [new branch]      feature -> feature
branch 'master' set up to track 'origin/master'.
branch 'develop' set up to track 'origin/develop'.
branch 'feature' set up to track 'origin/feature'.
```
  
   4. Создай два pull requests:  
- Из ветки `feature` в `develop`.  
Переходим по ссылке в web-интерфейс  `https://devops-gitlab.inno.ws/learn-labs/devops-task-rebase/-/merge_requests/new?merge_request%5Bsource_branch%5D=feature`

или через cli glab:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ glab mr create -s feature -b develop --title "Merge feature into develop" --description "`feature` to `develop`.pull request"

Creating merge request for feature into develop in learn-labs/devops-task-rebase

!1 Merge feature into develop (feature)
 https://devops-gitlab.inno.ws/learn-labs/devops-task-rebase/-/merge_requests/1

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ 
```
- Из ветки `develop` в `master`.  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ glab mr create -s develop -b master --title "Merge feature into develop" --description "develop to master pull request"

Creating merge request for develop into master in learn-labs/devops-task-rebase

Failed to create merge request. Created recovery file: /home/yarik/.config/glab-cli/recover/learn-labs/devops-task-rebase/mr.json
Run the command again with the '--recover' option to retry
POST https://devops-gitlab.inno.ws/api/v4/projects/learn-labs/devops-task-rebase/merge_requests: 409 {message: [Another open merge request already exists for this source branch: !2]}
```
Получаем ошибку, т.к. нужно принять предыдущий MR
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ glab mr list
Showing 2 open merge requests on learn-labs/devops-task-rebase (Page 1)

!2  learn-labs/devops-task-rebase!2  Merge feature into develop  (master) ← (develop) 
!1  learn-labs/devops-task-rebase!1  Merge feature into develop  (develop) ← (feature)

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$
```
Траблшутим и исправляем ошибки:

```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ glab mr merge 1
there are merge conflicts. Resolve conflicts and try again or merge locally

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git checkout feature
git merge develop
Switched to branch 'feature'
Your branch is up to date with 'origin/feature'.
Updating 27366c8..b6a7ec6
Fast-forward
 main.go | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ git push origin feature
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
remote: 
remote: ========================================================================
remote: 
remote:   Gitlab recovered on jan 18th date. Thank you for understanding, and
remote:      I really hope that this doesn't affect our friendship. Cheers.
remote: 
remote: ========================================================================
remote: 
remote: 
remote: View merge request for feature:
remote:   https://devops-gitlab.inno.ws/learn-labs/devops-task-rebase/-/merge_requests/1
remote: 
To https://devops-gitlab.inno.ws/learn-labs/devops-task-rebase.git
   27366c8..b6a7ec6  feature -> feature
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ glab mr merge 1
? What merge method would you like to use?  [Use arrows to move, type to filter]
> Create a merge commit
  Rebase and merge
  Squash and 
```

---

3. #### Point 3  
#### Создать pull request из ветки feature в develop в репозитории git-merge.  
   **Задача:**  
   1. Клонируй репозиторий `https://devops-gitlab.inno.ws/ilya.sergienko1/git-merge`:  
```bash
git clone https://devops-gitlab.inno.ws/ilya.sergienko1/git-merge
```  
   2. Создай новый репозиторий в своем аккаунте и залей туда изменения:  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-rebase$ cd ..
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ cd git-merge/
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git remote -v
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-merge.git (fetch)
origin  https://devops-gitlab.inno.ws/learn-labs/devops-task-merge.git (push)
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ git push -u origin --all
branch 'development' set up to track 'origin/development'.
branch 'feature' set up to track 'origin/feature'.
branch 'master' set up to track 'origin/master'.
Everything up-to-date
```
   3. Создай pull request из ветки `feature` в ветку `develop`.  Посмотри, как отображаются конфликты в интерфейсе GitLab
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ glab mr create -s feature -b develop --title "Merge feature into develop" --description "pull request"

Creating merge request for feature into develop in learn-labs/devops-task-merge

!1 Merge feature into develop (feature)
 https://devops-gitlab.inno.ws/learn-labs/devops-task-merge/-/merge_requests/1

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ glab mr create -s feature -b development --title "Merge feature into develop" --description "pull request"

Creating merge request for feature into development in learn-labs/devops-task-merge

!2 Merge feature into develop (feature)
 https://devops-gitlab.inno.ws/learn-labs/devops-task-merge/-/merge_requests/2

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ glab mr view 2
open • opened by yaraslau.alenchyk less than a minute ago
Merge feature into develop !2

  pull request                                                                

0 upvotes • 0 downvotes • 0 comments
✓ This merge request has  changes
x This branch has conflicts that must be resolved

View this merge request on GitLab: https://devops-gitlab.inno.ws/learn-labs/devops-task-merge/-/merge_requests/2
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ 
```
Переходим по указанной ссылке и разрешаем конфликт (т.к. нет никаких вносимых изменений, gitlab предложит создать файл его, создаем и проверяем)
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ glab mr view 2
open • opened by yaraslau.alenchyk about 28 minutes ago
Merge feature into develop !2

  pull request                                                                

0 upvotes • 0 downvotes • 0 comments
Pipeline Status: success (View pipeline with `glab ci view feature`)
✓ This merge request has 1 changes

View this merge request on GitLab: https://devops-gitlab.inno.ws/learn-labs/devops-task-merge/-/merge_requests/2
```
Принимаем merge через glab:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ glab mr merge 2
X Sorry, your reply was invalid: "т" is not a valid answer, please try again.
? Set auto-merge? No
? What merge method would you like to use? Create a merge commit
? What's next? Submit
✓ Merged
!2 Merge feature into develop (feature)
 https://devops-gitlab.inno.ws/learn-labs/devops-task-merge/-/merge_requests/2

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-merge$ 
```

---

4. #### Point 4  
#### Выполнить fork репозитория git-checkout, добавить файл и создать pull request.  
   **Задача:**  
   1. Выполни fork репозитория `git-checkout` в своем аккаунте.
Выполним через web-интерфейс Gilab аккаунта. Новый репозиторий  - `https://devops-gitlab.inno.ws/yaraslau.alenchyk/git-checkout.git`

   2. Клонируй форкнутый репозиторий:  
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ git clone https://devops-gitlab.inno.ws/yaraslau.alenchyk/git-checkout.git
Cloning into 'git-checkout'...
remote: Enumerating objects: 24, done.
remote: Counting objects: 100% (24/24), done.
remote: Compressing objects: 100% (20/20), done.
remote: Total 24 (delta 4), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (24/24), 6.55 KiB | 1.31 MiB/s, done.
Resolving deltas: 100% (4/4), done.https://devops-gitlab.inno.ws/learn-labs/git-checkout.git
```  
   3. Переключись в ветку `feature`. Добавь новый файл, закоммить изменения и залить изменения: 
```bash
      yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-checkout$ git branch --all
* main
  remotes/origin/HEAD -> origin/main
  remotes/origin/feature
  remotes/origin/main
  remotes/origin/master
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-checkout$ git checkout feature 
branch 'feature' set up to track 'origin/feature'.
Switched to a new branch 'feature'
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-checkout$ git branch --all
* feature
  main
  remotes/origin/HEAD -> origin/main
  remotes/origin/feature
  remotes/origin/main
  remotes/origin/master
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-checkout$  echo "Interesting fact" > interesting.txt
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-checkout$ git add interesting.txt
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-checkout$ git commit -m "Added interesting information"
[feature ae2c11c] Added interesting information
 1 file changed, 1 insertion(+)
 create mode 100644 interesting.txt
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-checkout$ 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/git-checkout$ git push -u origin 
Enumerating objects: 4, done.
Counting objects: 100% (4/4), done.
Delta compression using up to 8 threads
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 310 bytes | 77.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0), pack-reused 0
remote: 
remote: ========================================================================
remote: 
remote:   Gitlab recovered on jan 18th date. Thank you for understanding, and
remote:      I really hope that this doesn't affect our friendship. Cheers.
remote: 
remote: ========================================================================
remote: 
remote: 
remote: To create a merge request for feature, visit:
remote:   https://devops-gitlab.inno.ws/yaraslau.alenchyk/git-checkout/-/merge_requests/new?merge_request%5Bsource_branch%5D=feature
remote: 
To https://devops-gitlab.inno.ws/yaraslau.alenchyk/git-checkout.git
   6a962c2..ae2c11c  feature -> feature
branch 'feature' set up to track 'origin/feature'.
``` 
   4. Создай pull request в основной проект `git-checkout`.  

Создание и разрешение pull (merge) request выполняю в web-интерфейсе.
