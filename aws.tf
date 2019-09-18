

resource "aws_security_group" "tesrinstance" {
  name = "terinstancesecu-group"
  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "aws_example"  {
  ami           = "ami-07cc15c3ba6f8e287"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.tesrinstance.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, WOrld" > index.html
              nohup busybox httpd -f -p 8000 &
              EOF
  tags {
    Name = "ilanterraform-seoondtrystudy"
  }

}