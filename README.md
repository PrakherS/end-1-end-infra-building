# Infrastructure and Application building
Using Terraform, Ansible, Flask, Cloud Computing and other related tech

# Everything in one server instance:
- ML Application: Sentiment based product recommendation system
- Container Runtime: docker
- Containerization Application: ML App
- Web pp: Flask based

# Infrastructure
- Tenancy
- Compartment
- Security Policy
- VPC
- Subnets
- Internet Gateway
- Security Groups
- VMs

# Ansible
- Manage configuration

# Pipeline
- NA. Run from local

=================

# Running a Flask application on the server

- Clone the repo (`yum install git -y`)
- Install python and pip (`yum install python3 python3-pip`)
- need to create venv and use venv (`python3 -m venv venv` & `source venv/bin/activate`)
- install required packages (`pip install -r requirements.txt`)
- run the application (`nohup gunicorn -b 0.0.0.0:8000 app:app &`)
- Access the application via browser (`http://34.243.190.60:8000/`)

==================

# Running ansible playbook
`ansible-playbook installation/installation.yaml`
`ansible-playbook installation/docker-install.yaml`

### Installed pipx
```
python -m pip install --user pipx
C:\Users\praks\AppData\Roaming\Python\Python3x\Scripts\pipx.exe ensurepath
```

### Installed ansible via pipx
```
pipx install --include-deps ansible
```

### Store Token Securly:
```
ansible-vault encrypt_string 'ghp_xxxxxxxxxx' --name 'git_token'
```

Once done, store the output as is in a `vars/secret.yaml` file

Include file in the playbook and use the variable in the code
```
vars_files:
    - vars/vault.yaml
```

Ansible commands were not working in wondows. Installed WSL:
```
wsl --install
wsl -d Ubuntu
```


# Troubleshooting Ansible Playbook run
```
ansible --version
ansible [core 2.16.3]
  config file = None
  configured module search path = ['/home/prakh/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/prakh/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.12.3 (main, Jun 18 2025, 17:59:45) [GCC 13.3.0] (/usr/bin/python3)
  jinja version = 3.1.2
  libyaml = True
```

### Setting ansible config file:
```
# View active file
ansible --version

# Search order:
ANSIBLE_CONFIG: An environment variable pointing to a specific file.
./ansible.cfg: A file in the current directory.
~/.ansible.cfg: A file in the user's home directory.
/etc/ansible/ansible.cfg: The default system-wide configuration file

# To Set Env variable:
export ANSIBLE_CONFIG=/path/to/my/ansible.cfg

```

### Important command:
```
   16  ansible-vault encrypt_string 'ssssss' --name 'test'
   73  ansible-playbook -i inventory.yaml app-install-playbook.yaml
   93  ansible-config dump --only-changed
   93  ansible-config dump --only-changed | grep INVENTORY
   94  ansible-inventory -i inventory.yaml --list -y
```
