resource "aws_key_pair" "TERRAFORM_KEY" {
  key_name   = "terraform-key"
  public_key = file("./ssh-keys/terraform-key.pub")
}

resource "aws_instance" "terraform-instance" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = var.INSTANCE_TYPE
  availability_zone      = var.ZONE1
  key_name               = aws_key_pair.TERRAFORM_KEY.key_name
  vpc_security_group_ids = var.VPC_SEC_GROUP_IDS
  tags = {
    "Name"    = "terraform-instance"
    "Project" = "Terraform"
  }
}
