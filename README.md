# Данный проект:

### Готовит инфраструктуру с помощью `Terraform` и `Ansible` в `YC`:
- `Reverse Proxy` на основе `Nginx` и `Let`s Encrypt`.
- Кластер `MySQL`.
- Сайт на `WordPress`.
- Инстанс `Gitlab CE`.
- Инстанс `Gitlab Runner`.
- Мониторинг инфраструктуры с помощью: `Prometheus`, `Grafana` и `Alert Manager`.

### Для запуска необходимо:  
1. Завести учетную запись в `YC`.
2. Зарегистрировать домен, делегировать его на `ns1.yandexcloud.net` и `ns2.yandexcloud.net`. Имя домена поместить в переменную `fqdn` в файле `variables.tf`.
3. Создать облако. ID облака - в переменную `cloud_id` в файле `variables.tf`.
4. Создать каталог в облаке. ID каталога - в переменную `folder_id` в файле `variables.tf`.
5. Создать Object Storage (bucket). Добавить имя бакета в файл `backend.conf` `bucket = <your-bucket-name>`.
6. Создать сервисный аккаунт с ролью `editor`. Сгенерировать статический ключ доступа для этого аккаунта. ID и секрет ключа записать в соответствующие параметры в файл `backend.conf`: `access_key = <your-access-key>`, `secret_key = <your-secret-key>`.
7. Получить `OAuth token` в `YC`.
8. Создать workspace `stage`.
9. Сгенерировать `ssh-key` и поместить его в `~/.ssh/id_rsa`
  
### Запуск:
```bash
$ export TF_VAR_token=<OAuth token>
$ cd terraform
$ terraform init -backend-config=backend.conf
$ terraform workspace new stage
$ terraform plan
$ terraform apply
```

* Отдельно запустить playbook для `Gitlab Runner`:

```shell
$ ansible-playbook ./ansible/runner.yml -i ./ansible/inventory.yml -l run
```

- Перед запуском необходимо вписать переменную `gitlab_runner_registration_token` в файле `./ansible/roles/ansible-gitlab-runner/defaults/main.yml` (взять в gui gitlab в настройках CI/CD проекта).
- Также в gui gitlab в настройках CI/CD проекта нужно добавить переменную ssh-key (для доступа `runner` к серверу с `wordpress`).

### Возможные настройки:
1. Параметры создаваемых ВМ для workspace `stage`. Описаны в `hosts` в файле `variables.tf`.
2. Выставить `preemptible = false` в файле `compute.tf`, чтобы ВМ не отключались каждые 24 часа. По-умолчанию `true` для экономии ресурсов.
3. Выставить время ожидания поднятия ВМ в файле `ansible.tf` `command = "sleep <time>"`. Можно запускать Ansible часть вручную `ansible-playbook -i ./ansible/inventory.yml ./ansible/play.yml`, исключив этот файл.
4. Для отладочных целей использовать тестовые сертификаты Let's Encrypt, выставив `letsencrypt_staging: true` в `ansible/roles/nginx/defaults/main.yml`.
