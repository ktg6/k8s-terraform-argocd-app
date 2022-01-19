provider "aws" {
    region  = "ap-northeast-1"
}

resource "aws_instance" "test" {
    ami     = "ami-032d6db78f84e8bf5"
}
