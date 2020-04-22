output "wordpress_link" {
  value = "http://${aws_lb.elb.dns_name}/wordpress"
}