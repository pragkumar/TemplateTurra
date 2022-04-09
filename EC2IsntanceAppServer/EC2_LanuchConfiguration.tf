data "aws_ami" "amazon_linux_2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  owners = ["amazon"]
}

resource "aws_launch_configuration" "wordpress-lc" {
  name_prefix                 = "tcw_lc"
  image_id                    = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro"
  user_data                   = data.template_file.user_data.rendered
  key_name                    = aws_key_pair.wordpress-Keypair.key_name
  associate_public_ip_address = true
  security_groups             = [data.aws_security_group.tcw_sg.id]

  #lifecycle {
  #  create_before_destroy = true
  #
}
