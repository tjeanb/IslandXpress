# Datasources
data "aws_availability_zones" "available" {
  state = "available"
}


# Local Block
locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnets = [
    for k, az in local.azs : 
    cidrsubnet(var.vpc_cidr, var.subnet_newbits, k)
  ]

  private_app_subnets = [
    for k, az in local.azs :
    cidrsubnet(var.vpc_cidr, var.subnet_newbits, k + 10)
  ]

  private_db_subnets = [
    for k, az in local.azs :
    cidrsubnet(var.vpc_cidr, var.subnet_newbits, k + 20)
  ]
}

