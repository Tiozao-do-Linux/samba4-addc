FROM debian:bookworm-backports

# Desabilitar modo interativo para pacotes do debian apenas na fase de construção
ARG DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN <<EOF
# Atualiza pacotes
apt-get update
apt-get upgrade -y
# Pacotes necessários
apt-get install -t bookworm-backports -y samba samba-common-bin smbclient krb5-config krb5-user
# Pacotes extras
apt-get install -y htop tree iputils-ping curl jq net-tools nmap
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /etc/samba/smb.conf /var/run/samba/* /var/lib/samba/* /var/log/samba/*log* /etc/krb5.conf
EOF

# Copia o entrypoint
COPY entrypoint.sh /entrypoint.sh

# Define volumes a serem pesistidos
VOLUME /etc/samba /var/lib/samba /var/log/samba /root/provision

# Expondo portas
EXPOSE 53/udp 53/tcp 88/tcp 88/udp 135/tcp 139/tcp 389/tcp 389/udp 445/tcp 464/tcp 464/udp 636/tcp 3268/tcp 3269/tcp

ENTRYPOINT ["/entrypoint.sh"]
