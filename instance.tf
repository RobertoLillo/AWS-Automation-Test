# VPC
resource "aws_vpc" "terraform-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name    = "terraform-vpc"
    Project = "Terraform"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "terraform-gateway" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = {
    Name    = "terraform-gateway"
    Project = "Terraform"
  }
}

# Custom Route Table
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
resource "aws_route_table_association" "terraform-route_table_association" {
  subnet_id      = aws_subnet.terraform-subnet.id
  route_table_id = aws_route_table.terraform-route_table.id
}

# Security Group
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
resource "aws_instance" "terraform-ubuntu" {
  ami               = var.AMIS[var.REGION]
  instance_type     = var.INSTANCE_TYPE
  availability_zone = var.ZONE1
  key_name          = var.KEY_NAME
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.terraform-network_interface.id
  }

  tags = {
    Name    = "terraform-ubuntu"
    Project = "Terraform"
  }
}
