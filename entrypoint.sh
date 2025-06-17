#!/bin/bash
set -e

SAMBA_CONF_DIR="/etc/samba"
SAMBA_LIB_DIR="/var/lib/samba"

if [ -f "$SAMBA_CONF_DIR/smb.conf" ]; then
    echo "[INFO] Samba já provisionado. Iniciando..."
else
    echo "[INFO] Provisionando novo domínio Samba4 AD DC..."
    samba-tool domain provision \
        --realm="$REALM" \
        --domain="$DOMAIN" \
        --server-role="$SERVER_ROLE" \
        --dns-backend="$DNS_BACKEND" \
        --adminpass="$ADMIN_PASS" \
        --use-rfc2307 \
        --option="interfaces=lo eth0" \
        --option="bind interfaces only=yes"
fi

echo "[INFO] Iniciando Samba..."
exec samba -i -M single
