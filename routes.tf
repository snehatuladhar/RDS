
# resource "aws_route_table" "public_route_table" {
#   vpc_id = aws_vpc.main_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.main_ig.id
#   }
# }
# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.main_vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.main_natgateway.id
#   }
# }
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