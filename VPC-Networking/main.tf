
################################################################################
# VPC
################################################################################


resource "aws_vpc" "wordpress-vpc" {
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  cidr_block           = var.cidr_block
  tags = {
    Name = "tag-wordpress-vpc"
  }
}

output "vpc_id" {
  value = aws_vpc.wordpress-vpc.id
}


###############################################################################
# Internet Gateway
###############################################################################

resource "aws_internet_gateway" "wordpress-internetGateway" {
  vpc_id = aws_vpc.wordpress-vpc.id

  tags = {
    Name = "tag-wordpress-internetGateway"
  }
}

output "aws_internet_gateway" {
  value = aws_internet_gateway.wordpress-internetGateway.id
}
###############################################################################
# Public Subnet
###############################################################################
resource "aws_subnet" "wordpress-public_subnet_1" {
  vpc_id                  = aws_vpc.wordpress-vpc.id
  cidr_block              = var.public_subnets_cidr_1
  availability_zone       = data.aws_availability_zones.wordpress-available_1.names[0]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "tag-wordpress--public_subnet_1"
  }
}

resource "aws_subnet" "wordpress-public_subnet_2" {
  vpc_id                  = aws_vpc.wordpress-vpc.id
  cidr_block              = var.public_subnets_cidr_2
  availability_zone       = data.aws_availability_zones.wordpress-available_1.names[1]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "tag-wordpress--public_subnet_2"
  }
}


################################################################################
# Database subnet
################################################################################

resource "aws_subnet" "database_subnet_1" {
  vpc_id                  = aws_vpc.wordpress-vpc.id
  cidr_block              = var.database_subnets_cidr_1
  availability_zone       = data.aws_availability_zones.wordpress-available_1.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "tag-wordpress--private_subnet_1"
  }
}
resource "aws_subnet" "database_subnet_2" {
  vpc_id                  = aws_vpc.wordpress-vpc.id
  cidr_block              = var.database_subnets_cidr_2
  availability_zone       = data.aws_availability_zones.wordpress-available_1.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "tag-wordpress--private_subnet_2"
  }
}

################################################################################
# Publiс route table and route
################################################################################

resource "aws_route_table" "wordpress-public_route_table" {
  vpc_id = aws_vpc.wordpress-vpc.id
  tags = {
    Name = "tag-wordpress-public-route-table"
  }
}
resource "aws_route" "wordpress-public_internet_gateway" {
  route_table_id         = aws_route_table.wordpress-public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wordpress-internetGateway.id
}

################################################################################
# Database(Private) route table and Route
################################################################################

resource "aws_route_table" "wordpress-database_route_table" {
  vpc_id = aws_vpc.wordpress-vpc.id

  tags = {
    Name = "tag-wordpress-private-route-table"
  }
}
################################################################################
# Route table association with subnets
################################################################################

resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.wordpress-public_subnet_1.id
  route_table_id = aws_route_table.wordpress-public_route_table.id
}
resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.wordpress-public_subnet_2.id
  route_table_id = aws_route_table.wordpress-public_route_table.id
}
resource "aws_route_table_association" "database_route_table_association_1" {
  subnet_id      = aws_subnet.database_subnet_1.id
  route_table_id = aws_route_table.wordpress-database_route_table.id
}
resource "aws_route_table_association" "database_route_table_association_2" {
  subnet_id      = aws_subnet.database_subnet_2.id
  route_table_id = aws_route_table.wordpress-database_route_table.id
}


###############################################################################
# Security Group
###############################################################################

#Creating Security Group

resource "aws_security_group" "wordpress-aws_security_group" {
  name        = "wordpress-security-group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.wordpress-vpc.id

  dynamic "ingress" {

    for_each = var.ports
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Outbound rule"
    prefix_list_ids  = null
    security_groups  = null
    self             = null
  }


  tags = {
    Name = "wordpress--Security-Group"
  }
}




output "secuirty_group_name" {
  value = aws_security_group.wordpress-aws_security_group.id

}

