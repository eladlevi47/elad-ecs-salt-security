####################
## ECR Repository ##
####################

data "aws_ecr_repository" "flaskapp" {
  name = "flaskapp"
}

data "aws_ecr_repository" "nginx" {
  name = "nginx"
}

output "ecr_flaskapp_repository_arn" {
  value = data.aws_ecr_repository.flaskapp.arn
}

output "ecr_flaskapp_repository_url" {
  value = data.aws_ecr_repository.flaskapp.repository_url
}

output "ecr_nginx_repository_arn" {
  value = data.aws_ecr_repository.nginx.arn
}

output "ecr_nginx_repository_url" {
  value = data.aws_ecr_repository.nginx.repository_url
}

###############
## ECR Image ##
###############

data "aws_ecr_image" "ecr_flaskapp_image" {
  repository_name = data.aws_ecr_repository.flaskapp.name
  image_tag       = "latest"
}

data "aws_ecr_image" "ecr_nginx_image" {
  repository_name = data.aws_ecr_repository.nginx.name
  image_tag       = "latest"
}

output "ecr_flaskapp_image" {
  value = data.aws_ecr_image.ecr_flaskapp_image.id
}

output "ecr_nginx_image" {
  value = data.aws_ecr_image.ecr_nginx_image.id
}
