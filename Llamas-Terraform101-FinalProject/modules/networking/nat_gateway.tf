# Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = { 
    Name = "${var.lastname}-${var.project_name}-NAT-EIP" 
  }
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[1].id 
  depends_on = [aws_internet_gateway.igw]
  tags = { 
    Name = "${var.lastname}-${var.project_name}-NAT" 
  }
}