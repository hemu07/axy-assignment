resource "aws_route_table" "publicRouteTable" {
    vpc_id = aws_vpc.axy-project.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table" "privateRouteTable" {
    vpc_id = aws_vpc.axy-project.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gw.id
    }
}

resource "aws_route_table_association" "publicRouteTableAssociationA" {
    subnet_id = aws_subnet.publicSubnetA.id
    route_table_id = aws_route_table.publicRouteTable.id
}

resource "aws_route_table_association" "publicRouteTableAssociationB" {
    subnet_id = aws_subnet.publicSubnetB.id
    route_table_id = aws_route_table.publicRouteTable.id
}

resource "aws_route_table_association" "privateRouteTableAssociationA" {
    subnet_id = aws_subnet.privateSubnetA.id
    route_table_id = aws_route_table.privateRouteTable.id
}

resource "aws_route_table_association" "privateRouteTableAssociationB" {
    subnet_id = aws_subnet.privateSubnetB.id
    route_table_id = aws_route_table.privateRouteTable.id
}
