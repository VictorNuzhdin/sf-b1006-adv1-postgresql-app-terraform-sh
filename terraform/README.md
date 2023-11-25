# sf-b1006-pr-adv1-postgresql-app-terraform-sh
For Skill Factory study project (B10, PR. Advanced1: Terraform + Shell Scripting) :: Terraform

<br>


### Terraform Configuration

```bash
#00 :: Select "terraform" directory
$ cd terraform

#01 :: Create auth token (with 12 hours lifetime) -- configured "yc" tool is required
$ export TF_VAR_yc_token=$(yc iam create-token) && echo $TF_VAR_yc_token

#02 :: Check configuration, Build/Rebuild execution plan and Create/Recreate Cloud Resources
$ terraform validate
$ terraform plan
$ terraform apply -auto-approve
..or
$ terraform validate && terraform plan && terraform apply -auto-approve
..or
$ terraform destroy -auto-approve && terraform validate && terraform plan && terraform apply -auto-approve
..or
$ terraform destroy -target=yandex_compute_instance.vm1 -auto-approve && terraform validate && terraform plan -target=yandex_compute_instance.vm1 && terraform apply -target=yandex_compute_instance.vm1 -auto-approve
$ terraform destroy -target=yandex_compute_instance.vm2 -auto-approve && terraform validate && terraform plan -target=yandex_compute_instance.vm2 && terraform apply -target=yandex_compute_instance.vm2 -auto-approve

#03 :: Destroy cloud resources if they are not needed
$ terraform destroy -auto-approve

```
<br>
