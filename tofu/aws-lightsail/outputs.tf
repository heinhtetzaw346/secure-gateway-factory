output "instance_ip" {
  value = aws_lightsail_static_ip.vpn-factory-ip.ip_address
}

output "randomized_ports" {
  value = [
    random_shuffle.vpn_ports.result[0],
    random_shuffle.vpn_ports.result[1],
    random_shuffle.vpn_ports.result[2]
  ]
}
