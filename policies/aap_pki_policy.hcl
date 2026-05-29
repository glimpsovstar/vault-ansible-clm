# Vault policy for AAP AppRole - Certificate Lifecycle Management
# Apply with: vault policy write aap-pki policies/aap_pki_policy.hcl
#
# Mount/role names match the demo deployment (pki-demo + role-pki-demo).
# Adjust if you change vault_pki_mount / vault_pki_role in group_vars/all.yml.

# Issue certificates from the demo PKI mount
path "pki-demo/issue/role-pki-demo" {
  capabilities = ["create", "update"]
}

# Revoke certificates
path "pki-demo/revoke" {
  capabilities = ["create", "update"]
}

# Tidy certificate store (cleanup expired/revoked)
path "pki-demo/tidy" {
  capabilities = ["create", "update"]
}

# Read certificate by serial number (for status checks)
path "pki-demo/cert/*" {
  capabilities = ["read"]
}

# Read CA chain (for chain validation)
path "pki-demo/ca_chain" {
  capabilities = ["read"]
}

# Read CA certificate
path "pki-demo/ca" {
  capabilities = ["read"]
}

# Read Tomcat keystore password from KV v2 (only needed if cert_service_type=tomcat)
path "secret/data/tomcat/keystore" {
  capabilities = ["read"]
}
