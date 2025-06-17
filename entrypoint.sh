#!/bin/bash
set -e

SAMBA_CONF_DIR="/etc/samba"
SAMBA_LIB_DIR="/var/lib/samba"
SAMBA_LOG_DIR="/var/log/samba"

if [ -f "$SAMBA_CONF_DIR/smb.conf" ]; then
    echo "[INFO] Samba já provisionado. Iniciando..."
else
    echo "[INFO] Provisionando novo domínio Samba4 AD DC..."
    samba-tool domain provision \
        --server-role=dc \
        --realm=${_REALM} \
        --use-rfc2307 \
        --domain=${_DOMAIN} \
        --adminpass=${_PASSWORD} \
        --dns-backend=SAMBA_INTERNAL \
        --option="dns forwarder = 1.1.1.1 8.8.8.8" \
        --option="template shell = /bin/bash" \
        --option="ad dc functional level = 2016" --function-level=2016 --base-schema=2019
    # Copiar a configuração gerada para o kerberos
    cp /var/lib/samba/private/krb5.conf /etc/
fi

echo "[INFO] Iniciando Samba..."
exec samba -i -M single
