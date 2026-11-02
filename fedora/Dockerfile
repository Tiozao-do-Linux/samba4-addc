FROM fedora:45

LABEL org.opencontainers.image.title="Samba4 Active Directory Domain Controller"
LABEL org.opencontainers.image.description="Active Directory Domain Controller with Samba4 on Fedora 45"
LABEL org.opencontainers.image.version="Fedora 45"
LABEL org.opencontainers.image.authors="Tiozão do Linux <jarbas.junior@gmail.com>"

RUN <<EOF
dnf -y upgrade --refresh
#dnf install -y samba samba-dc samba-client krb5-workstation
dnf install -y --nodocs --setopt=install_weak_deps=False samba samba-dc samba-client krb5-workstation
#dnf install -y net-tools htop tree iputils curl jq duf nmap
dnf install -y --nodocs --setopt=install_weak_deps=False net-tools htop tree iputils curl jq duf nmap
dnf clean all
rm -rf /var/cache/libdnf5/* /var/cache/dnf/*
rm -rf /etc/samba/smb.conf /var/run/samba/* /var/lib/samba/* /var/log/samba/*log* /etc/krb5.conf
EOF

COPY --chmod=755 entrypoint.sh /entrypoint.sh
COPY --chmod=755 post-provision.sh /post-provision.sh

VOLUME /etc/samba /var/lib/samba /var/log/samba /root/provision

EXPOSE 53/udp 53/tcp 88/tcp 88/udp 135/tcp 139/tcp 389/tcp 389/udp 445/tcp 464/tcp 464/udp 636/tcp 3268/tcp 3269/tcp

HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=30s \
   CMD smbclient -L localhost -N >/dev/null 2>&1 || exit 1

ENTRYPOINT ["/entrypoint.sh"]
