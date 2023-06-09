# --------------------------
# register key pair
# --------------------------
# 以下コマンドを使用してキーペアを作成
# ssh-keygen -t rsa -b 2048 -f {キーペア名}
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = file("./src/tastylog-dev-keypair.pub") # 直接ファイルを読み込む

  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    Project = var.project
    Env     = var.environment
  }
}

# --------------------------
# SSM Parameter Store
# --------------------------
# resource "aws_ssm_parameter" "host" {
#   name  = "/${var.project}/${var.environment}/app/MYSQL_HOST"
#   type  = "String"
#   value = aws_db_instance.mysql_standalone.address
# }

# resource "aws_ssm_parameter" "port" {
#   name  = "/${var.project}/${var.environment}/app/MYSQL_PORT"
#   type  = "String"
#   value = aws_db_instance.mysql_standalone.port
# }

# resource "aws_ssm_parameter" "database" {
#   name  = "/${var.project}/${var.environment}/app/MYSQL_DATABASE"
#   type  = "String"
#   value = aws_db_instance.mysql_standalone.name
# }

# resource "aws_ssm_parameter" "username" {
#   name  = "/${var.project}/${var.environment}/app/MYSQL_USERNAME"
#   type  = "SecureString"
#   value = aws_db_instance.mysql_standalone.username
# }

# resource "aws_ssm_parameter" "password" {
#   name  = "/${var.project}/${var.environment}/app/MYSQL_PASSWORD"
#   type  = "SecureString"
#   value = aws_db_instance.mysql_standalone.password
# }

# --------------------------
# create EC2 instance
# --------------------------
resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.app.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_1a.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name #インスタンスプロフィールをEC2ヘアタッチ
  vpc_security_group_ids = [
    aws_security_group.app_sg.id,
    aws_security_group.opmng_sg.id
  ]
  key_name = aws_key_pair.keypair.key_name
  lifecycle {
    ignore_changes = [
      ami,
    ]
  }

  tags = {
    Name    = "${var.project}-${var.environment}-app-ec2"
    Project = var.project
    Env     = var.environment
    type    = "app"
  }
}