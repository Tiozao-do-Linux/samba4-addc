FROM ubuntu:latest

# Labels
LABEL description="Active Directory Domain Controller with Samba4"
LABEL version="Ubuntu Latest"
LABEL org.opencontainers.image.authors="Tiozão do Linux <jarbas.junior@gmail.com>"

# Disable interactive mode for debian packages only in build phase
ARG DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN <<EOF
apt-get update
apt-get install -y samba samba-common-bin smbclient krb5-config krb5-user
apt-get install -y htop tree iputils-ping curl jq net-tools nmap
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /etc/samba/smb.conf /var/run/samba/* /var/lib/samba/* /var/log/samba/*log* /etc/krb5.conf
EOF

# Copy entrypoint
COPY ../entrypoint.sh /entrypoint.sh

# Defines volumes to be supported
VOLUME /etc/samba /var/lib/samba /var/log/samba /root/provision

# Exposing ports
EXPOSE 53/udp 53/tcp 88/tcp 88/udp 135/tcp 139/tcp 389/tcp 389/udp 445/tcp 464/tcp 464/udp 636/tcp 3268/tcp 3269/tcp       

ENTRYPOINT ["/entrypoint.sh"]
