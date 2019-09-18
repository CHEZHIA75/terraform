provider "aws" {
  access_key = "AKIAQKOVO6KJ6XSUUYM5"
  secret_key = "mwgW9KGAN8Qc3VC7sBNXFXcF7rSPfGlP9ehPyDp5"
  region     = "ap-southeast-2"
}

resource "aws_instance" "aws_example"  {
  ami           = "ami-07cc15c3ba6f8e287"
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, WOrld" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags {
    Name = "ilanterraform-example"
  }

}