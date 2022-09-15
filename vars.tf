variable "REGION" {
  default = "us-east-1"
}

variable "ZONE1" {
  default = "us-east-1a"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-1 = "ami-052efd3df9dad4825"
    us-east-2 = "ami-02f3416038bdb17fb"
  }
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "KEY_NAME" {
  default = "terraform-key"
}

variable "VPC_SEC_GROUP_IDS" {
  default = ["sg-09942af026876a201"]
}
