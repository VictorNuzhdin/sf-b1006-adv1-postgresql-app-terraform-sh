# sf-b1006-pr-adv1-postgresql-app-terraform-sh
For Skill Factory study project (B10, PR. Advanced1: Terraform + Shell Scripting)

<br>

### Quick Info

```bash
#Descriptiion
Terraform IaC конфигурация для развертывания в облаке Yandex Cloud тестового стенда из x2 ВМ на основе:
- Ubuntu 18.04 (Bionic Beaver)
- PostgreSQL v8.4 Server
- PostgreSQL v8.4 Client (Python WepApp)
* настройка производилась с помощью классических Bash скриптов (Ansible или аналогичные инструменты не применялись)
* Docker и Docker Compose не применялись

#Links
Terraform by HashiCorp :: IaC tool
https://en.wikipedia.org/wiki/Terraform_(software)
https://ru.wikipedia.org/wiki/Terraform
https://www.terraform.io/

Yandex Cloud by Yandex :: Cloud Provider
https://cloud.yandex.com/en-ru/

PostgreSQL :: Relational Database Management System (RDMS)
https://en.wikipedia.org/wiki/PostgreSQL
https://www.postgresql.org/

Python :: programming language
https://en.wikipedia.org/wiki/Python_(programming_language)
https://ru.wikipedia.org/wiki/Python
https://www.python.org/

Python Flask :: Web Applications Framework
https://en.wikipedia.org/wiki/Flask_(web_framework)
https://ru.wikipedia.org/wiki/Flask_(веб-фреймворк)
https://flask.palletsprojects.com/en/3.0.x/

Python Django :: Web Applications Framework
https://en.wikipedia.org/wiki/Django_(web_framework)
https://ru.wikipedia.org/wiki/Django
https://www.djangoproject.com/

```
<br>

### Quick UserGuide

```bash
##--Terrafrom

#00.1 :: Select "terraform" directory
$ cd terraform

#00.2 :: Retrieve new auth token from Cloud (configured "yc" tool is required)
$ export TF_VAR_yc_token=$(yc iam create-token) && echo $TF_VAR_yc_token

#00.3 :: Check configuration, Build/Rebuild execution plan and Create/Recreate Cloud resources
$ terraform validate
$ terraform plan
$ terraform apply -auto-approve
..or
$ terraform validate && terraform plan && terraform apply -auto-approve
..or
$ terraform destroy -auto-approve && terraform validate && terraform plan && terraform apply -auto-approve

        Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
        Outputs:
        vm1_info = "u181 | 10.0.20.10 | 158.160.8.114"
        vm2_info = "u182 | 10.0.20.11 | 158.160.25.74"

#00.4 :: Check site home pages of created cloud hosts with your preferred web browser
#
http://158.160.8.114    ## Welcome to [vm1.dotspace.ru] (PostgreSQL: Server)
http://158.160.25.74    ## Welcome to [vm2.dotspace.ru] (PostgreSQL: Client WebApp)

$ curl -s http://vm1.dotspace.ru | grep "<title>"    ## <title>Welcome | vm1.dotspace.ru</title>
$ curl -s http://vm2.dotspace.ru | grep "<title>"    ## <title>Welcome | vm2.dotspace.ru</title>

#00.5 :: Destroy cloud resources if they are not needed
$ terraform destroy -auto-approve


##--VM1 :: PostgreSQL Server Host

#01.1 :: Checking Nginx Service status and configuration
$ nginx -v

        nginx version: nginx/1.14.0 (Ubuntu)

$ sudo systemctl status nginx | grep Active | awk '{$1=$1;print}'

        Active: active (running) since Sat 2023-11-25 20:42:55 +06; 1h 6min ago

$ ls -1X /etc/nginx/sites-available/

        default_backup
        vm1.dotspace.ru

$ ls -la /etc/nginx/sites-enabled/

        vm1.dotspace.ru -> /etc/nginx/sites-available/vm1.dotspace.ru

$ cat /etc/nginx/sites-available/vm1.dotspace.ru

        server {
            listen 80 default_server;

            root /var/www/vm1.dotspace.ru/html;
            index index.html;

            server_name vm1.dotspace.ru;

            location / {
                try_files $uri $uri/ =404;
            }
        }

#01.2 :: Checking VM2 website by domain name
$ curl -s http://vm2.dotspace.ru | grep "<title>"    ## <title>Welcome | vm2.dotspace.ru</title>



##--VM2 :: PostgreSQL Client Host

#02.1 :: Checking Nginx Service status and configuration
$ nginx -v

        nginx version: nginx/1.14.0 (Ubuntu)

$ sudo systemctl status nginx | grep Active | awk '{$1=$1;print}'

        Active: active (running) since Sat 2023-11-25 20:43:08 +06; 1h 7min ago

$ ls -1X /etc/nginx/sites-available/

        default_backup
        vm2.dotspace.ru

$ ls -la /etc/nginx/sites-enabled/

        vm2.dotspace.ru -> /etc/nginx/sites-available/vm2.dotspace.ru

$ cat /etc/nginx/sites-available/vm2.dotspace.ru

        server {
            listen 80 default_server;

            root /var/www/vm2.dotspace.ru/html;
            index index.html;

            server_name vm2.dotspace.ru;

            location / {
                try_files $uri $uri/ =404;
            }
        }

#02.2 :: Checking VM1 website by domain name
$ curl -s http://vm1.dotspace.ru | grep "<title>"    ## <title>Welcome | vm1.dotspace.ru</title>

```
<br>

### Changelog (newest first)

```bash
2023.11.26 :: Реализована работа с Сервисом FreeDNS (теперь к ВМ есть доступ по доменным именам)
2023.11.25 :: Реализована базовая Terraform конфигурация которая создает x2 ВМ:
              1. VM1: Ubuntu 18.04 (Bionic Beaver), Nginx 1.14.0, простой вебсайт
              2. VM2: Ubuntu 18.04 (Bionic Beaver), Nginx 1.14.0, простой вебсайт

```
<br>

### Screens

02.1: VM1 [vm1.dotspace.ru] Home Page <br>
![screen](_screens/step02__vm1__homepage.png?raw=true)
<br>

02.2: VM2 [vm2.dotspace.ru] Home Page <br>
![screen](_screens/step02__vm2__homepage.png?raw=true)
<br>

01.1: VM1 [158.160.8.114] Home Page <br>
![screen](_screens/step01__vm1__homepage.png?raw=true)
<br>

01.2: VM2 [158.160.25.74] Home Page <br>
![screen](_screens/step01__vm2__homepage.png?raw=true)
<br>
