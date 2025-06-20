# Não expirar senha do Administrador
samba-tool user setexpiry Administrator --noexpiry

# Alterando Políticas do Domínio
samba-tool domain passwordsettings set --complexity=on --history-length=3 --min-pwd-age=0 --max-pwd-age=365 --min-pwd-length=8

# Validando politicas do Domínio
# samba-tool domain passwordsettings show

# Validar a versão do esquema do AD em um Samba DC
# samba-tool domain level show
