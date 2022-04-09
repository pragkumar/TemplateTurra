####################################################################
# Data source
####################################################################

data "aws_vpc" "vpc_available" {
  filter {
    name   = "tag:Name"
    values = ["tag-wordpress-vpc"]
  }
}
data "aws_subnet_ids" "available_app_subnet" {
  vpc_id = data.aws_vpc.vpc_available.id
  filter {
    name   = "tag:Name"
    values = ["tag-wordpress--public_subnet*"]
  }
}
data "aws_security_group" "tcw_sg" {
  filter {
    name   = "tag:Name"
    values = ["wordpress--Security-Group"]
  }
}
data "template_file" "user_data" {
  template = file("./user-data.sh")
}