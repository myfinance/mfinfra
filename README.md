This is the starting point to install and configure MyFinance and all tools around.

### get started ###

install ansible on centos:
yum install ansible
create .vault_prod in homedir with the vault-passwort - to use the encrypted passwords which are checked-in in the repository(root dir but not visible) you need the password from my keepass-file ;) if you can not get it recreate all secrets with your vault-password  ansible-vault encrypt_string --vault-id prod@~/.vault_prod 'thepasswaord' --name 'variable-name'
update the inventory-file with your IPs to a kubernetes(kuberneteshost) and a development server(devenv) (both minimal CentOS setups) doc/install/ansible/environments/prod
login via ssh from ansible-host to myfinance-server to create private key
copy playbook from doc/install/ansible to ansible host or mount an nfs-share with the playbooks (add a row in the file /etc/fstab <code><ip>://<path> /mnt/data nfs rw 0 0</code>) Achtung dazu muss auch nfs-utils installiert sein mit sudo yum install nfs-utils
prepare passwordless communication from ansible host to myfinanceserver "ssh-keygen -t rsa" ssh-copy-id "user@<your_ip>"
at least python has to be installed at the ansible client 


configure kubernetes and devenv-server: ansible-playbook site.yml --vault-id prod@~/.vault_prod


