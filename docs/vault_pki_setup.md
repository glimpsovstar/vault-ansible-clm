# Vault PKI Setup Reference

## Prerequisites

- Vault server running and unsealed
- Root CA configured on `pki` mount
- Demo PKI mount `pki-demo` enabled and signed by the root CA

## PKI Role Configuration

Create the PKI role used by automation:

```bash
vault write pki-demo/roles/role-pki-demo \
    allowed_domains="example.com" \
    allow_subdomains=true \
    allow_bare_domains=false \
    allow_glob_domains=false \
    allow_ip_sans=true \
    enforce_hostnames=true \
    server_flag=true \
    client_flag=false \
    no_store=false \
    max_ttl="8760h" \
    key_type="rsa" \
    key_bits=2048 \
    key_usage="DigitalSignature,KeyEncipherment" \
    ext_key_usage="ServerAuth" \
    require_cn=true
```

> **Critical**: `no_store=false` is required for revocation. With `no_store=true`, Vault does not retain issued certificates and cannot revoke them.
>
> `client_flag=false` keeps issued certs server-only (no clientAuth EKU), matching the demo's TLS server use case.

## AppRole Setup

```bash
# Enable AppRole auth
vault auth enable approle

# Create policy (see policies/aap_pki_policy.hcl)
vault policy write aap-pki policies/aap_pki_policy.hcl

# Create AppRole
vault write auth/approle/role/aap-clm \
    token_policies="aap-pki" \
    token_ttl="1h" \
    token_max_ttl="4h" \
    secret_id_ttl="30d" \
    secret_id_num_uses=0

# Get Role ID
vault read auth/approle/role/aap-clm/role-id

# Generate Secret ID
vault write -f auth/approle/role/aap-clm/secret-id
```

> `secret_id_ttl=30d` forces secret-id rotation; pair with the AAP secret-lookup
> credential so AAP refreshes it via the OIDC-to-KV path rather than holding a
> long-lived secret.

## Tomcat Keystore Password (Vault KV)

Store the keystore password in Vault KV for runtime retrieval:

```bash
vault kv put secret/tomcat/keystore password="<secure-password>"
```

## Verify PKI Configuration

```bash
# List roles
vault list pki-demo/roles

# Read role config
vault read pki-demo/roles/role-pki-demo

# Test issuance (manual)
vault write pki-demo/issue/role-pki-demo \
    common_name="test.example.com" \
    ttl="24h"

# Read CA chain
vault read pki-demo/ca_chain
```

## CRL and Tidy

```bash
# Check CRL
curl -s $VAULT_ADDR/v1/pki-demo/crl | openssl crl -inform DER -noout -text

# Run tidy (cleanup expired/revoked certs)
vault write pki-demo/tidy \
    tidy_cert_store=true \
    tidy_revoked_certs=true \
    safety_buffer="72h"
```
