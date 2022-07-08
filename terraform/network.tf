###################
####### vpc #######
###################

resource "aws_vpc" "main_vpc" {
  cidr_block = "192.168.0.0/16"
}

#######################
####### subnets #######
#######################

resource "aws_subnet" "main_subnet1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "main_subnet2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "main_subnet3" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "192.168.3.0/24"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = true
}

#####################
####### Route #######
#####################

resource "aws_route_table" "route_table_int_gw" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int_gw.id
  }
  depends_on = [
    aws_internet_gateway.int_gw
  ]
}

#######################################
####### route_table_association #######
#######################################

resource "aws_route_table_association" "route_table_association_subnet1" {
  subnet_id      = aws_subnet.main_subnet1.id
  route_table_id = aws_route_table.route_table_int_gw.id
}

resource "aws_route_table_association" "route_table_association_subnet2" {
  subnet_id      = aws_subnet.main_subnet2.id
  route_table_id = aws_route_table.route_table_int_gw.id
}

resource "aws_route_table_association" "route_table_association_subnet3" {
  subnet_id      = aws_subnet.main_subnet3.id
  route_table_id = aws_route_table.route_table_int_gw.id
}

###########################
####### Internet GW #######
###########################

resource "aws_internet_gateway" "int_gw" {
  vpc_id = aws_vpc.main_vpc.id
}

