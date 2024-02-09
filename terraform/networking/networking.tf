# VPC
resource "aws_vpc" "jd-vpc" {
  cidr_block       = "10.0.0.0/16"
  
  tags = {
    Name = "${local.name.prefix}-vpc"
  }
}

# Subnets - Public / Private
# 1 Octect remaining for each subnet which yields 253 host addresses - plenty for this pattern
resource "aws_subnet" "jd-public" {
  vpc_id     = aws_vpc.jd-vpc.id
  cidr_block = "10.0.1.0/24"
  
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name.prefix}-public-subnet"
  }
}

resource "aws_subnet" "jd-public-2" {
  vpc_id     = aws_vpc.jd-vpc.id
  cidr_block = "10.0.3.0/24"
  
  map_public_ip_on_launch = true

  availability_zone = "us-east-1a"

  tags = {
    Name = "${local.name.prefix}-public-subnet-2"
  }
}

resource "aws_subnet" "jd-public-3" {
  vpc_id     = aws_vpc.jd-vpc.id
  cidr_block = "10.0.5.0/24"
  
  map_public_ip_on_launch = true

  availability_zone = "us-east-1b"

  tags = {
    Name = "${local.name.prefix}-public-subnet-3"
  }
}

resource "aws_subnet" "jd-private" {
  vpc_id     = aws_vpc.jd-vpc.id
  cidr_block = "10.0.2.0/24"

  map_public_ip_on_launch = false

  tags = {
    Name = "${local.name.prefix}-private-subnet"
  }
}

# Internet Gateway - Route to Internet from Public Subnet
resource "aws_internet_gateway" "jd-igw" {
  vpc_id = aws_vpc.jd-vpc.id

  tags = {
    Name = "${local.name.prefix}-igw"
  }
}

# Route Table for IGW Traffic to Public Subnet
resource "aws_route_table" "jd-public-rt" {
  vpc_id = aws_vpc.jd-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jd-igw.id
  }

  tags = {
    Name = "${local.name.prefix}-public-rt"
  }
}

# Associate Public Route Table with Public Subnet
resource "aws_route_table_association" "jd-public_1_rt_assoc" {
  subnet_id = aws_subnet.jd-public.id
  route_table_id = aws_route_table.jd-public-rt.id
}

resource "aws_route_table_association" "jd-public_2_rt_assoc" {
  subnet_id = aws_subnet.jd-public-2.id
  route_table_id = aws_route_table.jd-public-rt.id
}

resource "aws_route_table_association" "jd-public_3_rt_assoc" {
  subnet_id = aws_subnet.jd-public-3.id
  route_table_id = aws_route_table.jd-public-rt.id
}

# Generate EIP for NAT Gateway
resource "aws_eip" "nat-ip-address" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.jd-igw]
  tags = {
    Name = "${local.name.prefix}-nat-eip"
  }
}

# Creat NAT Gateway, associate EIP and public subnet
resource "aws_nat_gateway" "jd-nat" {
  allocation_id = aws_eip.nat-ip-address.id
  subnet_id = aws_subnet.jd-public.id

  tags = {
    Name = "${local.name.prefix}-nat-gateway"
  }
}

# Create traffic route from private subnet to NAT gateway
resource "aws_route_table" "jd-private-nat-route" {
  vpc_id = aws_vpc.jd-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.jd-nat.id
  }

  tags = {
    Name = "${local.name.prefix}-private-nat-route"
  }
}

resource "aws_route_table_association" "jd-private_1_rt_assoc" {
  subnet_id = aws_subnet.jd-private.id
  route_table_id = aws_route_table.jd-private-nat-route.id
}

# Create a default security group that alllows all traffic in/out of the VPC
resource "aws_security_group" "jd-default-vpc-sg" {
  vpc_id = aws_vpc.jd-vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
  
  # Open VPC "Firewall" to External Access of DocumentDB
  ingress {
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = ["127.0.0.1/32"]
  }

  timeouts {
    delete = "40m"
  }

  depends_on = [aws_iam_role_policy_attachment.api_lambda_policy_vpc]

  tags = {
    Name = "${local.name.prefix}-vpc-default-security-group"
  }
}
