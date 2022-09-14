resource "aws_instance" "intro" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = var.INSTANCE_TYPE
  availability_zone      = var.ZONE1
  key_name               = var.KEY_NAME
  vpc_security_group_ids = var.VPC_SEC_GROUP_IDS
  tags = {
    "Name"    = "terraform-instance"
    "Project" = "Terraform"
  }
}
