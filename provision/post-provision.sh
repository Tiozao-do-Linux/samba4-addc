#!/bin/bash
set -e
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
 )                    Comandos Depois do Provision Inicial                    (
(                                                                              )
 )                                                                            (
'------------------------------------------------------------------------------'
_EOF

echo "Não expirar senha do Administrador"
samba-tool user setexpiry Administrator --noexpiry

echo "Alterando Políticas do Domínio"
samba-tool domain passwordsettings set --complexity=on --history-length=3 --min-pwd-age=0 --max-pwd-age=365 --min-pwd-length=8

echo "Validando politicas do Domínio"
samba-tool domain passwordsettings show