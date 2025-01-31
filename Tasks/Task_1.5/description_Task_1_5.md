### Чекпоинты:

[1) Создать сервер t2.micro, он должен иметь публичный ip и доступ в интернет. Разрешить http трафик в security group, ассоциированной с данным сервером.](#Point-1)  
[2) Установить Nginx, напиши конфигурационный файл, который будет раздавать html-страницу blue.html. Проверить работоспособность(выдает ли он нужную страницу).](#Point-2)  
[3) Создать еще два сервера t2.micro, на одном настроить раздачу страницы yellow.html, на втором настроить балансировщик между yellow и blue. Балансировщик должен направлять запрос на сервер с меньшим количеством подключений. По итогу должно получиться так, что при каждом новом подключении цвет заднего фона должен меняться. ](#Point-3)  
[4) Добавить в конфигурацию вывод логов, который будет показывать, куда проксируется запрос клиента. ](#Point-4)   
[5) Создать еще один сервер с сайтом и добавить его в конфигурацию как backup сервер. ](#Point-5)  
[6) Выгрузить конфиги в личный репозиторий на devops-gitlab.inno.ws. ](#Point-6)  




1. #### Point 1  
#### Создать сервер t2.micro, он должен иметь публичный ip и доступ в интернет. Разрешить http трафик в security group, ассоциированной с данным сервером.

Использую ранее настроенный  инстанс EC2 и существующую SecurityGroup.

2. #### Point 2  
 #### Установить Nginx, напиши конфигурационный файл, который будет раздавать html-страницу blue.html. Проверить работоспособность(выдает ли он нужную страницу).

Установим  и настроим вручную Ngnix:
```bash 
ubuntu@ip-172-31-30-89:~$ sudo apt-get update && sudo apt-get install nginx -y
```
<details>
<summary><b>лог установки...</b></summary>

```bash
Hit:1 http://eu-central-1.ec2.archive.ubuntu.com/ubuntu noble InRelease
Hit:2 http://eu-central-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease
Hit:3 http://eu-central-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease
Hit:4 http://security.ubuntu.com/ubuntu noble-security InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  nginx-common
Suggested packages:
  fcgiwrap nginx-doc ssl-cert
The following NEW packages will be installed:
  nginx nginx-common
0 upgraded, 2 newly installed, 0 to remove and 32 not upgraded.
Need to get 552 kB of archives.
After this operation, 1596 kB of additional disk space will be used.
Get:1 http://eu-central-1.ec2.archive.ubuntu.com/ubuntu noble-updates/main amd64 nginx-common all 1.24.0-2ubuntu7.1 [31.2 kB]
Get:2 http://eu-central-1.ec2.archive.ubuntu.com/ubuntu noble-updates/main amd64 nginx amd64 1.24.0-2ubuntu7.1 [521 kB]
Fetched 552 kB in 0s (16.4 MB/s)
Preconfiguring packages ...
Selecting previously unselected package nginx-common.
(Reading database ... 101428 files and directories currently installed.)
Preparing to unpack .../nginx-common_1.24.0-2ubuntu7.1_all.deb ...
Unpacking nginx-common (1.24.0-2ubuntu7.1) ...
Selecting previously unselected package nginx.
Preparing to unpack .../nginx_1.24.0-2ubuntu7.1_amd64.deb ...
Unpacking nginx (1.24.0-2ubuntu7.1) ...
Setting up nginx (1.24.0-2ubuntu7.1) ...
Setting up nginx-common (1.24.0-2ubuntu7.1) ...
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
Processing triggers for ufw (0.36.2-6) ...
Processing triggers for man-db (2.12.0-4build2) ...
Scanning processes...
Scanning linux images...

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
```
</details>

Устанавливаем и запускаем сервер nginx  как службу:

```bash
ubuntu@ip-172-31-30-89:~$ sudo systemctl start nginx
ubuntu@ip-172-31-30-89:~$ sudo systemctl enable nginx
```

Редактируем конфигурационный файл `/etc/nginx/sites-available/default`
```bash
sudo nano /etc/nginx/sites-available/default
```
в нем нужно раскомментировать и отредактировать строки 
```bash
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        location / {

                root /var/www/html;
                index blue.html;
                try_files $uri $uri/ =404;
        }
}

```
Создаем в той же директории `/var/www/html` файл html-страницу `blue.html`, 
```html
<html><body style="background-color:blue;">Blue Server</body></html>
```
например таким образом:
```bash
echo '<html><body style="background-color:blue;">Blue Server</body></html>' | sudo tee /var/www/html/blue.html > /dev/null
```
проверяем корректность конфигурации web-сервера:
```bash
ubuntu@ip-172-31-30-89:~$ sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```
Перезапускаем nginx как службу: 
```bash
sudo systemctl reload nginx
```

Проверяем работу самой службы 
```bash
sudo systemctl status nginx.service
```
<details>
<summary> Вывод systemctl status nginx.service: </summary>

```bash
ubuntu@ip-172-31-30-89:~$ sudo systemctl status nginx.service
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: active (running) since Thu 2025-01-02 12:51:03 UTC; 2h 20min ago
       Docs: man:nginx(8)
    Process: 50050 ExecReload=/usr/sbin/nginx -g daemon on; master_process on; -s reload (code=exited, status=0/SUCCESS)
   Main PID: 9679 (nginx)
      Tasks: 2 (limit: 526)
     Memory: 2.5M (peak: 3.5M)
        CPU: 30ms
     CGroup: /system.slice/nginx.service
             ├─ 9679 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on;"
             └─50052 "nginx: worker process"

Jan 02 12:51:03 ip-172-31-30-89 systemd[1]: Starting nginx.service - A high performance web server and a reverse proxy server...
Jan 02 12:51:03 ip-172-31-30-89 systemd[1]: Started nginx.service - A high performance web server and a reverse proxy server.
Jan 02 14:32:25 ip-172-31-30-89 systemd[1]: Reloading nginx.service - A high performance web server and a reverse proxy server...
Jan 02 14:32:25 ip-172-31-30-89 nginx[50050]: 2025/01/02 14:32:25 [notice] 50050#50050: signal process started
Jan 02 14:32:25 ip-172-31-30-89 systemd[1]: Reloaded nginx.service - A high performance web server and a reverse proxy server.
ubuntu@ip-172-31-30-89:~$
```
</details>

и проверяем корректность работы web-сервера делая запрос на стpаницу сервиса по ip адресу сервера через web-браузер или `curl`, например:
```bash
curl http://localhost
```
```bash
ubuntu@ip-172-31-30-89:~$ curl http://localhost
<html><body style="background-color:blue;">Blue Server</body></html>
```
Сeрвер доступен и корректно отвечает.

3. #### Point 3  
 ####   Создать еще два сервера t2.micro, на одном настроить раздачу страницы yellow.html, на втором настроить балансировщик между yellow и blue. Балансировщик должен направлять запрос на сервер с меньшим количеством подключений. По итогу должно получиться так, что при каждом новом подключении цвет заднего фона должен меняться. 

Развертывание и настройку дополнительных серверов и балансировщика (на базе nginx-сервера) буду делать через IaC подход используя `Terraform`. 
Для этого я заранее установил и инициализировал`terraform` и `aws-cli`, создал в aws через iam пользователя для работы с terraform, сгенерировал для него access-token и настроил соответствующий aws-cli profile.

Далее т.к. у нас уже есть один EC2 инстанс с web-сервером, соотвутствующая группа безопасности мы можем просто импортировать их в нашу конфигурацию terraform. 

```bash
terraform import aws_instance.blue_server i-0ce09bcece1110c69
terraform import aws_security_group.learn_ec2_sg sg-09509afda3b4efc2a
```
Проверяем созданые стейты `terraform state list`:
```bash
aws_instance.blue_server
aws_security_group.learn_ec2_sg
```
Далее создаем файлы `.tf` для описания всей инфраструктуры: `main.tf`, `variables.tf`, `terraform.tfvars`. Описываем ресурсы серверов и атрибуты остальной инфраструктуры в переменных (VPC и т.д.) на основе `blue_server` полученного из `terraform state list aws_instance.blue_server`, также описываем security_group на основе `terraform state list aws_security_group.learn_ec2_sg`.
<details>
<summary> <b>main.tf</b></summary>

```hcl
provider "aws" {
  region = var.region
}

resource "aws_security_group" "learn_ec2_sg" {
    description = "allow only ssh for my ip"
    name        = "learn_ec2"
    vpc_id      = var.vpc_id
    egress      = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = null
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
    
    ingress     = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = null
            from_port        = 443
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 443
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = null
            from_port        = 80
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 80
        },
        {
            cidr_blocks      = ["${var.my_ip}/32"]
            description      = null
            from_port        = 22
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 22
        },
    ]
    
    tags        = {
        "Name" = "learn_ec2"
    }
    tags_all    = {
        "Name" = "learn_ec2"
    }
}

# Blue Server
resource "aws_instance" "blue_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_ids[0]
  security_groups = [aws_security_group.learn_ec2_sg.name]

  tags = {
    Name = "blue-server"
  }
}

# Yellow Server
resource "aws_instance" "yellow_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.learn_ec2_sg.id]


  tags = {
    Name = "yellow-server"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt update && apt install -y nginx
    systemctl start nginx
    systemctl enable nginx
  EOF
}

# Load Balancer Server
resource "aws_instance" "load_balancer_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.learn_ec2_sg.id]

  tags = {
    Name = "load-balancer"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt update && apt install -y nginx
    cat > /etc/nginx/nginx.conf <<EOL
    events {}

    http {
        log_format main '\$proxy_protocol_addr - \$remote_user [\$time_local] "\$request" '
                        '\$status \$body_bytes_sent "\$http_referer" '
                        '"\$http_user_agent" "\$http_x_forwarded_for" '
                        'to_backend=\$upstream_addr;';

        access_log /var/log/nginx/access.log main;

        upstream backend {
            least_conn;
            server ${aws_instance.blue_server.private_ip}; # Blue server
            server ${aws_instance.yellow_server.private_ip}; # Yellow server
            server ${aws_instance.backup_server.private_ip} backup; # Backup Yellow server
        }

        server {
            listen 80;
            location / {
                proxy_pass http://backend;
                proxy_set_header Host \$host;
                proxy_set_header X-Real-IP \$remote_addr;
                proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto \$scheme;

                access_log /var/log/nginx/proxy_access.log main;
            }
        }
    }
    EOL
    systemctl restart nginx
  EOF
}

# Outputs
output "yellow_server_ip" {
  value = aws_instance.yellow_server.public_ip
}

output "load_balancer_ip" {
  value = aws_instance.load_balancer_server.public_ip
}
```

</details><br>

После создания файлов конфигурации валидируем её `terraform validate`:

```bash
(netops) yarik@Innowise-work:terraform_learn_ec2$ terraform validate
Success! The configuration is valid.
```
Выполняем `terraform plan`:
<details>
<summary> <b>Вывод результата `terraform plan`</b></summary>

```bash
(netops) yarik@Innowise-work:terraform_learn_ec2$ terraform plan
aws_security_group.learn_ec2_sg: Refreshing state... [id=sg-09509afda3b4efc2a]
aws_instance.blue_server: Refreshing state... [id=i-0ce09bcece1110c69]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.load_balancer_server will be created
  + resource "aws_instance" "load_balancer_server" {....
....
  # aws_instance.yellow_server will be created
  + resource "aws_instance" "yellow_server" {
....
Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + load_balancer_ip = (known after apply)
  + yellow_server_ip = (known after apply)

─────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly
these actions if you run "terraform apply" now.
```
</details><br>


Проверяем вывод и если план соответсвует требуемой инфраструктуре, то применяем `terraform apply` и создаем инстансы:
<details>
<summary> <b>Вывод результата `terraform apply`</b></summary>

```bash
(netops) yarik@Innowise-work:terraform_learn_ec2$ terraform apply
aws_security_group.learn_ec2_sg: Refreshing state... [id=sg-09509afda3b4efc2a]
aws_instance.blue_server: Refreshing state... [id=i-0ce09bcece1110c69]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.load_balancer_server will be created
  + resource "aws_instance" "load_balancer_server" {
    ......

  # aws_instance.yellow_server will be created
  + resource "aws_instance" "yellow_server" {
    ......

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + load_balancer_ip = (known after apply)
  + yellow_server_ip = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_instance.yellow_server: Creating...
aws_instance.yellow_server: Still creating... [10s elapsed]
aws_instance.yellow_server: Creation complete after 13s [id=i-04c6e096554747642]
aws_instance.load_balancer_server: Creating...
aws_instance.load_balancer_server: Still creating... [12s elapsed]
aws_instance.load_balancer_server: Creation complete after 15s [id=i-0fedc9862320d4384]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

load_balancer_ip = "18.185.57.12"
yellow_server_ip = "3.69.30.75"

```
</details><br>

После проверяем созданную инфраструктуру:
`terraform state list` :

```bash
(netops) yarik@Innowise-work: terraform state list
aws_instance.blue_server
aws_instance.load_balancer_server
aws_instance.yellow_server
aws_security_group.learn_ec2_sg
```
И проверяем доступ к самим инстансам (заранее уже создан ssh-agent с ключом to_learn_ec2), например:
```bash
(netops) yarik@Innowise-work:terraform_learn_ec2$ ssh ubuntu@18.185.57.12
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-1018-aws x86_64)

 ....
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@ip-172-31-25-107:~$ 
```
После того как сервер `yellow_server` и `load_balancer_server` созданы, завершаем их настройку. Сервер `yellow_server` настраиваем аналогично `blue _server` из предыдущего пункта.

Проверка работы:
```bash
(netops) yarik@Innowise-work:terraform_learn_ec2$ curl http://3.69.30.75/ 
<html><body style="background-color:yellow;">Yellow Server</body></html>
```
Настройка `load_balancer_server` сервера по заданию должна обеспечить направление запросов на сервер с меньшим количеством подключений. Будем использовать алгоритм `least_conn` для балансировки на основе минимальных подключений.Для этого на сервере создадим файл `sudo nano /etc/nginx/nginx.conf` и отредактируем его:  
```bash
    events {}

    # назначение группы серверов как backend
    http {
        upstream backend {
            least_conn;
            server {public_ip or private_ip} max_fails=3 fail_timeout=10s;; # Blue server
            server {public_ip or private_ip} max_fails=3 fail_timeout=10s;; # Yellow server
            keepalive 32;
        }
        # настройка правил proxy
        server {
            listen 80;
            location / {
                proxy_pass http://backend;
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;;
            }
        }
    }
```
где `{public_ip or private_ip}` соответсвующие адреса web-серверов. 

Затем перезапускаем сервер `systemctl restart nginx` и проверяем работу: 

```bash
(netops) yarik@Innowise-work:terraform_learn_ec2$ curl http://18.185.57.12
<html><body style="background-color:blue;">Blue Server</body></html>
(netops) yarik@Innowise-work:terraform_learn_ec2$ curl http://18.185.57.12 
<html><body style="background-color:yellow;">Yellow Server</body></html>
(netops) yarik@Innowise-work:terraform_learn_ec2$ curl http://18.185.57.12 
<html><body style="background-color:blue;">Blue Server</body></html>
```
Балансировщик работает. 

UPD: Настройку сервера-балансировщика можно выполнять сразу при его создании, для это в конфигурацию балансировщика `resource "aws_instance" "load_balancer_server` в файле `main.tf` добавляем слeдующие строки:
```bash
cat > /etc/nginx/nginx.conf <<EOL
    events {}

    http {
        upstream backend {
            least_conn;
            server ${aws_instance.blue_server.private_ip}; # Blue server
            server ${aws_instance.yellow_server.private_ip}; # Yellow server
        }

        server {
        listen 80;
        location / {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          }
        }
    EOL
```
Теперь файл конфигурации будет создаваться автоматически и использовать `private_ip` при балансировке.



4. #### Point 4  
 #### Добавить в конфигурацию вывод логов, который будет показывать, куда проксируется запрос клиента.

Для этого нужно отредактировать файл `/etc/nginx/nginx.conf` добавил путь и собственный формат логов:

```bash
sudo nano /etc/nginx/nginx.conf
```
```bash
events {}

    http {
            log_format main '\$proxy_protocol_addr - \$remote_user [\$time_local] "\$request" '
                            '\$status \$body_bytes_sent "\$http_referer" '
                            '"\$http_user_agent" "\$http_x_forwarded_for" '
                            'to_backend=\$upstream_addr;';

            access_log /var/log/nginx/access.log main;

            upstream backend {
                least_conn;
                server ${aws_instance.blue_server.private_ip}; # Blue server
                server ${aws_instance.yellow_server.private_ip}; # Yellow server
            }

            server {
                listen 80;
                location / {
                    proxy_pass http://backend;
                    proxy_set_header Host \$host;
                    proxy_set_header X-Real-IP \$remote_addr;
                    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                    proxy_set_header X-Forwarded-Proto \$scheme;

                    access_log /var/log/nginx/proxy_access.log main;
                }
            }
        }

```
Перезапускаем сервер `sudo systemctl restart nginx` и проверяем работу обновив несколько раз страницу, смотрим лог:

```bash
ubuntu@ip-172-31-25-107:/var/log/nginx$ cat proxy_access.log
- - - [02/Jan/2025:18:23:20 +0000] "GET / HTTP/1.1" 200 69 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.30.89:80;
- - - [02/Jan/2025:18:23:21 +0000] "GET / HTTP/1.1" 200 73 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.74:80;
- - - [02/Jan/2025:18:23:22 +0000] "GET / HTTP/1.1" 200 69 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.30.89:80;
- - - [02/Jan/2025:18:25:00 +0000] "GET / HTTP/1.1" 200 73 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.74:80;
- - - [02/Jan/2025:18:25:00 +0000] "GET / HTTP/1.1" 200 69 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.30.89:80;
- - - [02/Jan/2025:18:25:01 +0000] "GET / HTTP/1.1" 200 73 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.74:80;
```
Видим запросы и адреса серверов!

В файле `main.tf` добавляем вышеуказанные строки и теперь файл конфигурации с указанием логирования будет создаваться автоматически. 

5. #### Point 5  
 #### Создать еще один сервер с сайтом и добавить его в конфигурацию как backup сервер.

Для этого добавим в main.tf конфигурацию еще одного сервера и отредактируем там же настройки сервера-балансировщика:

```hcl
...
# Backup Yellow Server
resource "aws_instance" "backup_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.learn_ec2_sg.id]


  tags = {
    Name = "backup_server"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt update && apt install -y nginx
    systemctl start nginx
    systemctl enable nginx
  EOF
}
...

# Load Balancer Server
resource "aws_instance" "load_balancer_server" {...
...
user_data = <<-EOF
    #!/bin/bash
    apt update && apt install -y nginx
    cat > /etc/nginx/nginx.conf <<EOL
    events {}

    http {
        .....
        upstream backend {...
        ...
        server ${aws_instance.backup_server.private_ip} backup; # Backup Yellow server

```
Применяем `terraform validate`, `terraform plan` и `terraform apply` и после провереям созданные ресурсы.

После того как сервер `backup_server` создан, настраиваем его аналогично `yellow_server` из предыдущего пункта.

Затем пересоздаем ``load_balancer_server` с новой конфигурацией:
```bash
terraform taint aws_instance.load_balancer_server
terraform apply
```
Проверяем работу  - выключаем (или делаем reboot) оба сервера `yellow_server` и `blue_server` и при обращении на адрес балансировщика в ответ получаем от `backup_server`.

<details>
<summary> <b>Смотрим лог </b></summary>

```bash
ubuntu@ip-172-31-24-236:~$ tail -n 30 /var/log/nginx/proxy_access.log
- - - [03/Jan/2025:14:33:22 +0000] "GET / HTTP/1.1" 200 73 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.74:80;
- - - [03/Jan/2025:14:33:23 +0000] "GET / HTTP/1.1" 200 69 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.30.89:80;
- - - [03/Jan/2025:14:33:25 +0000] "GET / HTTP/1.1" 200 73 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.74:80;
- - - [03/Jan/2025:14:33:26 +0000] "GET / HTTP/1.1" 200 69 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.30.89:80;
- - - [03/Jan/2025:14:33:27 +0000] "GET / HTTP/1.1" 200 73 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.74:80;
- - - [03/Jan/2025:14:33:47 +0000] "GET /cdn-cgi/trace HTTP/1.1" 404 162 "-" "Mozilla/5.0" "-" to_backend=172.31.30.89:80;
- - - [03/Jan/2025:14:40:54 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.74:80;
- - - [03/Jan/2025:14:40:55 +0000] "GET / HTTP/1.1" 200 69 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.30.89:80;
- - - [03/Jan/2025:14:40:56 +0000] "GET / HTTP/1.1" 200 73 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.74:80;
- - - [03/Jan/2025:14:40:58 +0000] "GET / HTTP/1.1" 200 69 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.30.89:80;
- - - [03/Jan/2025:14:40:59 +0000] "GET / HTTP/1.1" 200 73 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.74:80;
- - - [03/Jan/2025:14:41:34 +0000] "GET / HTTP/1.1" 200 75 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.30.89:80, 172.31.18.74:80, 172.31.18.206:80;
- - - [03/Jan/2025:14:41:35 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.206:80;
- - - [03/Jan/2025:14:41:36 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.206:80;
- - - [03/Jan/2025:14:41:37 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.206:80;
- - - [03/Jan/2025:14:41:37 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.206:80;
- - - [03/Jan/2025:14:41:38 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.206:80;
- - - [03/Jan/2025:14:41:39 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.206:80;
- - - [03/Jan/2025:14:41:40 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.206:80;
- - - [03/Jan/2025:14:41:40 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.206:80;
- - - [03/Jan/2025:14:41:41 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.206:80;
- - - [03/Jan/2025:14:41:43 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.206:80;
- - - [03/Jan/2025:14:41:43 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.206:80;
- - - [03/Jan/2025:14:41:44 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.206:80;
- - - [03/Jan/2025:14:41:47 +0000] "GET / HTTP/1.1" 499 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.74:80;
- - - [03/Jan/2025:14:41:56 +0000] "GET / HTTP/1.1" 200 75 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.74:80, 172.31.30.89:80, 172.31.18.206:80;
- - - [03/Jan/2025:14:42:22 +0000] "GET / HTTP/1.1" 200 69 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.30.89:80;
- - - [03/Jan/2025:14:42:23 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.30.89:80;
- - - [03/Jan/2025:14:42:24 +0000] "GET / HTTP/1.1" 200 73 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.18.74:80;
- - - [03/Jan/2025:14:42:25 +0000] "GET / HTTP/1.1" 200 69 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36" "-" to_backend=172.31.30.89:80;

```
</details><br>


6. #### Point 6  
 ####  Выгрузить конфиги в личный репозиторий на devops-gitlab.inno.ws.
