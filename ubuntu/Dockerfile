FROM ubuntu:24.04

LABEL description="Active Directory Domain Controller with Samba4"
LABEL version="Ubuntu 24.04"
LABEL org.opencontainers.image.authors="Tiozão do Linux <jarbas.junior@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

RUN <<EOF
apt-get update
apt-get install -y samba samba-common-bin smbclient krb5-config krb5-user
apt install -y ldb-tools winbind libnss-winbind libpam-winbind
apt-get install -y htop tree iputils-ping curl jq net-tools nmap
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /etc/samba/smb.conf /var/run/samba/* /var/lib/samba/* /var/log/samba/*log* /etc/krb5.conf
EOF

COPY entrypoint.sh /entrypoint.sh

VOLUME /etc/samba /var/lib/samba /var/log/samba /root/provision

EXPOSE 53/udp 53/tcp 88/tcp 88/udp 135/tcp 139/tcp 389/tcp 389/udp 445/tcp 464/tcp 464/udp 636/tcp 3268/tcp 3269/tcp

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD pgrep -x samba >/dev/null 2>&1 || exit 1

ENTRYPOINT ["/entrypoint.sh"]
