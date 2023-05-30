variable "instance_type" {
  description = "The EC2 instance type."
}

variable "ami" {
  description = "The AMI ID for the EC2 instance."
}

variable "grafana_port" {
  description = "The port to expose Grafana."
}
variable "vpc_id" {
  description = "The vpc id for your instance"
}