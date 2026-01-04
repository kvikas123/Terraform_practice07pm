resource "aws_instance" "aws" {
    
  ami= var.ami_id
    instance_type = var.inst_type
    tags = {
      name="test"
    }
}