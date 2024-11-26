provider "AWS" {
region= "ap-south-1"
}

resource "aws_instance" "example" {
  ami                     = "ami-0614680123427b75e"
  instance_type           = "t2.micro"
}
