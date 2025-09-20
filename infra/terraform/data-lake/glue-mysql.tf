resource "aws_glue_connection" "mysql_connection" {
  name = "mysql-connection"

  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:mysql://${var.mysql_host}:${var.mysql_port}/${var.mysql_db}"
    USERNAME            = var.mysql_username
    PASSWORD            = var.mysql_password
  }

  physical_connection_requirements {
    security_group_id_list = [data.aws_security_group.glue_sg.id]
    subnet_id              = data.aws_subnet.private_subnet1.id
  }
}
