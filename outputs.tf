output "public-ip-jenkins-ec2"{
  value = aws_instance.jenkins.public_ip
}
