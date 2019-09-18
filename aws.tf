provider "aws" {


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