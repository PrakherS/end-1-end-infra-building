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
