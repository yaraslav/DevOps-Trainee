### Чекпоинты:

[1) Докеризация python-приложения.](#point-1)  
[2) Написание пайплайна для автоматической сборки и тестирования.](#point-2)  
[3) (Опционально) Исправление ошибки в юнит-тесте.](#point-3)  
[4) (Опционально) Этап развертывания приложения.](#point-4)  

---

1. #### Point 1  
   **Докеризация python-приложения.**
     - Создадим новый проект и ветку `main` через web-интерфейс Gitlab.
     - Код python-приложения и его зависимости возмем в репозитории  [здесь](https://devops-gitlab.inno.ws/cicd/4.12.git), там же скопируем подготовленный заранее юнит-тест `app_test.py` в отдельную директорию.
     - Создадим файлы `python-app.py`, `Dockerfile`, `requirements.txt` для Python-приложения.
- Python-приложение на Flask:
```py
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, World!"
```
- Файл с зависимостями:
```ini
Flask>=2.0,<=2.1.1
Werkzeug==2.3.7
```
- Dockerfile для сборки приложения:
```dockerfile
FROM python:3.11-alpine

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt --no-cache-dir

COPY . .

ENV FLASK_APP=python_app.py
ENV FLASK_RUN_HOST=0.0.0.0

EXPOSE 5000

CMD ["flask", "run"]
```
- Так как в задаче надо выполнить юнит-тест приложения из подготовленного теста `test_app.py` создадим файл для сборки тестового приложения - `test.Dockerfile`, где укажем запуск инструмента `unittest` и используемого теста, без запуска самого сервера Flask.
```dockerfile
FROM python:3.11-alpine

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt --no-cache-dir

COPY . .

CMD [ "-m", "unittest", "test/test_app.py" ]
ENTRYPOINT [ "python" ]
```

1. #### Point 2  
   **Написание пайплайна для автоматической сборки и тестирования.**  
  
     - Создадим  файл `.gitlab-ci.yml` в `main` ветке через web-интерфейс Gitlab. Добавим этапы сборки образа для тестирования и самого тестирования.
```yaml
stages:
    - build-test
    - test

image: docker:latest
services:
    - docker:dind

variables:
  TEST_IMG: test_app
  APP_NAME: flask

build-docker-test:
  stage: build-test

  script:
    - docker buildx build -t $TEST_IMG -f test.Dockerfile .

  rules:
    - if: $CI_COMMIT_BRANCH

test-docker-test:
  stage: test
  script:
    - docker run --rm $TEST_IMG

```

- Pipeline запустится автоматически при коммите к ветке, поэтому сохраняем и ждём отработки pipeline:
Результат этапа тестирования:
```bash
  return result_type(scheme, netloc, url, query, fragment)
.
----------------------------------------------------------------------
Ran 1 test in 0.005s
OK
```

1. #### Point 3  *(Опционально)* 
   **Исправление ошибки в юнит-тесте.**  
 
Ошибок в тесте не выдало. Тест пройден успешно.

2. #### Point 4  *(Опционально)*  
   **Этап развертывания приложения.**  
 
  Добавим этапы сборки образа для развертывания приложения в prod окружении и развертывания на prod инфраструктуре (объеденим в один этап). Образ для prod инфраструктуры будем сохранять в gitlab registry данного проекта, а развертывать через копирование образа на хост-сервер с установленным docker и запуск его. Будет использовать ранее созданный сервер в AWS инфраструктуре:
     - Добавми необходимые переменные в CICD-variables (в т.ч. ключи SSH и URL/IP сервера). Добавим скрипты установки ssh-agent и добавление ключей ssh. 
     - Добавим этап сборки полнофункционального приложения из `prod.Dockerfile` и сохраним его в `gitlab container registry`:
  
```yaml
stages:
    - build-test
    - test
    - deploy

image: docker:latest
services:
    - docker:dind

variables:
  CI_REGISTRY_PASSWORD: $CI_REGISTRY_PASSWORD
  CI_REGISTRY: $CI_REGISTRY
  CI_PROJECT_PATH: $CI_PROJECT_PATH
  SSH_KEY: $SSH_PRIVATE_KEY
  PATH_HOST: $HOST
  TEST_IMG: test_app
  PROD_IMG: $CI_REGISTRY/$CI_PROJECT_PATH/app
  APP_NAME: flask


deploy-docker-prod:
  stage: deploy
  before_script:
    - 'command -v ssh-agent >/dev/null || ( apt-get update -y && apt-get install openssh-client -y )'
    - eval $(ssh-agent -s)
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - echo "$SSH_KEY" > ~/.ssh/aws_key.pem
    - chmod 400 ~/.ssh/aws_key.pem
    - ssh-add ~/.ssh/aws_key.pem

    - echo "$CI_JOB_TOKEN" | docker login $CI_REGISTRY -u $CI_REGISTRY_USER --password-stdin

  script:
    - docker buildx build -t $PROD_IMG -f prod.Dockerfile .

    - VERSION=$(date "+%Y%m%d%H%M")
    - docker tag $PROD_IMG $PROD_IMG:$VERSION
    - docker push $PROD_IMG:$VERSION

    - docker save $PROD_IMG:$VERSION | ssh -o StrictHostKeyChecking=no $PATH_HOST docker load
    - ssh -o StrictHostKeyChecking=no $PATH_HOST docker run --name $APP_NAME -d -p 5000:5000 $PROD_IMG:$VERSION 

```
- Pipeline запустится автоматически при коммите к ветке, поэтому сохраняем и ждём отработки pipeline.

**Результаты:**

- Видим успешную запись в registry:

```bash
$ docker push $PROD_IMG:$VERSION
The push refers to repository [devops-registry.inno.ws/learn-labs/ci-cd-python/app]
88f0f8a0ec77: Preparing
....
7a5f03216aec: Layer already exists
88f0f8a0ec77: Pushed
202502181806: digest: sha256:2a531bd11bb58e3205c06dad85498d71334fc53597543c4755f59ccc7e89bb97 size: 1990
```
- И успешное копирование и запуск контейнера на сервере:
```bash
$ docker save $PROD_IMG:$VERSION | ssh -o StrictHostKeyChecking=no $PATH_HOST docker load
Warning: Permanently added *******  to the list of known hosts.
Loaded image: devops-registry.inno.ws/learn-labs/ci-cd-python/app:202502181806
$ ssh -o StrictHostKeyChecking=no $PATH_HOST docker run --name $APP_NAME -d -p 5000:5000 $PROD_IMG:$VERSION
90ddce71eb6901d00882664d010bd914e8bb24a8a471f1fda3a824787e69844b
Cleaning up project directory and file based variables

Job succeeded
```
 - проверяем образ и контейнер на сервере и работу самого сервиса:
```bash
ubuntu@ip-172-31-30-234:~$ docker images
REPOSITORY                                            TAG            IMAGE ID       CREATED         SIZE
devops-registry.inno.ws/learn-labs/ci-cd-python/app   202502181806   4619db9c1937   4 minutes ago   69.3MB
ubuntu@ip-172-31-30-234:~$ docker ps
CONTAINER ID   IMAGE                                                              COMMAND                  CREATED         STATUS                       PORTS                                       NAMES
90ddce71eb69   devops-registry.inno.ws/learn-labs/ci-cd-python/app:202502181806   "flask run"              4 minutes ago   Up 4 minutes                 0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   flask
ubuntu@ip-172-31-30-234:~$ curl http://localhost:5000
Hello, World!

ubuntu@ip-172-31-30-234:~$

```
---
**ПРИМЕЧАНИЕ:**
- при развертывании на серверах размещенных в AWS EC2 необходимо внести в правила доступа диапазоны адресов Gitlab серверов в CICD Gitlab Runners - в нашем случае (Innowise [Gitlab](https://devops-gitlab.inno.ws/)) Runner с адресом `5.9.127.255/32`


Полные версии файлов здесь: [gitlab-ci.yml](.gitlab-ci.yml), [prod.Dockerfile](prod.Dockerfile), [test.Dockerfile](test.Dockerfile), [python_app.py](python_app.py), [requirements.txt](requirements.txt) [unit_test.py](test/unit_test.py)

---


