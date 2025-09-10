FROM debian:trixie-backports

# Disable interactive mode for debian packages only in build phase
ARG DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN <<EOF
# Update packages
apt-get update
apt-get upgrade -y
# Required packages
apt-get install -t trixie-backports -y samba-ad-dc samba samba-common-bin smbclient krb5-config krb5-user ldb-tools
# Extra packages
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
