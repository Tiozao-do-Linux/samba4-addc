FROM ubuntu:24.04

LABEL org.opencontainers.image.title="Samba4 Active Directory Domain Controller"
LABEL org.opencontainers.image.description="Active Directory Domain Controller with Samba4 on Ubuntu 24.04"
LABEL org.opencontainers.image.version="Ubuntu 24.04"
LABEL org.opencontainers.image.authors="Tiozão do Linux <jarbas.junior@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

RUN <<EOF
apt-get update
apt-get upgrade -y
apt-get install -y --no-install-recommends \
    samba-ad-dc samba-ad-provision samba samba-common-bin smbclient krb5-config krb5-user ldb-tools winbind libnss-winbind libpam-winbind
apt-get install -y --no-install-recommends \
    htop tree iputils-ping curl jq net-tools nmap
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /etc/samba/smb.conf /var/run/samba/* /var/lib/samba/* /var/log/samba/*log* /etc/krb5.conf
EOF

COPY --chmod=755 entrypoint.sh /entrypoint.sh
COPY --chmod=755 post-provision.sh /post-provision.sh

VOLUME /etc/samba /var/lib/samba /var/log/samba /root/provision

EXPOSE 53/udp 53/tcp 88/tcp 88/udp 135/tcp 139/tcp 389/tcp 389/udp 445/tcp 464/tcp 464/udp 636/tcp 3268/tcp 3269/tcp

HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=30s \
  CMD smbclient -L localhost -N >/dev/null 2>&1 || exit 1

ENTRYPOINT ["/entrypoint.sh"]
