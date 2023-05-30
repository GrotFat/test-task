# Artem Herbovnyk | Trainee DevOps Test Task
Example of terraform module to setup EC2 instance with public static IP and Grafana docker image

AWS creds are consumed from env variables

Standard commands to run terraform module
```bash
terraform init
terraform plan
terraform apply
```
VPC ID is consumed as variable

After this the module will generate an ssh private key and save it locally

As an output, you will receive link to Grafana dashboard (default creds)

Here is link to my Grafana with custom dashboard http://3.77.241.181:3000/d/e83f1789-5f52-421f-b24a-74b044418b8d/custom-dashboard?orgId=1