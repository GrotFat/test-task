# Artem Herbovnyk | Trainee DevOps Test Task
Example of terraform module to setup EC2 instance with public static IP and Grafana docker image

Standard commands to run terraform module
```bash
terraform init
terraform plan
terraform apply
```
After this the module will generate an ssh private key and save it locally

As an output, you will receive link to Grafana dashboard (default creds)

Here is link to my Grafana with custom dashboard http://3.64.189.95:3000/d/d57fb40a-3ebc-497f-9d69-aacbce06f724/custom-dashboard?orgId=1