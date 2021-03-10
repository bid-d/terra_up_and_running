output "address" {
  value       = aws_db_instance.bidd_db_mysql.address
  description = "Connect to the database at this endpoint"
}
output "port" {
  value       = aws_db_instance.bidd_db_mysql.port
  description = "The port the database is listening on"
}