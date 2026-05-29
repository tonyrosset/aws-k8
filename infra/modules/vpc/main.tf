resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

    tags = {
        Name = "${var.project_name}-${var.environment}-vpc"
    }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.project_name}-${var.environment}-igw"
    }
}

resource "aws_subnet" "public" {
  for_each = {
    for index, cidr in var.public_subnet_cidrs : 
    index => cidr
  }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[tonumber(each.key)]
  map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-${var.environment}-public-${tonumber(each.key) + 1}"
        "kubernetes.io/role/elb" = "1"
    }
}

resource "aws_subnet" "private" {
  for_each = {
    for index, cidr in var.private_subnet_cidrs : 
    index => cidr
  }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[tonumber(each.key)]

    tags = {
        Name = "${var.project_name}-${var.environment}-private-${tonumber(each.key) + 1}"
        "kubernetes.io/role/internal-elb" = "1"
    }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.project_name}-${var.environment}-public-rt"
    }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.project_name}-${var.environment}-private-rt-${each.key}"
    }
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}