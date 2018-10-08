provider "aws" {
   access_key = "AKIAJGVNPR6UZZNSNISA"
   secret_key = "JmzRzdgqG9BqOXxWL/gn+dOb+rXb6RFeIUqiOGcp"
   region     = "ap-southeast-2"
}

resource "aws_instance" "aws_example"  {
  ami           = "ami-09b42976632b27e9b"
  instance_type = "t2.micro"
  
  tags {
  Name = "ilanterraform-example"
}  

}

