data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "prod_vpc"
  }
}

resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    "Name" = "prod_IGW"
  }
}

resource "aws_route_table" "prod_route_table" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_igw.id
  }

  tags = {
    "Name" = "prod_route_table"
  }
}

resource "aws_subnet" "prod_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "prod_subnets"
  }
}

resource "aws_route_table_association" "prod_rt_association" {
  count          = length(aws_subnet.prod_subnets)
  subnet_id      = aws_subnet.prod_subnets[count.index].id
  route_table_id = aws_route_table.prod_route_table.id
}

resource "aws_security_group" "prod_sg_allow_web" {
  name        = "allow_web_traffic"
  description = "allow web inbound traffic"
  vpc_id      = aws_vpc.prod_vpc.id

  tags = {
    "Name" = "prod_allow_web"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.prod_sg_allow_web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.prod_sg_allow_web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.prod_sg_allow_web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.prod_sg_allow_web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "web_server_instance" {
  ami               = "ami-09c54d172e7aa3d9a"
  instance_type     = "t2.micro"
#   availability_zone = "eu-west-1a"
  key_name          = "EC2 Tutorial"
  subnet_id = data.aws_subnets.all.ids[0]
  vpc_security_group_ids      = [aws_security_group.prod_sg_allow_web.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y httpd
                sleep 20
                sudo systemctl start httpd
                sudo systemctl enable httpd
                sudo bash -c "echo your very first server > /var/www/html/index.html"
                EOF
  tags = {
    "Name" = "web_server"
  }
}


data "aws_vpc" "selected" {
    tags = { Name = "prod_vpc" }
}


data "aws_subnets" "all" {
    filter {
      name = "vpc-id"
      values = [ data.aws_vpc.selected.id ]
    }

#     filter {
#     name   = "tag:Name"
#     values = ["prod_vpc"]
#   }
}


# # Look up all subnets in that VPC
# data "aws_subnets" "all" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.selected.id]
#   }
# }


output "server_public_ip" {
  value = aws_instance.web_server_instance.public_ip
}

output "server_private_ip" {
  value = aws_instance.web_server_instance.private_ip
}

output "server_id" {
  value = aws_instance.web_server_instance.id
}

