provider "aws" {
  region = "eu-central-1"
}
module "test-task" {
  source = "./ec2"
  instance_type = "t2.micro"
  ami = "ami-07151644aeb34558a"
  grafana_port = 3000
  vpc_id = var.vpc_id
}