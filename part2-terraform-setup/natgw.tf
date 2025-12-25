resource "aws_eip" "nat_eip" {}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.publicSubnetA.id
}
