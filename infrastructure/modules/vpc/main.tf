resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  lifecycle {
    prevent_destroy = false #Ephemeral environment
  }

  tags = merge(var.tags, {Name = "islandXpress-${var.environment_name}-vpc"})

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {Name = "islandXpress-${var.environment_name}-igw"})
}

resource "aws_subnet" "public" {
  for_each = {for idx, az in local.azs : az => local.public_subnets[idx]}
  vpc_id = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true

 tags = merge(var.tags, {Name = "${var.environment_name}-public-${each.key}"})
}

resource "aws_subnet" "private_app" {
  for_each = {for idx, az in local.azs : az => local.private_app_subnets[idx]}
  vpc_id = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = false

  tags = merge(var.tags, {Name = "${var.environment_name}-private-app-${each.key}"})
}

resource "aws_subnet" "private_db" {
  for_each = {for idx, az in local.azs : az => local.private_db_subnets[idx]}
  vpc_id = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = false

  tags = merge(var.tags, {Name = "${var.environment_name}-private-db-${each.key}"})
}

resource "aws_eip" "nat" {
  tags = merge(var.tags, {Name = "${var.environment_name}-nat-eip"})
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = values(aws_subnet.public)[0].id

  depends_on = [ aws_internet_gateway.igw ]

  tags = merge(var.tags, {Name = "${var.environment_name}-nat"})
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, {Name = "${var.environment_name}-public-rt"})
}

resource "aws_route_table_association" "public_rt_assoc" {
  for_each = aws_subnet.public
  subnet_id = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_app_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(var.tags, {Name = "${var.environment_name}-private-app-rt"})
}

resource "aws_route_table_association" "private_app_rt_assoc" {
  for_each = aws_subnet.private_app
  subnet_id = each.value.id
  route_table_id = aws_route_table.private_app_rt.id
}

resource "aws_route_table" "private_db_rt" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {Name = "${var.environment_name}-private-db-rt"})
}

resource "aws_route_table_association" "private_db_rt_assoc" {
  for_each = aws_subnet.private_db
  subnet_id = each.value.id
  route_table_id = aws_route_table.private_db_rt.id
}