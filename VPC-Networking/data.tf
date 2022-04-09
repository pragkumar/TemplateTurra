################################################################################
# Availability Zones list out
################################################################################
data "aws_availability_zones" "wordpress-available_1" {
  state = "available"
}