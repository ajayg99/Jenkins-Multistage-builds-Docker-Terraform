resource "aws_security_group" "jenkins-sg"{
    name = "jenkins-sg"
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "jenkins" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "jenkins-ec2"
  }
  key_name = "jenkins"
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install openjdk-11-jre -y
    curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins -y
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    sudo apt install docker.io -y
    sudo su -
    usermod -aG docker jenkins
    usermod -aG docker ubuntu
    systemctl restart docker
    systemctl restart jenkins
  EOF
}
