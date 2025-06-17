FROM debian:bookworm-slim

# Desabilitar modo interativo para pacotes do debian apenas na fase de construção
ARG DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN <<EOF
apt-get update
apt-get install -y samba samba-common-bin smbclient krb5-config krb5-user dnsutils winbind libpam-winbind libnss-winbind 
apt-get install -y htop tree iputils-ping curl jq net-tools
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF

# Define variáveis padrão
ENV REALM=EXEMPLO.LAN \
    DOMAIN=EXEMPLO \
    ADMIN_PASS=SenhaForte123 \
    DNS_BACKEND=SAMBA_INTERNAL \
    SERVER_ROLE=dc

# Copia o entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Define volumes
VOLUME /etc/samba /var/lib/samba /var/log/samba

# Expondo portas
EXPOSE 53/udp 53/tcp 88/tcp 88/udp 135/tcp 137/udp 138/udp 139/tcp \
       389/tcp 389/udp 445/tcp 464/tcp 464/udp 3268/tcp 3269/tcp

# Removendo arquivos
RUN << EOF
rm -rf /etc/samba/smb.conf /var/run/samba/* /var/lib/samba/* /var/log/samba/*log* /etc/krb5.conf
EOF

ENTRYPOINT ["/entrypoint.sh"]
