#!/bin/bash
set -e

function echo_line {
   echo "________________________________________________________________________________"
   echo "$@"
   echo "================================================================================"
}

cat << '_EOF'
                              __   _,--="=--,_   __
                             /  \."    .-.    "./  \
                            /  ,/  _   : :   _  \/` \
                            \  `| /o\  :_:  /o\ |\__/
                             `-'| :="~` _ `~"=: |
                                \`     (_)     `/ jgs
                         .-"-.   \      |      /   .-"-.
.-----------------------{     }--|  /,.-'-.,\  |--{     }----------------------.
 )                      (_)_)_)  \_/`~-===-~`\_/  (_(_(_)                     (
(                                                                              )
 )                      Commands After Initial Provision                      (
(                                                                              )
 )                                                                            (
'------------------------------------------------------------------------------'
_EOF

sleep 5

echo_line "Do not expire Administrator password"
samba-tool user setexpiry Administrator --noexpiry

echo_line "Setting Domain Password Policies"
samba-tool domain passwordsettings set --complexity=on --history-length=3 --min-pwd-age=0 --max-pwd-age=365 --min-pwd-length=8

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
   echo_line "Importing *ldif files into the Domain"
   for f in *.${_DOMAIN}.ldif; do
      echo_line "Importing $f"
      ldbadd -H ${_SAMBA_LIB_DIR}/private/sam.ldb $f
   done
fi
