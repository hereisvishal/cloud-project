provider "aws" {
  region = "eu-north-1"
}
resource "aws_vpc" "myvpc1" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraform-made-vpc"
  

}
}


resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.myvpc1.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet"
  }

}

resource "aws_security_group" "mywebsecurity" {
  name        = "WS-SG"
  vpc_id      = aws_vpc.myvpc1.id

  ingress {
    description      = "HTTP"
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "SSH"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
##ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myvpc1.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "myRT" {
  vpc_id = aws_vpc.myvpc1.id
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id
  }
  tags = {
    Name = "MyRT"
  }
}

resource "aws_route_table_association" "explicit_association" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.myRT.id
}






