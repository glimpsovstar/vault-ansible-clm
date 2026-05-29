locals {
  host_suffix = format("%02d", var.host_index)
  hostname    = "${var.name_prefix}-${local.host_suffix}"
  fqdn        = "${local.hostname}.${var.route53_zone_name}"

  common_tags = merge(
    {
      Project = "vault-ansible-clm"
      Role    = "cert-deploy-target"
      Service = "httpd"
    },
    var.tags
  )
}

resource "aws_instance" "httpd" {
  ami           = data.hcp_packer_artifact.rhel9_soe.external_identifier
  instance_type = var.instance_type
  subnet_id     = data.terraform_remote_state.network.outputs.vpc_public_subnets[0]
  key_name      = var.key_pair_name
  vpc_security_group_ids = [
    data.terraform_remote_state.network.outputs["security_group-ssh_http_https_allowed"]
  ]
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = true

  tags = merge(local.common_tags, {
    Name = local.hostname
  })

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }
}

resource "aws_route53_record" "httpd" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = local.fqdn
  type    = "A"
  ttl     = 60
  records = [aws_instance.httpd.public_ip]
}
