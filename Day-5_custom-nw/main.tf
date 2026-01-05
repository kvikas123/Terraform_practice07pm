resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name="dev_vpc"
  }
}

resource "aws_subnet" "test" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.2.0/24" #subnet
    availability_zone = "us-east-1b"
    tags = {
      name="test"
    }
  
}
resource "aws_subnet" "dev" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.3.0/24" #subnet
    availability_zone = "us-east-1b"
    tags = {
      name="dev"
    }
  
}
#attached vpc to internet gateway
resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
    tags = {
      name="IG"
    }
  
}
/*resource "aws_internet_gateway_attachment" "name" {
    internet_gateway_id = aws_internet_gateway.name.id
    vpc_id = aws_vpc.name.id

  
} */

resource "aws_route_table" "name" {
vpc_id = aws_vpc.name.id 
route  {
    cidr_block="0.0.0.0/0"
   gateway_id=aws_internet_gateway.name.id
}

}

resource "aws_route_table_association" "name" {
subnet_id = aws_subnet.dev.id
route_table_id = aws_route_table.name.id

#Create private RT
#Create Nat Gateway
#Subnet association to private subnet
  
}
resource "aws_security_group" "dev_sg" {
    name = "allow_tls"
    vpc_id = aws_vpc.name.id
    tags = {
      Name="dev-sg"
    }
  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description="SSH"
    from_port=22
    to_port=22
    protocol="TCP"
    cidr_blocks=["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1" #indicate all protocol
    cidr_blocks = ["0.0.0.0/0"]
  }



}

resource "aws_instance" "name" {
    ami="ami-068c0051b15cdb816"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.dev.id
    vpc_security_group_ids = [aws_security_group.dev_sg.id]
    
}

