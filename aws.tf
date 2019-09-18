data "aws_availability_zones" "all" {}

variable "server_port" {
  description = "Server Port used by terraform"
  default = 3000
}

resource "aws_security_group" "tesrinstance" {
  name = "terinstancesecu-group"
  ingress {
    from_port = "${var.server_port}"
    protocol = "tcp"
    to_port = "${var.server_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "example"  {
  image_id = "ami-07cc15c3ba6f8e287"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.tesrinstance.id}"]


  user_data = <<-EOF
              #!/bin/bash
              sudo yum install --enablerepo=epel -y nodejs
              wget http://bit.ly/2vESNuc -O /home/ec2-user/helloworld.js
              wget http://bit.ly/2vVvT18 -O /etc/init/helloworld.conf
              start helloworld
              EOF
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  max_size = 10
  min_size = 2

  load_balancers = ["${aws_elb.example.name}"]
  health_check_type = "ELB"


  tag {
    key = "Name"
    propagate_at_launch = true
    value = "terraform-asg-example"
  }

}

resource "aws_elb" "example" {
  name = "terraform-asg-example"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups = ["${aws_security_group.elb.id}"]
  "listener" {
    instance_port = "${var.server_port}"
    instance_protocol = "HTTP"
    lb_port = 80
    lb_protocol = "HTTP"
  }
  health_check {
    healthy_threshold = 2
    interval = 30
    target = "HTTP:${var.server_port}/"
    timeout = 3
    unhealthy_threshold = 2
  }
}

resource "aws_security_group" "elb" {
  name = "terraform-example-elb"

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}
