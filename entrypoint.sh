#!/bin/bash
set -e

SAMBA_CONF_DIR="/etc/samba"
SAMBA_LIB_DIR="/var/lib/samba"
SAMBA_LOG_DIR="/var/log/samba"

if [ ! -f "$SAMBA_CONF_DIR/smb.conf" ]; then
    echo "Provisionando ${_DOMAIN} ..."
    cat << '_EOF'
 ____________________________________________________________________________
/\                                                                           \
\_|                 Active Directory Domain Controler - ADDC                 |
  |                         Fedora Linux com Samba4                          |
  |   _______________________________________________________________________|_
   \_/_________________________________________________________________________/

_EOF
    sleep 5
    samba-tool domain provision \
        --server-role=dc \
        --realm=${_REALM:=SEUDOMINIO.COM.BR} \
        --use-rfc2307 \
        --domain=${_DOMAIN:-SEUDOMINIO} \
        --adminpass=${_PASSWORD:-SuperSecretPassword@2025} \
        --dns-backend=${_DNS_BACKEND:-SAMBA_INTERNAL \
        --option="dns forwarder = ${_DNS_FORWARDER_1:-1.1.1.1} ${_DNS_FORWARDER_2:-8.8.8.8}" \
        --option="template shell = /bin/bash" \
        --option="ad dc functional level = 2016" \
        --function-level=2016 \
        --base-schema=2019
fi

# Copiar a configuração gerada para o kerberos
cp /var/lib/samba/private/krb5.conf /etc/

echo "[INFO] Domínio ${_DOMAIN} já provisionado. Iniciando Samba..."
exec samba -i -M single
