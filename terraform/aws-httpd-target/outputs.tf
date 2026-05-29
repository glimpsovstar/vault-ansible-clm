output "instance_id" {
  value = aws_instance.httpd.id
}

output "public_ip" {
  value = aws_instance.httpd.public_ip
}

output "private_ip" {
  value = aws_instance.httpd.private_ip
}

output "hostname" {
  value = local.hostname
}

output "fqdn" {
  value = local.fqdn
}

output "ssh_command" {
  description = "Hint SSH command. Key path assumes ~/.ssh/<key_pair_name> with no extension."
  value       = "ssh -i ~/.ssh/${var.key_pair_name} ec2-user@${aws_instance.httpd.public_ip}"
}
