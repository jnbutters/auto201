resource "aws_eip" "mgmt" {
  vpc                       = true
  network_interface         = aws_network_interface.mgmt.id
  associate_with_private_ip = "10.0.1.10"
}

resource "aws_eip" "public-self" {
  vpc                       = true
  network_interface         = aws_network_interface.public.id
  associate_with_private_ip = "10.0.2.10"
}

resource "aws_eip" "public-vs1" {
  vpc                       = true
  network_interface         = aws_network_interface.public.id
  associate_with_private_ip = "10.0.2.20"
}