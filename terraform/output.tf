output "dbpassword" {
  description = "The password of the rds instance"
  value       = nonsensitive(module.db.db_instance_password)
}
