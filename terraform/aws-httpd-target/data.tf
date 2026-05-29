data "terraform_remote_state" "network" {
  backend = "remote"

  config = {
    organization = "djoo-hashicorp"
    workspaces = {
      name = "tf-aws-network-dev"
    }
  }
}

data "hcp_packer_artifact" "rhel9_soe" {
  bucket_name  = "RHEL9-SOE"
  channel_name = "latest"
  platform     = "aws"
  region       = var.aws_region
}

data "aws_route53_zone" "demo" {
  name         = var.route53_zone_name
  private_zone = false
}
