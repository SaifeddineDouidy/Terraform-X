output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" { 
  value = aws_subnet.private[*].id 
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "alb_sg_id" { 
  value = aws_security_group.alb.id 
}
output "ecs_sg_id" { 
  value = aws_security_group.ecs.id 
}
output "rds_sg_id" { 
  value = aws_security_group.rds.id
}

output "docdb_sg_id" {
  value = aws_security_group.docdb.id
}
