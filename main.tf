resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "sneha_vpc"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "private_subnet_${count.index + 1}"
  }
}

resource "aws_internet_gateway" "main_ig" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_eip" "nat_gateway" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main_natgateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public_subnets[0].id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_ig.id
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main_natgateway.id
  }
}

# resource "aws_route_table_association" "public_route_table_subnet_associations" {
#   for_each       = toset(aws_subnet.public_subnets[*].id)
#   subnet_id      = each.value
#   route_table_id = aws_route_table.public_route_table.id
# }

# resource "aws_route_table_association" "private_route_table_subnet_associations" {
#   for_each       = toset(aws_subnet.private_subnets[*].id)
#   subnet_id      = each.value
#   route_table_id = aws_route_table.private_route_table.id
# }

resource "aws_route_table_association" "public_route_table_subnet_associations" {
  for_each       = zipmap(range(length(aws_subnet.public_subnets)), aws_subnet.public_subnets[*].id)
  subnet_id      = each.value
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_subnet_associations" {
  for_each       = zipmap(range(length(aws_subnet.private_subnets)), aws_subnet.private_subnets[*].id)
  subnet_id      = each.value
  route_table_id = aws_route_table.private_route_table.id
}
