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

sleep 5

echo "Não expirar senha do Administrador
================================================================================"
samba-tool user setexpiry Administrator --noexpiry

echo "Definindo Políticas de Senhas do Domínio
================================================================================"
samba-tool domain passwordsettings set --complexity=on --history-length=3 --min-pwd-age=0 --max-pwd-age=365 --min-pwd-length=8

echo "Validando politicas do Domínio
================================================================================"
samba-tool domain passwordsettings show

echo "Listando as OUs e Objetos da OU
================================================================================"
samba-tool ou list

echo "Listando os Grupos e Membros de Grupos
================================================================================"
samba-tool group list

echo "Listando todos usuários do domínio
================================================================================"
samba-tool user list

echo "Listar o Nível de Função e Floresta para o Domínio
================================================================================"
samba-tool domain level show

cd /root/provision/

echo "Importando arquivos *ldif* no Domínio
================================================================================="
# Se existir arquivos *ldif* no diretório, executa os procedimentos de carga
if [ "$(ls -1 *.ldif 2>/dev/null | wc -l)" -gt 0 ]; then
    for f in *.ldif; do
        echo "Importando $f"
        ldbadd -H /var/lib/samba/private/sam.ldb $f
    done
else
    echo "Nenhum arquivo *.ldif encontrado"
fi
