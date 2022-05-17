# Data Source for getting Amazon Linux AMI
data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

########################################################### springBoot 1 Stück.
resource "aws_instance" "vm_springBoot" {
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"
  count = 3

  user_data = templatefile("${path.module}/templates/init_springboot.tpl", {
    signoz_host= aws_instance.vm_sigNoz.public_ip
  } )

  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-http.id]

  tags = {
    Name = "vm_springBoot.${count.index}"
  }

#  Deaktiviert, weil AWS Student keine Power hat
#  lifecycle {
#    create_before_destroy = true
#  }
}

########################################################### Signoz
resource "aws_instance" "vm_sigNoz" {
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"


  user_data = templatefile("${path.module}/templates/init_signoz.tpl", {
    VarTest = "test"
  } )

  vpc_security_group_ids = [aws_security_group.ingress-all-ssh.id, aws_security_group.ingress-all-forSignozAgent.id, aws_security_group.ingress-all-forSignozDashport.id, aws_security_group.ingress-all-forSignozAgent2.id]

  tags = {
    Name = "vm_signoz"
  }
}
########################################################### Security ###########################################################

resource "aws_security_group" "ingress-all-ssh" {
  name = "allow-all-ssh"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-all-http" {
  name = "allow-all-http"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
############################################  Security for Signoz Agent ###########################################################
resource "aws_security_group" "ingress-all-forSignozAgent" {
  name = "allow-all-forSignozAgent"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 4317
    to_port = 4317
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
############################################  Security for Signoz Agent2 ###########################################################
resource "aws_security_group" "ingress-all-forSignozAgent2" {
  name = "allow-all-forSignozAgent2"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 4318
    to_port = 4318
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################  Security for Signoz Dashboard ###########################################################
resource "aws_security_group" "ingress-all-forSignozDashport" {
  name = "allow-all-forSignozDashport"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 3301
    to_port = 3301
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
