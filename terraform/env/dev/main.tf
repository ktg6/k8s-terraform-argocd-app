provider "aws" {
    region  = "ap-northeast-1"
}

resource "aws_instance" "test" {
    ami             = "ami-032d6db78f84e8bf5"
    instance_type   = "t3.micro"
    subnet_id       = "subnet-06b7c9a0e8e05ae20"
}
