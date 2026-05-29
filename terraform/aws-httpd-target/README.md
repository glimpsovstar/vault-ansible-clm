# CLM httpd target (Phase 4a)

Single-node httpd EC2 used as a deploy target for the Vault → AAP CLM workflow. Bootstraps with a self-signed placeholder cert at `/etc/pki/clm/`; the CLM `wf_deploy.yml` playbook replaces those files with Vault PKI-issued material and reloads httpd.

## What this creates

- One `t3.micro` RHEL9-SOE EC2 in `ap-southeast-2` public subnet (inherited from `tf-aws-network-dev`)
- Route53 A record `clm-httpd-01.david-joo.sbx.hashidemos.io` → instance public IP
- httpd + mod_ssl, vhost on 443, placeholder cert valid 30 days
- IAM instance profile `tfstacks-profile` (managed elsewhere)

## TFC workspace

`djoo-hashicorp / tf-aws-clm-httpd-target` — VCS-connected to this fork, `terraform/aws-httpd-target/` as the working directory.

## After apply

1. Verify `curl -sk https://$(terraform output -raw fqdn)/` returns the placeholder page
2. Add the host to the AAP `CLM Hosts` inventory (group `httpd`)
3. Create an AAP Machine credential with the `hashicorp-djoo-demo` private key, attach to JTs 35–38
4. Run the CLM workflow and watch the cert get replaced
