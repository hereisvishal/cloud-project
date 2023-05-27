##Fetching outputs to be used as values in the networking and instance tf files##

output "vpc_id" {
  description = "ID of project VPC"
  value       = aws_vpc.myvpc1.id
}

output "route_table" {
  value = aws_route_table.myRT.id
}

output "subnet_id" {
  description = "ID of subnet"
  value       = aws_subnet.public1.id
}

output "security_groups" {
  description = "ID of SG"
  value       = aws_security_group.mywebsecurity.id
}

output "internet_gateway" {
  value = aws_internet_gateway.myIGW.id
}


