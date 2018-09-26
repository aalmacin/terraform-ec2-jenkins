resource "aws_instance" "jenkins" {
  ami = "${var.ubuntu_ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  user_data = <<EOF
#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y wget
sudo apt-get install -y openjdk-8-jre-headless
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo echo 'deb https://pkg.jenkins.io/debian-stable binary/' | tee -a /etc/apt/sources.list.d/jenkins.list
sudo apt-get update -y
sudo apt-get install -y jenkins
sudo service jenkins start
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
EOF
  availability_zone = "${var.availability_zone}"
  tags {
    Name = "${var.name}"
  }
}

resource "aws_key_pair" "keypair" {
  key_name = "${var.key_name}"
  public_key = "${file("jenkins.pub")}"
}

data "aws_route53_zone" "main" {
  name = "${var.domain}"
}

resource "aws_route53_record" "jenkins" {
  name = "${var.cname}"
  type = "CNAME"
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  records = ["${aws_instance.jenkins.public_dns}"]
  ttl = 60
}
