#!/bin/bash
set -e

# Default values
export _REALM=${_REALM:-"SEUDOMINIO.COM.BR"}
export _SYSVOL=${_REALM,,}
export _DOMAIN=${_REALM%%.*}
export _NETBIOS=${_NETBIOS:-"dc01"}
export _DNS_FORWARDER_1=${_DNS_FORWARDER_1:-"1.1.1.1"}
export _DNS_FORWARDER_2=${_DNS_FORWARDER_2:-"8.8.8.8"}
export _DNS_BACKEND=${_DNS_BACKEND:-"SAMBA_INTERNAL"}
export _PASSWORD=${_PASSWORD:-"SuperSecretPassword@2025"}
export _TEMP_PASSWORD=${_TEMP_PASSWORD:-"TempSuperSecretPassword@2025"}

function echo_line() {
    echo '/------------------------------------------------------------------------------\'
    echo "| $@"
    echo '\______________________________________________________________________________/'
}
export -f echo_line

if [ ! -f "${_SAMBA_CONF_DIR}/smb.conf" ]; then
    cat << '_EOF'
 ____________________________________________________________________________
/\                                                                           \
\_|                 Active Directory Domain Controler - ADDC                 |
  |                            Linux with Samba4                             |
  |   _______________________________________________________________________|_
   \_/_________________________________________________________________________/

_EOF
    echo_line "Provisioning Samba4 $(samba --version):"
    echo_line "Realm: ${_REALM} - Domain: ${_DOMAIN} - NetBIOS: ${_NETBIOS}"
    echo_line "DNS Forwarder: ${_DNS_FORWARDER_1} ${_DNS_FORWARDER_2}"
    echo_line "Administrator Password: ${_PASSWORD}"
    #sleep 5
    samba-tool domain provision \
        --server-role=dc \
        --realm=${_REALM} \
        --use-rfc2307 \
        --domain=${_DOMAIN} \
        --adminpass=${_PASSWORD} \
        --dns-backend=${_DNS_BACKEND} \
        --option="dns forwarder = ${_DNS_FORWARDER_1} ${_DNS_FORWARDER_2}" \
        --option="template shell = /bin/bash" \
        --option="log level = 0" \
        --option="ad dc functional level = 2016" \
        --function-level=2016 \
        --base-schema=2019 >/dev/null 2>&1
    _RET=$?
    if [ $_RET -ne 0 ]; then
        echo_line "Provisioning failed with error code: $_RET"
        exit $_RET
    fi    
    echo_line "Provisioning completed successfully!"
    
    /post-provision.sh
fi

cp ${_SAMBA_LIB_DIR}/private/krb5.conf /etc/

_DATE_TIME=`date`

echo_line "Starting Domain ${_DOMAIN} at ${_DATE_TIME}..."

sed -i "s/^[[:space:]]*log level = .*/        log level = 1 auth_json_audit:3 dsdb_json_audit:5 dsdb_password_json_audit:5 dsdb_group_json_audit:5 dsdb_transaction_json_audit:5/" ${_SAMBA_CONF_DIR}/smb.conf

samba -i -M single

# HINT: To keep the logs in the files
# #1 samba -M single
# #2 exec tail -F /var/log/samba/log.samba 2>/dev/null
