This is the starting point to install and configure MyFinance and all tools around.

### get started ###

If you want to create VMs automaticly with infrastructure as code you should use Terraform. Otherwise you have to provide a plain linux server manually for Ansible(fedora) and your target environment(ubuntu with microk8 installed). 
To configure the VMs with the needed Tools and applications we use Ansible.

#### prepare the server ####

install plain ubuntu-server with basic tools(Vi,snap(preinstalled for ubuntu 20)) and add the user:
- set the ip at the DHCP-Server to 192.168.100.73
- add a sudo user:
 adduser holger
 passwd holger
 usermod -aG wheel holger
- no pw required for sudo to enable ansible for sudo: sudo visudo -> add row: holger ALL=(ALL) NOPASSWD:ALL




#### configure the ansible host ####

install ansible on fedora:
- install a basic fedora linux
- add a sudo user:
 adduser holger
 passwd holger
 usermod -aG wheel holger
- install ansible:
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
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

### enable tekton trigger ###
Tekton server(your k8 ingress server) has to be available from the internet (http) and you must configure your repos in GitHub
Settings, then on Webhooks:
Payload URL is you internet URL
Content type: Change this to application/json.
Token: the password you have saved as k8 secret (see Role CICD-pipelines)

### get the argo cd init pw

get initpw to user admin with: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 �d

### setup sonar-projekts

go to https://sonarcloud.io/
- organisation myfinance -> administration -> projekt management -> analyse new projects: add all new projekts
-> the all projekts will be scanned after each commit, but you will get no feedback to your pipeline and you get no code coverage
-> projekt -> administration -> analysis methode -> other ci -> disable autiomatic analysis

### next step ###
For Production just install the helm-chart mfbundle




