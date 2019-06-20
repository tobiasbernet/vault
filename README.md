# Managing Secrets with Vault and Consul

This images uses [vault_1.1.3](https://releases.hashicorp.com/vault/1.1.3/)

## Documentation 
[Vault](https://learn.hashicorp.com/vault/)

## Sourcs
[docker-image](https://github.com/testdrivenio/vault-consul-docker)
[managing-secrets-with-vault-and-consul](https://testdriven.io/managing-secrets-with-vault-and-consul).

## Build the image
```sh
$ docker-compose up -d --build
```

## Start vault
1. Start the docker image
```sh
$ docker start viu_dev_vault
$ docker start viu_dev_consul
```
2. You can now interact with both Vault and Consul. View the UIs at [http://localhost:8200/ui](http://localhost:8200/ui) and [http://localhost:8500/ui](http://localhost:8500/ui).


### Initialize vault
This values while installing it on a new server.
```bash
# INITIAL ROOT TOKEN => token to login
70fca32c-e29f-86e0-2f0a-a331624f10c8

# KEY 1 => key to unseal the vault
ArEAPPKvr17938VdnvmTGWR2Ibd5TiPfjJrA4Q0TgeI=
```

```json
{
    "keys": [
      "02b1003cf2afaf5efddfc55d9ef99319647621b7794e23df8c9ac0e10d1381e2"
    ],
    "keys_base64": [
      "ArEAPPKvr17938VdnvmTGWR2Ibd5TiPfjJrA4Q0TgeI="
    ],
    "root_token": "70fca32c-e29f-86e0-2f0a-a331624f10c8"
  }
```

## Create your first postgres database vault
Please read the documentation first [Setup](https://www.vaultproject.io/docs/secrets/databases/postgresql.html#usage)

1) Login to the vault container: `docker exec -it viu_dev_vault /bin/bash`.
2) Enable the database secret: `vault secrets enable database`.
3) Configure the database connection:
```
vault write database/config/heidi_dev \
    plugin_name=postgresql-database-plugin \
    allowed_roles="ecto" \
    connection_url="postgresql://{{username}}:{{password}}@10.10.11.165:5440/heidi_dev?sslmode=disable" \
    username="postgres" \
    password="postgress"
```
4) Configure a role:
```
vault write database/roles/ecto \
    db_name=heidi_dev \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    default_ttl="1h" \
    max_ttl="24h"

```
