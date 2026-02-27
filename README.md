# mf infrastructure

This is the starting point for all my infrastructure

## get started

go to /bootstrap and replace tbd passwords and tokens with real ones (my are in a keepass vault)
run install_local_env.sh
restore database(backup from projekte/hardware)
cat backup.sql | docker exec -i bootstrap-postgres-1 psql -U semaphore -d semaphore

go to <http://localhost:3000>

### configure semaphore

if no db backup is available go to go to <http://localhost:3000>
create a project
add the repository (link to a git repository with the ansible code, if public use credentials none)

add inventory:

``` json
all:
  hosts:
    sophos_fw:
      ansible_host: 192.168.100.1  # Your Firewall IP
```

add variable group

``` json
{
  "ansible_user": "admin",
  "ansible_httpapi_port": 4444,
  "ansible_httpapi_use_ssl": true,
  "ansible_httpapi_validate_certs": false
}
```

add variable groups-secret:ansible_password

### activate CI/CD

#### enable tekton trigger

Tekton server(your k8 ingress server) has to be available from the internet (http) and you must configure your repos in GitHub
Settings, then on Webhooks:
Payload URL is you internet URL
Content type: Change this to application/json.
Token: the password you have saved as k8 secret (see Role CICD-pipelines)

#### get the argo cd init pw

get initpw to user admin with: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 �d

#### setup sonar-projekts

go to <https://sonarcloud.io/>

- organisation myfinance -> administration -> projekt management -> analyse new projects: add all new projekts
-> the all projekts will be scanned after each commit, but you will get no feedback to your pipeline and you get no code coverage
-> projekt -> administration -> analysis methode -> other ci -> disable autiomatic analysis

## backup database

docker exec bootstrap-postgres-1 pg_dump -U semaphore -d semaphore > semaphore_backup_$(date +%Y%m%d).sql
bootstrap-postgres-1 is the containername, please  check with "docker ps" command and adjust if necessary

## ansible

### add a new galaxy module

add the galaxy modules to requirements.yml
if a galaxy module have further dependencies e.g. installpackages like a python module:
add it to bootstrap/requirements.txt and run install_local_env to update the semaphore container

### configure the ansible host(only necessary if you do not use semaphore)

install ansible on fedora:

- install a basic fedora linux
- add a sudo user:
 adduser holger
 passwd holger
 usermod -aG wheel holger
- install ansible:
curl <https://bootstrap.pypa.io/get-pip.py> -o get-pip.py
python3 get-pip.py --user
python3 -m pip install --user ansible
ansible-galaxy collection install kubernetes.core

create .vault_prod in homedir with the vault-passwort - to use the encrypted passwords which are checked-in in the repository(root dir but not visible) you need the password from my keepass-file ;) if you can not get it recreate all secrets with your vault-password  ansible-vault encrypt_string --vault-id prod@~/.vault_prod 'thepasswaord' --name 'variable-name'
update the inventory-file with your IPs to a kubernetes(kuberneteshost) environments/prod
copy playbook from doc/install/ansible to ansible host or mount an nfs-share with the playbooks:

- add nfs share for the repo:
  sudo dnf install -y nfs-utils
  edit /etc/fstab and add: 192.168.100.6://volume1/nfsshare /mnt/data nfs defaults 0 0
  -add link in user home:
  ln -s /mnt/data/repo/mfinfra/ ~/ansibleWorkdir

prepare passwordless communication from ansible host to the servers:
ssh-keygen -t rsa  //public und private key auf ansible host erzeugen
for all servers: ssh-copy-id user@<your_ip> // public key auf die clients kopieren

//verbindungstest
ansible all -m ping

configure server: ansible-playbook site.yml --vault-id prod@~/.vault_prod

