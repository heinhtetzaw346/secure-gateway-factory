//Generate uuid for seeding
resource "random_uuid" "seed" {}

//For resource names
resource "random_id" "suffix" {
  byte_length = 4
}

//Get random port numbers for outline and ovpn
locals {
  start_port = 49152
  end_port   = 65536
  block_size = 1024

  block_starts = [for s in range(local.start_port, local.end_port, local.block_size) : s]

  port_pool = flatten([
    for s in local.block_starts :
    range(s, min(s + local.block_size, local.end_port))
  ])

  port_strings = [for p in local.port_pool : tostring(p)]
}

//Shuffle the list and get 3 results
resource "random_shuffle" "vpn_ports" {
  input        = sensitive(local.port_strings)
  result_count = 2

  keepers = {
    seed = random_uuid.seed.result
  }
}

//Create Keypair
resource "aws_lightsail_key_pair" "vpn-factory-key" {
  name       = "vpn-factory-key-${random_id.suffix.hex}"
  public_key = file("../../ssh-keys/vpn-factory-key.pub")
}

//Create Lightsail Instance (locked to ubuntu_24_04 blueprint)
resource "aws_lightsail_instance" "vpn-factory-server" {
  name              = "vpn-factory-server-${random_id.suffix.hex}"
  availability_zone = "${var.region}a"
  blueprint_id      = "ubuntu_24_04"
  bundle_id         = var.instance_type
  key_pair_name     = aws_lightsail_key_pair.vpn-factory-key.name
  tags = {
    Name = "vpn-factory-server-${random_id.suffix.hex}"
  }
}

//Create Static IP & Attachment
resource "aws_lightsail_static_ip" "vpn-factory-ip" {
  name = "vpn-factory-ip-${random_id.suffix.hex}"
}

resource "aws_lightsail_static_ip_attachment" "vpn-factory-ip-asso" {
  static_ip_name = aws_lightsail_static_ip.vpn-factory-ip.id
  instance_name  = aws_lightsail_instance.vpn-factory-server.id
}

//Public Ports / Firewall Rules (SSH + VPN ports)
resource "aws_lightsail_instance_public_ports" "vpn-factory-fw" {
  instance_name = aws_lightsail_instance.vpn-factory-server.name

  // SSH Port
  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidrs     = ["0.0.0.0/0"]
  }

  // Dynamic TCP VPN Ports
  dynamic "port_info" {
    for_each = random_shuffle.vpn_ports.result
    content {
      protocol  = "tcp"
      from_port = tonumber(port_info.value)
      to_port   = tonumber(port_info.value)
      cidrs     = ["0.0.0.0/0"]
    }
  }

  // Dynamic UDP VPN Ports
  dynamic "port_info" {
    for_each = random_shuffle.vpn_ports.result
    content {
      protocol  = "udp"
      from_port = tonumber(port_info.value)
      to_port   = tonumber(port_info.value)
      cidrs     = ["0.0.0.0/0"]
    }
  }
}
