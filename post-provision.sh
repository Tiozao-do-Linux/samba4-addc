#!/bin/bash
set -e

cat << '_EOF'
 ____________________________________________________________________________
/\                                                                           \
\_|                 Commands After Initial Provision                         |
  |   _______________________________________________________________________|_
   \_/_________________________________________________________________________/

_EOF

echo_line "Do not expire Administrator password"
samba-tool user setexpiry Administrator --noexpiry

echo_line "Setting Domain Password Policies"
samba-tool domain passwordsettings set --complexity=on --history-length=3 --min-pwd-age=10 --max-pwd-age=365 --min-pwd-length=8 --account-lockout-threshold=5 --reset-account-lockout-after=30 --account-lockout-duration=30

echo_line "Viewing Domain Password Policies"
samba-tool domain passwordsettings show

echo_line "Listing OUs and OU Objects"
samba-tool ou list

echo_line "Listing Groups and Group Members"
samba-tool group list

echo_line "Listing all domain users"
samba-tool user list

echo_line "List the Function and Forest Level for the Domain"
samba-tool domain level show

cd ${_PROVISION_DIR}

# If there are *ldif* files in the directory, perform the load procedures
if [ "$(ls -1 *.${_DOMAIN}.ldif 2>/dev/null | wc -l)" -gt 0 ]; then
   for f in *.${_DOMAIN}.ldif; do
      echo_line "Importing $f into the Domain"
      ldbadd -H ${_SAMBA_LIB_DIR}/private/sam.ldb $f
   done
else
   echo_line "Not found *.${_DOMAIN}.ldif to import into the Domain"
fi
