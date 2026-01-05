resource "aws_instance" "name" {
    ami= var.ami_id
    instance_type = var.inst_type
    tags = {
      name="Dev"
    }

  
}
