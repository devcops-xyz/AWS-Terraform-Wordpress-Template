resource "aws_launch_configuration" "lc" {
  name          = "asg lc"
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
  key_name = var.key_name
  security_groups = [aws_security_group.asgsecuritygroup.id]
  user_data = <<-EOF
#!/usr/bin/env bash
amazon-linux-extras enable lamp-mariadb10.2-php7.2
yum update -y
amazon-linux-extras disable lamp-mariadb10.2-php7.2
amazon-linux-extras enable php7.3
yum update -y
yum install -y php-cli php-pdo php-fpm php-json php-mysqlnd
amazon-linux-extras disable php7.3
yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd
cd /var/www/html
wget http://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
rm -rf latest.tar.gz
chown -R apache:apache wordpress
cd /var/www/html/wordpress

cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sed -i "s/'database_name_here'/'${aws_db_instance.mydb.name}'/g" wp-config.php
sed -i "s/'username_here'/'${aws_db_instance.mydb.username}'/g" wp-config.php
sed -i "s/'password_here'/'${aws_db_instance.mydb.password}'/g" wp-config.php
sed -i "s/'localhost'/'${aws_db_instance.mydb.address}'/g" wp-config.php
	EOF
}

resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [data.aws_cloudformation_export.PrivateSubnetA.value,
                        data.aws_cloudformation_export.PrivateSubnetB.value,
                        data.aws_cloudformation_export.PrivateSubnetC.value]
  launch_configuration = aws_launch_configuration.lc.id
  max_size = 3
  min_size = 2
  desired_capacity = 2
  target_group_arns = [aws_alb_target_group.tg.arn]
}