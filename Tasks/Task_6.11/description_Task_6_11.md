#### Чекпоинты:

[1) Написать Terraform манифест для создания пользователей в определенных группах. Вывести ARN каждого пользователя и группы.](#point-1)
[2) Изменить манифест таким образом, чтобы один из пользователей входил в обе группы.](#point-2)
[3) Добавить группе Dev policy, которая дает возможность останавливать и стартовать EC2 instances, а к группе DevOps добавим policy `full access` к EC2 instances.](#point-3)
[4) Дополнительно зададим для пользователя `devops` возможность получения пароля и API-ключей на доступ в aws консоль и web, для остальных пользователей  - API-ключей. Выведем их в результаты `output` для одноразового просмотра.](#point-4)

---

### Point 1  
#### Написать Terraform манифест для создания пользователей в определенных группах.

Перед работой создадим в AWS аккаунт для работы с terraform и получим для него API-ключи доступа. Создадим на их основе еще один профиль в настройках `~/.aws/credentials` и будем его использовать при подключении к AWS. Или экспортируем переменные в текущий сеанс из файла .env при помощи скрипта [export_env.sh](tf/export_env.sh)

  - Создадим `main.tf` с общими ресурсами (провайдеры, профили и т.д.).
<details><summary>main.tf</summary>

```ini
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "terraform"
  region  = "us-west-2"
}
```
  - Определим переменные в `variables.tf`
```ini
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}
 
variable "user_names" {
  description = "List of IAM users to create"
  type        = list(string)
  default     = ["dev", "devops"]
}
```
</details><br>

  - Создадим `terraform.tfvars` для удобного управления переменными. Внесём значения - имена пользователей.
```ini
user_names = ["steve", "bob", "devops"]
```
  - Создадиим `resource.iam.tf` в котором будем определять IAM правила, пользователей и принадлежность группам (создадим две группы и внесем по умолчанию всех пользователей в группу `Dev`)
<details><summary>resource.iam.tf</summary>

```ini
resource "aws_iam_group" "dev" {
  name = "Dev"
}
resource "aws_iam_group" "devops" {
  name = "DevOps"
}

resource "aws_iam_user" "user" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

resource "aws_iam_user_group_membership" "user_group_membership" {
  count = length(var.user_names)
  user  = aws_iam_user.user[count.index].name

  groups = [aws_iam_group.dev.name]  
}
```
</details><br>

  - В `output.tf` добавим вывод ARN каждого пользователя, группы и их пренадлежность.
<details><summary>output.tf</summary>

```ini
output "iam_users" {
  description = "List of users"
  value       = aws_iam_user.user[*].name
}

output "user_arns" {
  description = "ARNs for IAM users"
  value = {
    # Loop through each user and get their ARN
    for user in aws_iam_user.user : user.name => user.arn
  }
}

output "iam_groups" {
  description = "List  of groups"
  value       = [aws_iam_group.dev.name, aws_iam_group.devops.name]
}

output "dev_group_arn" {
  description = "ARN for the Dev group"
  value = aws_iam_group.dev.arn
}

output "devops_group_arn" {
  description = "ARN for the DevOps group"
  value = aws_iam_group.devops.arn
}

output "devops_user_groups" {
  description = "List and ARNs of groups for devops user"
  value = {
    for idx, user in aws_iam_user.user : user.name => aws_iam_user_group_membership.user_group_membership[idx].groups
    if user.name == "devops"
  }
}

output "user_groups" {
  value = {
    for idx, user in aws_iam_user.user : 
    user.name => aws_iam_user_group_membership.user_group_membership[idx].groups
  }
}

```
</details><br>

- После создания манифестов инициализируем `terraform init`:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_6.11/tf$ terraform init 
Initializing the backend...
Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v4.67.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
- Валидируем конфигурацию `terraform validate`:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_6.11/tf$ terraform validate 
Success! The configuration is valid.
```
- Применяем  и валидируем `terraform plan`:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_6.11/tf$ terraform plan
Terraform used the selected providers to generate the following execution...
```
<details><summary>output terraform plan</summary>

```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_6.11/tf$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_iam_group.dev will be created
  + resource "aws_iam_group" "dev" {
      + arn       = (known after apply)
      + id        = (known after apply)
      + name      = "Dev"
      + path      = "/"
      + unique_id = (known after apply)
    }

  # aws_iam_group.devops will be created
  + resource "aws_iam_group" "devops" {
      + arn       = (known after apply)
      + id        = (known after apply)
      + name      = "DevOps"
      + path      = "/"
      + unique_id = (known after apply)
    }

  # aws_iam_user.user[0] will be created
  + resource "aws_iam_user" "user" {
      + arn           = (known after apply)
      + force_destroy = false
      + id            = (known after apply)
      + name          = "steve"
      + path          = "/"
      + tags_all      = (known after apply)
      + unique_id     = (known after apply)
    }

  # aws_iam_user.user[1] will be created
  + resource "aws_iam_user" "user" {
      + arn           = (known after apply)
      + force_destroy = false
      + id            = (known after apply)
      + name          = "bob"
      + path          = "/"
      + tags_all      = (known after apply)
      + unique_id     = (known after apply)
    }

  # aws_iam_user.user[2] will be created
  + resource "aws_iam_user" "user" {
      + arn           = (known after apply)
      + force_destroy = false
      + id            = (known after apply)
      + name          = "devops"
      + path          = "/"
      + tags_all      = (known after apply)
      + unique_id     = (known after apply)
    }

  # aws_iam_user_group_membership.user_group_membership[0] will be created
  + resource "aws_iam_user_group_membership" "user_group_membership" {
      + groups = [
          + "Dev",
        ]
      + id     = (known after apply)
      + user   = "steve"
    }

  # aws_iam_user_group_membership.user_group_membership[1] will be created
  + resource "aws_iam_user_group_membership" "user_group_membership" {
      + groups = [
          + "Dev",
        ]
      + id     = (known after apply)
      + user   = "bob"
    }

  # aws_iam_user_group_membership.user_group_membership[2] will be created
  + resource "aws_iam_user_group_membership" "user_group_membership" {
      + groups = [
          + "Dev",
        ]
      + id     = (known after apply)
      + user   = "devops"
    }

Plan: 8 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + dev_group_arn      = (known after apply)
  + devops_group_arn   = (known after apply)
  + devops_user_groups = {
      + devops = [
          + "Dev",
        ]
    }
  + iam_groups         = [
      + "Dev",
      + "DevOps",
    ]
  + iam_users          = [
      + "steve",
      + "bob",
      + "devops",
    ]
  + user_arns          = {
      + bob    = (known after apply)
      + devops = (known after apply)
      + steve  = (known after apply)
    }
  + user_groups        = {
      + bob    = [
          + "Dev",
        ]
      + devops = [
          + "Dev",
        ]
      + steve  = [
          + "Dev",
        ]
    }
```
</details><br>

- Проверяем вывод и если все ресурсы создаются как надо, то применяем `terraform apply` :
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_6.11/tf$ terraform apply

Terraform used the selected providers to generate the following execution plan....
```
<details><summary>output result of terraform apply</summary>

```bash
aws_iam_user.user[0]: Creating...
aws_iam_group.devops: Creating...
aws_iam_group.dev: Creating...
aws_iam_user.user[1]: Creating...
aws_iam_user.user[2]: Creating...
aws_iam_user.user[2]: Creation complete after 0s [id=devops]
aws_iam_user.user[1]: Creation complete after 0s [id=bob]
aws_iam_user.user[0]: Creation complete after 0s [id=steve]
aws_iam_group.dev: Creation complete after 0s [id=Dev]
aws_iam_group.devops: Creation complete after 0s [id=DevOps]
aws_iam_user_group_membership.user_group_membership[2]: Creating...
aws_iam_user_group_membership.user_group_membership[0]: Creating...
aws_iam_user_group_membership.user_group_membership[1]: Creating...
aws_iam_user_group_membership.user_group_membership[2]: Creation complete after 1s [id=terraform-20250212145150537000000002]
aws_iam_user_group_membership.user_group_membership[0]: Creation complete after 1s [id=terraform-20250212145150537000000001]
aws_iam_user_group_membership.user_group_membership[1]: Creation complete after 1s [id=terraform-20250212145150561700000003]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

dev_group_arn = "arn:aws:iam::**********:group/Dev"
devops_group_arn = "arn:aws:iam::**********:group/DevOps"
devops_user_groups = {
  "devops" = toset([
    "Dev",
  ])
}
iam_groups = [
  "Dev",
  "DevOps",
]
iam_users = [
  "steve",
  "bob",
  "devops",
]
user_arns = {
  "bob" = "arn:aws:iam::**********:user/bob"
  "devops" = "arn:aws:iam::**********:user/devops"
  "steve" = "arn:aws:iam::**********:user/steve"
}
user_groups = {
  "bob" = toset([
    "Dev",
  ])
  "devops" = toset([
    "Dev",
  ])
  "steve" = toset([
    "Dev",
  ])
}
```
</details><br>

Ресурсы созданы, валидировать можно через aws консоль cli или web:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ aws iam list-users
USERS   arn:aws:iam::**********:user/admin         2023-10-09T15:46:57+00:00       2025-02-12T07:41:06+00:00       /       *****************   admin
USERS   arn:aws:iam::**********:user/bob           2025-02-12T14:51:51+00:00               /       *********************   bob
USERS   arn:aws:iam::**********:user/devops        2025-02-12T14:51:51+00:00               /       *********************   devops
USERS   arn:aws:iam::**********:user/steve         2025-02-12T14:51:51+00:00               /       *****************   steve
USERS   arn:aws:iam::**********:user/terraform     2024-11-22T15:47:12+00:00               /       *****************   terraform
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ aws iam list-groups
GROUPS  arn:aws:iam::**********:group/admin   2023-10-09T15:43:24+00:00       *****************   admin   /
GROUPS  arn:aws:iam::**********:group/Dev     2025-02-12T14:51:51+00:00       *****************   Dev     /
GROUPS  arn:aws:iam::**********:group/DevOps  2025-02-12T14:51:51+00:00       *****************   DevOps  /
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_6.11/tf$ 

```
---

### Point 2  
#### Изменить манифест таким образом, чтобы один из пользователей входил в обе группы.

  - Добавим `devops` пользователя в группу `DevOps` (одновременно с группой `Dev`, по-умолчанию). Для этого изменим код в  `resource.iam.tf`, добавив и изменив строки:
```ini
resource "aws_iam_user_group_membership" "user_group_membership" {
  count = length(var.user_names)
  user  = aws_iam_user.user[count.index].name

  groups = concat(
    [aws_iam_group.dev.name], 
    var.user_names[count.index] == "devops" ? [aws_iam_group.devops.name] : []
  )
}
```

  - Применим эти изменения с помощью того же порядка действий - `terraform validate`, `terraform plan` ,`terraform apply`.
  
<details><summary>Полный вывод выполнения команд</summary>

```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_6.11/tf$ terraform validate
Success! The configuration is valid.
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_6.11/tf$ terraform plan
aws_iam_user.user[1]: Refreshing state... [id=bob]
aws_iam_group.dev: Refreshing state... [id=Dev]
aws_iam_user.user[0]: Refreshing state... [id=steve]
aws_iam_group.devops: Refreshing state... [id=DevOps]
aws_iam_user.user[2]: Refreshing state... [id=devops]
aws_iam_user_group_membership.user_group_membership[2]: Refreshing state... [id=terraform-20250212145150537000000002]
aws_iam_user_group_membership.user_group_membership[0]: Refreshing state... [id=terraform-20250212145150537000000001]
aws_iam_user_group_membership.user_group_membership[1]: Refreshing state... [id=terraform-20250212145150561700000003]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aws_iam_user_group_membership.user_group_membership[2] will be updated in-place
  ~ resource "aws_iam_user_group_membership" "user_group_membership" {
      ~ groups = [
          + "DevOps",
            # (1 unchanged element hidden)
        ]
        id     = "terraform-20250212145150537000000002"
        # (1 unchanged attribute hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.

Changes to Outputs:
  ~ devops_user_groups = {
      ~ devops = [
            "Dev",
          + "DevOps",
        ]
    }
  ~ user_groups        = {
      ~ devops = [
            "Dev",
          + "DevOps",
        ]
        # (2 unchanged attributes hidden)
    }

yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_6.11/tf$ terraform apply
aws_iam_user.user[1]: Refreshing state... [id=bob]
aws_iam_group.dev: Refreshing state... [id=Dev]
aws_iam_user.user[2]: Refreshing state... [id=devops]
aws_iam_user.user[0]: Refreshing state... [id=steve]
aws_iam_group.devops: Refreshing state... [id=DevOps]

aws_iam_user_group_membership.user_group_membership[2]: Modifying... [id=terraform-20250212145150537000000002]
aws_iam_user_group_membership.user_group_membership[2]: Modifications complete after 1s [id=terraform-20250212145150537000000002]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

dev_group_arn = "arn:aws:iam::**********:group/Dev"
devops_group_arn = "arn:aws:iam::**********:group/DevOps"
devops_user_groups = {
  "devops" = toset([
    "Dev",
    "DevOps",
  ])
}
iam_groups = [
  "Dev",
  "DevOps",
]
iam_users = [
  "steve",
  "bob",
  "devops",
]
user_arns = {
  "bob" = "arn:aws:iam::**********:user/bob"
  "devops" = "arn:aws:iam::**********:user/devops"
  "steve" = "arn:aws:iam::**********:user/steve"
}
user_groups = {
  "bob" = toset([
    "Dev",
  ])
  "devops" = toset([
    "Dev",
    "DevOps",
  ])
  "steve" = toset([
    "Dev",
  ])
}

```
</details><br>

- Ресурсы обновились, проверяем принадлежность пользователя `devops` к группам еще раз через aws cli:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_6.11/tf$ aws iam list-groups-for-user --user-name devops
GROUPS  arn:aws:iam::*************:group/DevOps  2025-02-12T14:51:51+00:00       AAAAAAAAAAAAAAAAAAAAA   DevOps  /
GROUPS  arn:aws:iam::*************:group/Dev     2025-02-12T14:51:51+00:00       AAAAAAAAAAAAAAAAAAAAA   Dev     /
```
---

### Point 3  
#### Добавить группе Dev policy, которая дает возможность останавливать и стартовать EC2 instances, а к группе DevOps добавим policy `full access` к EC2 instances.

  - Создадим в файле `resource.iam.tf` IAM policy с соответствующими разрешениями для `Start/Stop Instances` и добавим встроенную policy `AmazonEC2FullAccess`. Присвоим их ресурсам (группам) через `aws_iam_policy_attachment`:
```ini
resource "aws_iam_policy" "dev_ec2_control" {
  name        = "DevEC2Control"
  description = "Policy to allow Dev group to start and stop EC2 instances"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "dev_ec2_control" {
  group      = aws_iam_group.dev.name
  policy_arn = aws_iam_policy.dev_ec2_control.arn
}

resource "aws_iam_group_policy_attachment" "devops_full_access" {
  group      = aws_iam_group.devops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

```
- Применим эти изменения с помощью того же порядка действий - `terraform validate`, `terraform plan` ,`terraform apply`.
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_6.11/tf$ terraform apply
...
aws_iam_group_policy_attachment.devops_full_access: Creating...
aws_iam_policy.dev_ec2_control: Creating...
aws_iam_group_policy_attachment.devops_full_access: Creation complete after 1s [id=DevOps-20250212154128605500000001]
aws_iam_policy.dev_ec2_control: Creation complete after 1s [id=arn:aws:iam::496972778193:policy/DevEC2Control]
aws_iam_group_policy_attachment.dev_ec2_control: Creating...
aws_iam_group_policy_attachment.dev_ec2_control: Creation complete after 0s [id=Dev-20250212154129194100000002]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```
- И валидируем эти изменения через aws cli:
```bash 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ aws iam list-attached-group-policies --group-name DevOps
ATTACHEDPOLICIES        arn:aws:iam::aws:policy/AmazonEC2FullAccess     AmazonEC2FullAccess
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ aws iam list-attached-group-policies --group-name Dev
ATTACHEDPOLICIES        arn:aws:iam::*************:policy/DevEC2Control  DevEC2Control
```

### Point 4  
#### Дополнительно зададим для пользователя `devops` возможность получения пароля и API-ключей на доступ в aws консоль и web, для остальных пользователей  - API-ключей. Выведем их в результаты `output` для одноразового просмотра. Назначим смену пароля при первоначальном входе пользователя `devops (добавим для этого policy пользователю).

- Для этого добавим в `resource.iam.tf` следующее:
```ini

# Create API-keys for all users
resource "aws_iam_access_key" "user_keys" {
  count = length(var.user_names)
  user  = aws_iam_user.user[count.index].name
}

# Create passsword for user 'devops'
resource "aws_iam_user_login_profile" "devops_password" {
  count = contains(var.user_names, "devops") ? 1 : 0

  user                    = aws_iam_user.user[index(var.user_names, "devops")].name
  password_length         = 16
  password_reset_required = true

  lifecycle {
    ignore_changes = [password_length, password_reset_required]
  }

  depends_on = [aws_iam_user.user]
}

# Attach policy for changing password
resource "aws_iam_user_policy_attachment" "change_password" {
  user       = aws_iam_user.user[index(var.user_names, "devops")].name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}


```
- И добавим в `output.tf` единоразовый вывод ключей и пароля:
```ini
# Show API-keys (just first apply)
output "iam_access_keys" {
  description = "AWS access keys for IAM users (shown only on first apply)"
  sensitive   = true
  value = {
    for idx, user in aws_iam_user.user :
    user.name => {
      access_key = aws_iam_access_key.user_keys[idx].id
      secret_key = aws_iam_access_key.user_keys[idx].secret
    }
  }
}

# Show devops password
output "devops_password" {
  description = "Temporary login password for devops user (requires reset on first login)"
  sensitive   = true
  value = contains(var.user_names, "devops") ? aws_iam_user_login_profile.devops_password[0].password : null
}
```
- Применим эти изменения с помощью того же порядка действий - `terraform validate`, `terraform plan` ,`terraform apply`.
<details><summary>Полный вывод выполнения команды terraform apply </summary>

```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee$ terraform apply
....
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

dev_group_arn = "arn:aws:iam::496972778193:group/Dev"
devops_group_arn = "arn:aws:iam::496972778193:group/DevOps"
devops_password = <sensitive>
devops_user_groups = {
  "devops" = toset([
    "Dev",
    "DevOps",
  ])
}
iam_access_keys = <sensitive>
iam_groups = [
  "Dev",
  "DevOps",
]
iam_users = [
  "steve",
  "bob",
  "devops",
]
user_arns = {
  "bob" = "arn:aws:iam::496972778193:user/bob"
  "devops" = "arn:aws:iam::496972778193:user/devops"
  "steve" = "arn:aws:iam::496972778193:user/steve"
}
user_groups = {
  "bob" = toset([
    "Dev",
  ])
  "devops" = toset([
    "Dev",
    "DevOps",
  ])
  "steve" = toset([
    "Dev",
  ])
}
```
</details><br>

- Обращаем внимание на `iam_access_keys = <sensitive> и devops_password = <sensitive>` это значит, что значения скрыты в выводе, и получить их можно через команды - `terraform output iam_access_keys` и `terraform output devops_password` соответственно:
```bash
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_6.11/tf$ terraform output iam_access_keys

{
  "bob" = {
    "access_key" = "AK*****************GH"
    "secret_key" = "jqp####################################jJ+"
  }
  "devops" = {
    "access_key" = "AK*****************3P"
    "secret_key" = "MQa#####################################VR"
  }
  "steve" = {
    "access_key" = "AK*****************H2"
    "secret_key" = "6i######################################dv"
  }
}
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_6.11/tf$ 
yarik@Innowise-work:/mnt/c/Users/user/DEVOPS_TRAINEE/DevOps-Trainee/Tasks/Task_6.11/tf$ terraform output devops_password
"ADC12345"

```
Эти значения сохраняем и передаем пользователям (для пароля будет запрошена смена пароль при первом входе), остальные API-ключи можно использовать для подключения к aws cli консоли.  


---

**Итоговые конфигурационные файлы и манифесты здесь:**

  - [main.tf](tf/main.tf) с общими ресурсами (провайдеры, профили и т.д.).
  - [variables.tf](tf/variables.tf) - переменные
  - [terraform.tfvars](tf/terraform.tfvars) - значения переменных
  - [resource.iam.tf](tf/resource.iam.tf) - IAM правила пользователей и принадлежность к группам.
  - [output.tf](tf/output.tf)  вывод для каждого пользователя, группы и их пренадлежность.
