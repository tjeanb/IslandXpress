output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_app_subnets_ids" {
  value = [for s in aws_subnet.private_app : s.id]
}

output "private_db_subnets_ids" {
  value = [for s in aws_subnet.private_db : s.id]
}

output "public_subnet_map" {
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
  description = "Map of AZ to Public Subnet ID"
}