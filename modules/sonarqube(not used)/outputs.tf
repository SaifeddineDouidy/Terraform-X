# modules/sonarqube/outputs.tf

# The EC2 instance ID
output "instance_id" {
  description = "ID of the SonarQube EC2 instance"
  value       = aws_instance.sonarqube.id
}

# The public IP address
output "public_ip" {
  description = "Public IP address of the SonarQube instance"
  value       = aws_instance.sonarqube.public_ip
}

# The public DNS name
output "public_dns" {
  description = "Public DNS name of the SonarQube instance"
  value       = aws_instance.sonarqube.public_dns
}

# A full HTTP endpoint on port 9000
output "instance_url" {
  description = "HTTP endpoint for SonarQube (port 9000)"
  value       = "http://${aws_instance.sonarqube.public_dns}:9000"
}
