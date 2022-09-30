# SSH Key
# Provides an EC2 key pair resource.
# A key pair is used to control login access to EC2 instances.
resource "aws_key_pair" "terraform-key" {
  key_name   = "terraform-key"
  public_key = file(var.SSH-KEY_PUBLIC)

  tags = {
    Name    = "terraform-key"
    Project = "Terraform"
  }
}

# VPC (Virtual Private Cloud)
# Provides a VPC resource.
resource "aws_vpc" "terraform-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name    = "terraform-vpc"
    Project = "Terraform"
  }
}

# Internet Gateway
# Provides a resource to create a VPC Internet Gateway.
resource "aws_internet_gateway" "terraform-gateway" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = {
    Name    = "terraform-gateway"
    Project = "Terraform"
  }
}

# Custom Route Table
# Provides a resource to create a VPC routing table.
resource "aws_route_table" "terraform-route_table" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-gateway.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.terraform-gateway.id
  }

  tags = {
    Name    = "terraform-route_table"
    Project = "Terraform"
  }
}

# Subnet
# Provides an VPC subnet resource.
resource "aws_subnet" "terraform-subnet" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.ZONE1

  tags = {
    Name    = "terraform-subnet"
    Project = "Terraform"
  }
}

# Route Table Association
# Provides a resource to create an association between a route table and a 
# subnet or a route table and an internet gateway or virtual private gateway.
resource "aws_route_table_association" "terraform-route_table_association" {
  subnet_id      = aws_subnet.terraform-subnet.id
  route_table_id = aws_route_table.terraform-route_table.id
}

# Security Group
# Provides a security group resource.
resource "aws_security_group" "terraform-security_group" {
  name        = "allow_web_traffic"
  description = "Allows Web inbound traffic"
  vpc_id      = aws_vpc.terraform-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "terraform-security_group"
    Project = "Terraform"
  }
}

# Network Interface
# Provides an Elastic network interface (ENI) resource.
resource "aws_network_interface" "terraform-network_interface" {
  subnet_id       = aws_subnet.terraform-subnet.id
  security_groups = [aws_security_group.terraform-security_group.id]
  private_ips     = ["10.0.1.50"]

  tags = {
    Name    = "terraform-network_interface"
    Project = "Terraform"
  }
}

# Assing Elastic IP
# Provides an Elastic IP resource.
resource "aws_eip" "terraform-eip" {
  vpc                       = true
  network_interface         = aws_network_interface.terraform-network_interface.id
  associate_with_private_ip = "10.0.1.50"

  tags = {
    Name    = "terraform-eip"
    Project = "Terraform"
  }
}

# Ubuntu Instance
# Provides an EC2 instance resource. This allows instances to be
# created, updated, and deleted. Instances also support provisioning.
resource "aws_instance" "terraform-ubuntu" {
  ami               = var.AMIS[var.REGION]
  instance_type     = var.INSTANCE_TYPE
  availability_zone = var.ZONE1
  key_name          = var.KEY_NAME

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.terraform-network_interface.id
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Wait until SSH is ready'"
    ]

    connection {
      type        = "ssh"
      user        = var.SSH_USER
      private_key = file(var.SSH-KEY_PRIVATE)
      host        = self.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.terraform-ubuntu.public_ip}, --private-key ${var.SSH-KEY_PRIVATE} setup.yml"
  }

  tags = {
    Name    = "terraform-ubuntu"
    Project = "Terraform"
  }
}

output "terraform-ubuntu_ip" {
  value = aws_instance.terraform-ubuntu.public_ip
}