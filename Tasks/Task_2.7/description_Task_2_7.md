### Чекпоинты

[1) Проверьте наличие файла `~/.gitconfig` и создайте его при необходимости.](#point-1)  
[2) Настройте `.gitconfig` для подключения другого конфига в определенной директории.](#point-2)  
[3) Создайте файл `.gitconfig-innowise` с необходимыми креденшелами.](#point-3)  

---

1. #### Point 1  
#### Проверьте наличие файла `~/.gitconfig` и создайте его при необходимости.  
   **Задача:**  
   1. Откройте терминал и выполните команду: 
```bash 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ ls -la ~/.gitconfig
-rw-r--r-- 1 yarik yarik 492 Jan 22 11:45 /home/yarik/.gitconfig
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ cat  ~/.gitconfig
[user]
        email = alenchyk.yaroslav@gmail.com
        name = Yaroslav Alenchyk
[credential "https://github.com"]
        helper = 
        helper = !/usr/bin/gh auth git-credential
[credential "https://gist.github.com"]
        helper = 
        helper = !/usr/bin/gh auth git-credential
[credential]
        helper = store
[credential "https://bitbucket.org"]
        helper = store
```
---

2. #### Point 2  
#### Настройте `.gitconfig` для подключения другого конфига в определенной директории.  
   **Задача:**  
   1. Откроем файл `~/.gitconfig` в текстовом редакторе.  
   2. Добавим следующий блок в конец файла:  
```ini
[includeIf "gitdir:~/innowise/"]
    path = ~/.gitconfig-innowise
[includeIf "gitdir:/mnt/c/Users/user/DEVOPS_TRAINEE/"]
    path = ~/.gitconfig-devopstrainee
init.defaultbranch=main
``` 

---

3. #### Point 3  
#### Создайте файл `.gitconfig-innowise` с необходимыми креденшелами.  
   **Задача:**  
   1. Создадим и отредактируем файл `~/.gitconfig-innowise` например с помощью команды `nano`:  
```bash
nano ~/.gitconfig-innowise
```  
добавив следующие строки:  
```ini 
[user]
email = alenchyk.yaroslav@innowise.com
name = Yaroslav Alenchyk (Innowise)

[alias]
st = status
co = checkout
br = branch
ci = commit
lg = log --oneline --graph --all

[core]
editor = nano
autocrlf = input

[credential]
helper = store
```
и файл `~/.gitconfig-devopstrainee ` :
```ini
[user]
    email = yaraslau.alenchyk@innowise.com
    name = Yaroslav Alenchyk (Innowise)

[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    lg = log --oneline --graph --all

[core]
    editor = nano
    autocrlf = inpute

[credential]
    helper = store
```

   3. Сохраним и проверим настройки:
```bash
yarik@Innowise-work:~$ git config --list --show-origin
file:/home/yarik/.gitconfig     user.email=alenchyk.yaroslav@gmail.com
file:/home/yarik/.gitconfig     user.name=Yaroslav Alenchyk
file:/home/yarik/.gitconfig     credential.https://github.com.helper=
file:/home/yarik/.gitconfig     credential.https://github.com.helper=!/usr/bin/gh auth git-credential
file:/home/yarik/.gitconfig     credential.https://gist.github.com.helper=
file:/home/yarik/.gitconfig     credential.https://gist.github.com.helper=!/usr/bin/gh auth git-credential
file:/home/yarik/.gitconfig     credential.helper=store
file:/home/yarik/.gitconfig     credential.https://bitbucket.org.helper=store
file:/home/yarik/.gitconfig     includeif.gitdir:~/innowise/.path=~/.gitconfig-innowise
file:/home/yarik/.gitconfig     includeif.gitdir:/mnt/c/Users/user/DEVOPS_TRAINEE/.path=~/.gitconfig-devopstrainee
file:.git/config        core.repositoryformatversion=0
file:.git/config        core.filemode=true
file:.git/config        core.bare=false
file:.git/config        core.logallrefupdates=true

yarik@Innowise-work:~$ git config --global --list
user.email=alenchyk.yaroslav@gmail.com
user.name=Yaroslav Alenchyk
credential.https://github.com.helper=
credential.https://github.com.helper=!/usr/bin/gh auth git-credential
credential.https://gist.github.com.helper=
credential.https://gist.github.com.helper=!/usr/bin/gh auth git-credential
credential.helper=store
credential.https://bitbucket.org.helper=store
includeif.gitdir:~/innowise/.path=~/.gitconfig-innowise
includeif.gitdir:/mnt/c/Users/user/DEVOPS_TRAINEE/.path=~/.gitconfig-devopstrainee
yarik@Innowise-work:~$ git config --local --list
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true

yarik@Innowise-work:~$ cat .gitconfig
[user]
        email = alenchyk.yaroslav@gmail.com
        name = Yaroslav Alenchyk
[credential "https://github.com"]
        helper = 
        helper = !/usr/bin/gh auth git-credential
[credential "https://gist.github.com"]
        helper = 
        helper = !/usr/bin/gh auth git-credential
[credential]
        helper = store
[credential "https://bitbucket.org"]
        helper = store
[includeIf "gitdir:~/innowise/"]
    path = ~/.gitconfig-innowise
[includeIf "gitdir:/mnt/c/Users/user/DEVOPS_TRAINEE/"]
    path = ~/.gitconfig-devopstrainee

yarik@Innowise-work:~$ cd /mnt/c/Users/user/DEVOPS_TRAINEE/
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE$ git config --local --list
fatal: --local can only be used inside a git repository
    
```

---


    


