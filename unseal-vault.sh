#!/bin/bash
KEYFILE=keys.secrets
TMPFILE=keys_tmp.secrets

# Initialize vault
docker exec -it viu_dev_vault vault operator init -address=${VAULT_ADDR} > ${TMPFILE}

# Format file (remove ^[[0m) characters from file
sed 's/\x1b\[[0-9;]*m//g' ${TMPFILE} > ${KEYFILE}
rm ${TMPFILE}

# Start unsealing the vautl
docker exec -it viu_dev_vault vault operator unseal -address=${VAULT_ADDR} $(grep 'Key 1:' ${KEYFILE} | awk '{print $NF}')
docker exec -it viu_dev_vault vault operator unseal -address=${VAULT_ADDR} $(grep 'Key 2:' ${KEYFILE} | awk '{print $NF}')
docker exec -it viu_dev_vault vault operator unseal -address=${VAULT_ADDR} $(grep 'Key 3:' ${KEYFILE} | awk '{print $NF}')