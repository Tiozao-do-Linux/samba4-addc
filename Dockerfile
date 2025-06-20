FROM fedora:42

# Instala pacotes necessários
RUN <<EOF
# Atualiza pacotes
dnf -y upgrade --refresh
# Pacotes necessários
dnf install -y samba samba-dc samba-client krb5-workstation
# Pacotes extras
dnf install -y net-tools htop ccze duf hostname nmap
# Remove arquivos preparando o ambiente
rm -rf /etc/samba/smb.conf /var/run/samba/* /var/lib/samba/* /var/log/samba/*log* /etc/krb5.conf
EOF

# Copia o entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Define volumes a serem pesistidos
VOLUME /etc/samba /var/lib/samba /var/log/samba /root/provision

# Expondo portas
EXPOSE 53/udp 53/tcp 88/tcp 88/udp 135/tcp 139/tcp 389/tcp 389/udp 445/tcp 464/tcp 464/udp 636/tcp 3268/tcp 3269/tcp

ENTRYPOINT ["/entrypoint.sh"]
