# Jump host for remote developer access to DocumentDBs in the same VPC.
# NOTE: On this project the DocumentDB is manually created to prevent accidental teardown
# NOTE: and this jump host is only created during the STAGE configuration but used for all environments

# # Progamatically find an Ubunut 22.04 Image
data "aws_ami" "server_ami" {  
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    # values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }
}

# Create Security Group to open SSH Traffic
resource "aws_security_group" "jd-sg-ssh" {
  # count = var.stage == "stage" ? 1 : 0

  name = "JUMPHOST-${var.stage}"
  vpc_id =  aws_vpc.jd-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Elastic IP
resource "aws_eip" "jump_host" {
  # count = var.stage == "stage" ? 1 : 0

  # instance = aws_instance.jump_host[count.index].id
  instance = aws_instance.jump_host.id
}

resource "aws_eip_association" "jump_host" {
  # count = var.stage == "stage" ? 1 : 0

  # instance_id   = aws_instance.jump_host[count.index].id
  # allocation_id = aws_eip.jump_host[count.index].id
  instance_id   = aws_instance.jump_host.id
  allocation_id = aws_eip.jump_host.id
}

# Create Public EC2 Instance and Attache to Public SG
resource "aws_instance" "jump_host" {
  # count = var.stage == "stage" ? 1 : 0

  ami = data.aws_ami.server_ami.id
  instance_type = "t2.micro"

  subnet_id =  aws_subnet.jd-public.id
  # vpc_security_group_ids = [ aws_security_group.jd-sg-ssh[count.index].id ]
  vpc_security_group_ids = [ aws_security_group.jd-sg-ssh.id ]


  // SSH Key-pair must be created manually in console first. 
  key_name = "${var.prefix}-admin"
  associate_public_ip_address = true

  depends_on = [
    aws_security_group.jd-sg-ssh
  ]
  
  tags = {
    Name = "${local.name.prefix}-jump-host"
  }
}