provider "aws" {
    region = "us-east-1"  # Defines the AWS region for resources (here, us-east-1)
}

# Creating an AWS Key Pair
#resource "aws_key_pair" "deployer" {
 #   key_name   = "key-pairs"  # Name of the key pair
  #  public_key = file("/home/username.ssh/id_rsa.pub")  # Path to your SSH public key file to allow SSH access to instances
#}

# Security Group Configuration
resource "aws_security_group" "allow_ssh_http_https" {
    name        = "allow_ssh_http_https"  # Name of the security group
    description = "Allow SSH, HTTP, and HTTPS traffic"  # Description of the security group

    # Inbound rule for SSH access on port 22
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allows SSH from any IP address
    }

    # Inbound rule for HTTP access on port 80
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allows HTTP traffic from any IP address
    }

    # Inbound rule for HTTPS access on port 443
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allows HTTPS traffic from any IP address
    }

    # Inbound rule for additional custom ports (8081, 8080, 9000, 3000)
    ingress {
        from_port   = 8081
        to_port     = 8081
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allows traffic on port 8081 from any IP address
    }
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allows traffic on port 8080 from any IP address
    }
    ingress {
        from_port   = 9000
        to_port     = 9000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # Allows traffic on port 9000 from any IP address
    }
    ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # greafana
    }
    ingress {
        from_port   = 9100
        to_port     = 9100
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # nodeexporter
    }
    ingress {
        from_port   = 9090
        to_port     = 9090
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  # prometheus
    }
    # Outbound rule for all traffic (allows outgoing traffic to anywhere)
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"  # -1 means all protocols
        cidr_blocks = ["0.0.0.0/0"]  # Allows all outgoing traffic
    }
}

# EC2 Instance Resource to Create a Web Server
resource "aws_instance" "web" {
    ami           = "ami-"
    instance_type = "t2.large"
    count         = 2  # Creates two EC2 instances
    key_name      = "key-pairs"  # Use the existing key pair
    security_groups = [aws_security_group.allow_ssh_http_https.name]


    # Configures the root block device size (25 GB)
    root_block_device {
        volume_size = 25
    }
}

# Elastic IP Resource for Associating Elastic IP with the EC2 instance
resource "aws_eip" "elastic_ip" {
    count = 2  # Creates two Elastic IPs
    instance = element(aws_instance.web.*.id, count.index)  # Associates each Elastic IP to an instance
}


