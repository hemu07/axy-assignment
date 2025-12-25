resource "aws_subnet" "publicSubnetA" {
  vpc_id     = aws_vpc.axy-project.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "publicSubnetB" {
  vpc_id     = aws_vpc.axy-project.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "privateSubnetA" {
  vpc_id     = aws_vpc.axy-project.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"
}
resource "aws_subnet" "privateSubnetB" {
  vpc_id     = aws_vpc.axy-project.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
}
