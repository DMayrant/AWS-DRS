# Disaster Recovery Service DRS ☁️
This project focuses on replicating a nginx server from us-east-1 (Virginia) --> ap-southeast-1 (Singapore) using a Pilot Light DR plan using AWS Elastic Disaster Recovery

Disaster Recovery (DR) as four plans

The selecting the correct DR plan is crucial and it depends on your workload / organization RTO/RPO

RTO = How much downtime is allowed for a workload or organization

RPO = How much data loss is allowed for your workload or organization

- Backup and Restore
- Pilot Light
- Warm standby
- Active-Active

AWS Elastic disaster recovery service is used for Pilot Light DR plan. This service is for continuous block level replication of your VMs and servers. In pilot light DR plan, your workload infrastructure and data are replicated in another region while compute services are turned off. 

# Terraform 🏗️
```bash
terraform init 
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
``` 
# Initialize DRS service in Target Region 🗺️
before install agent on source service
```bash
aws drs initialize-service \
--region ap-southeast-1

aws drs describe-replication-configuration-templates \
--region ap-southeast-1
  ```

# Nginx Server Install 🖥️
```bash
sudo dnf update
dnf install -y nginx
systemctl enable nginx
systemctl start nginx
systemctl status nginx

curl http://localhost
curl -I https://aws.amazon.com
```

# Verify Kernel prerequisites
```bash
uname -r
rpm -qa | grep kernel
df -h /
df -h /tmp
which gcc
which make
```


# DRS Agent Install 💿
```bash
sudo dnf install -y gcc make
sudo dnf install -y kernel-devel-$(uname -r)

cd /tmp

wget -O aws-replication-installer-init \
https://aws-elastic-disaster-recovery-us-east-1.s3.us-east-1.amazonaws.com/latest/linux/aws-replication-installer-init

chmod +x aws-replication-installer-init

sudo ./aws-replication-installer-init
```
# Initialize the DRS agent 🕵🏾‍♂️
```bash 
./aws-replication-installer-init --region ap-southeast-1
```