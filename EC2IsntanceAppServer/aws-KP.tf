#Creating Key value Pair

resource "aws_key_pair" "wordpress-Keypair" {
  key_name   = "WordpressKeyPair"
  public_key = file("${path.module}/id_rsa.pub")
}

output "key_name" {
  value = aws_key_pair.wordpress-Keypair.key_name

}