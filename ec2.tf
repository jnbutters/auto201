data "aws_ami" "f5_ami" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["*BIGIP-15.1.1*PAYG-Best*25Mbps*"]
  }
}

data "template_file" "do" {
  template = file("./templates/do.tpl")
}
data "template_file" "as3" {
  template = file("./templates/as3.tpl")
}

resource "aws_instance" "f5_ltm" {
  ami           = data.aws_ami.f5_ami.id
  instance_type = "t2.medium"

  network_interface {
    network_interface_id = aws_network_interface.mgmt.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.public.id
    device_index         = 1
  }

  network_interface {
    network_interface_id = aws_network_interface.private.id
    device_index         = 2
  }

  key_name  = aws_key_pair.demo.key_name
  user_data = data.template_file.f5_init.rendered

  tags = {
    Name        = "f5_ltm"
    Terraform   = "true"
    Environment = "dev"
  }


  provisioner "local-exec" {
    command = "while [[ \"$(curl -ski http://${aws_eip.public-vs1.public_ip} | grep -Eoh \"^HTTP/1.1 200\")\" != \"HTTP/1.1 200\" ]]; do sleep 5; done"
  }

}


# Debug File to test paramters

# resource "local_file" "test_user_debug" {
#   content = templatefile("./templates/user_data_json.tpl", {
#     hostname        = "mybigip.f5.com",
#     admin_pass      = random_string.password.result,
#     external_ip     = "${aws_network_interface.public.private_ip}/24",
#     internal_ip     = "${aws_network_interface.private.private_ip}/24",
#     internal_gw     = cidrhost(module.vpc.private_subnets_cidr_blocks[0], 1),
#     vs1_ip          = aws_eip.public-vs1.private_ip,
#     #consul_uri      = "http://${aws_instance.consul.private_ip}:8500/v1/catalog/service/nginx",
#     do_declaration  = data.template_file.do.rendered,
#     as3_declaration = data.template_file.as3.rendered
#     consul_uri      = "test"
#   })
#   filename = "${path.module}/user_data_debug.json"
# }

data "template_file" "f5_init" {
  template = file("./templates/user_data_json.tpl")
  vars = {
    hostname        = "mybigip.f5.com",
    admin_pass      = random_string.password.result,
    external_ip     = "${aws_eip.public-self.private_ip}/24",
    internal_ip     = "${aws_network_interface.private.private_ip}/24",
    internal_gw     = cidrhost(module.vpc.private_subnets_cidr_blocks[0], 1),
    vs1_ip          = aws_eip.public-vs1.private_ip,
    consul_uri      = "http://${aws_instance.consul.private_ip}:8500/v1/catalog/service/nginx",
    do_declaration  = data.template_file.do.rendered,
    as3_declaration = data.template_file.as3.rendered
  }
}