### Чекпоинты:

[1) Создать два репозитория (repo-A, repo-B).](#Point-1)  
[2) Создать `.test-ci.yml` в `repo-A` и `.gitlab-ci.yml` в `repo-B`:](#Point-2)  
[3) Добавить в `.gitlab-ci.yml` стейдж `build`, который выполняет `echo "Hello from build job"`, а также стейдж `deploy`, который выполняет `echo "Hello from deploy job".`](#Point-3)  

---

1. #### Point 1  
   **Создать два репозитория (repo-A, repo-B).**

   - **Шаги:**
     - Перейдите в вашу систему контроля версий (например, GitLab, GitHub).
     - Создайте новый репозиторий с именем `repo-A`.
     - Аналогично, создайте второй репозиторий с именем `repo-B`.

2. #### Point 2  
   **Создать `.test-ci.yml` в `repo-A` и `.gitlab-ci.yml` в `repo-B`:**

   - **Шаги для `repo-A`:**
     - В корневом каталоге `repo-A` создайте файл с именем `.test-ci.yml`.
     - Добавьте в него следующий контент:

```yaml
  stages:
  - test
  
test-job:
  stage: test
  script:
    - echo "Running tests"
```

   - **Шаги для `repo-B`:**
     - В корневом каталоге `repo-B` создайте файл с именем `.gitlab-ci.yml`.
     - Добавьте в него следующий контент, заменив `<URL_TO_REPO_A>` на URL-адрес `repo-A` и `<BRANCH>` на соответствующую ветку:

```yaml
# main pipeline
stages:
    - test
    - build
    - deploy

include:
  - project: 'learn-labs/repo-a'
    ref: main
    file:
      - '/.test-ci.yml'

build_job:
    stage: build
    script:
    - echo "Hello from build job"

deploy_job:
    stage: deploy
    script:
    - echo "Hello from deploy job"
```

       **Примечание:** Убедитесь, что `repo-A` доступен для `repo-B`, и что файл `.test-ci.yml` находится в указанном пути.

3. #### Point 3  
   **Добавить в `.gitlab-ci.yml` стейдж `build`, который выполняет `echo "Hello from build job"`, а также стейдж `deploy`, который выполняет `echo "Hello from deploy job".`**

   - **Шаги:**
     - В файле `.gitlab-ci.yml` в `repo-B` уже добавлены стейджи `build` и `deploy` с соответствующими задачами, как указано в предыдущем пункте.

---

Следуя этим шагам, вы настроите два репозитория с соответствующими CI/CD конфигурациями, где `repo-B` будет включать и расширять конфигурацию из `repo-A`.
