FROM fedora:42

# Labels
LABEL description="Active Directory Domain Controller com Samba4"
LABEL version="1.0"
LABEL org.opencontainers.image.authors="Tiozão do Linux <jarbas.junior@gmail.com>"

# Install packages
RUN <<EOF
# Update packages
dnf -y upgrade --refresh
# Necessary packages
dnf install -y samba samba-dc samba-client krb5-workstation
# Extra packages
dnf install -y net-tools htop ccze duf hostname nmap
# Remove files preparing the environment
rm -rf /etc/samba/smb.conf /var/run/samba/* /var/lib/samba/* /var/log/samba/*log* /etc/krb5.conf
EOF

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh

# Defines volumes to be supported
VOLUME /etc/samba /var/lib/samba /var/log/samba /root/provision

# Exposing ports
EXPOSE 53/udp 53/tcp 88/tcp 88/udp 135/tcp 139/tcp 389/tcp 389/udp 445/tcp 464/tcp 464/udp 636/tcp 3268/tcp 3269/tcp

ENTRYPOINT ["/entrypoint.sh"]
