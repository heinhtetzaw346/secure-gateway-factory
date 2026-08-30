output "instance_ip" {
  value = digitalocean_droplet.vpn-factory-server.ipv4_address
}

output "randomized_ports" {
  value = [
    random_shuffle.vpn_ports.result[0],
    random_shuffle.vpn_ports.result[1],
    random_shuffle.vpn_ports.result[2]
  ]
}

output "randomized_uuid" {
  value = random_id.suffix
}
