resource "tls_private_key" "key-pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}



resource "aws_key_pair" "key-pair" {
  key_name   = "key-pair"       # Create a "myKey" to AWS!!
  public_key = tls_private_key.key-pair.public_key_openssh

  provisioner "local-exec" { # Create a "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.key-pair.private_key_pem}' > ./key-pair.pem; chmod 400 key-pair.pem"
  }
}

resource "aws_instance" "mydnswebserver" {
  ami             = "ami-0874ff0d73a3ab8cf"
  instance_type   = "t3.micro"
  key_name        = "key-pair"
  security_groups = [aws_security_group.mywebsecurity.id]
  subnet_id       = aws_subnet.public1.id

  tags = {
    "Name" = "mydnswebserver.cloud"
  }
}

