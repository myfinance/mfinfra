This is the starting point to install and configure MyFinance and all tools around.

### get started ###

If you want to create VMs automaticly with infrastructure as code you should use Terraform. Otherwise you have to provide a plain linux server manually for each stage (dev, test and prod). 
To configure the VMs with the needed Tools and applications we use Ansible.
For both tools you need a plain linux server as host(only centos is described and tested). 



#### setup terraform ####

to use terraform and VM-ware you need vsphere. ESXI is not working easily with terraform because you have no templates. The only way with ESXI is to copy the vmdk file (harddisk) which costs a lot of io. Vsphere is not for free!

install Terraform:
curl https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip --output terraform.zip
install unzip: 
yum install unzip 
unzip terraform.zip
move the resulting executable (terraform) to the path (see echo $PATH) e.g. /usr/local/bin:
mv terraform /usr/local/bin

for further steps: https://blog.inkubate.io/create-a-centos-7-terraform-template-for-vmware-vsphere/


#### configure the server ####

install ansible on centos:
yum install ansible
create .vault_prod in homedir with the vault-passwort - to use the encrypted passwords which are checked-in in the repository(root dir but not visible) you need the password from my keepass-file ;) if you can not get it recreate all secrets with your vault-password  ansible-vault encrypt_string --vault-id prod@~/.vault_prod 'thepasswaord' --name 'variable-name'
update the inventory-file with your IPs to a kubernetes(kuberneteshost) and a development server(devenv) (both minimal CentOS setups) doc/install/ansible/environments/prod
copy playbook from doc/install/ansible to ansible host or mount an nfs-share with the playbooks (add a row in the file /etc/fstab <code><ip>://<path> /mnt/data nfs rw 0 0</code>) Achtung dazu muss auch nfs-utils installiert sein mit sudo yum install nfs-utils
prepare passwordless communication from ansible host to the servers:
ssh-keygen -t rsa  //public und private key auf ansible host erzeugen
for all servers: ssh-copy-id root@<your_ip> // public key auf die clients kopieren
//inventory anlegen
[buildserver]
<yourhostname> ansible_host=<your_ip> ansible_ssh_user=root
//verbindungstest
ansible all -m ping 
at least python has to be installed at the ansible client 

configure kubernetes and devenv-server: ansible-playbook site.yml --vault-id prod@~/.vault_prod


### next step ###
For development install myjenkins and build and deploy all other projects with jenkins
Fro Production just install the helm-chart mfbundle


