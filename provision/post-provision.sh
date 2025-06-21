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
 )                    Comandos Depois do Provision Inicial                    (
(                                                                              )
 )                                                                            (
'------------------------------------------------------------------------------'
_EOF

sleep 5

echo_line "Não expirar senha do Administrador"
samba-tool user setexpiry Administrator --noexpiry

echo_line "Definindo Políticas de Senhas do Domínio"
samba-tool domain passwordsettings set --complexity=on --history-length=3 --min-pwd-age=0 --max-pwd-age=365 --min-pwd-length=8

echo_line "Validando politicas do Domínio"
samba-tool domain passwordsettings show

echo_line "Listando as OUs e Objetos da OU"
samba-tool ou list

echo_line "Listando os Grupos e Membros de Grupos"
samba-tool group list

echo_line "Listando todos usuários do domínio"
samba-tool user list

echo_line "Listar o Nível de Função e Floresta para o Domínio"
samba-tool domain level show

cd ${_PROVISION_DIR}

# Se existir arquivos *ldif* no diretório, executa os procedimentos de carga
if [ "$(ls -1 *.ldif 2>/dev/null | wc -l)" -gt 0 ]; then
   echo_line "Importando arquivos *ldif* no Domínio"
   for f in *.ldif; do
      echo_line "Importando $f"
      ldbadd -H ${_SAMBA_LIB_DIR}/private/sam.ldb $f
   done
fi
