FROM fedora:42

# Install necessary packages
RUN <<EOF
dnf -y upgrade --refresh
dnf install -y samba samba-dc samba-client krb5-workstation
dnf install -y net-tools htop ccze duf hostname nmap
rm -rf /etc/samba/smb.conf /var/run/samba/* /var/lib/samba/* /var/log/samba/*log* /etc/krb5.conf
EOF

# Copia o entrypoint
COPY ../entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Define volumes
VOLUME /etc/samba /var/lib/samba /var/log/samba

# Expondo portas
EXPOSE 53/udp 53/tcp 88/tcp 88/udp 135/tcp 137/udp 138/udp 139/tcp \
       389/tcp 389/udp 445/tcp 464/tcp 464/udp 3268/tcp 3269/tcp

ENTRYPOINT ["/entrypoint.sh"]
