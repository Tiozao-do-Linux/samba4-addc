FROM fedora:44

LABEL description="Active Directory Domain Controller with Samba4"
LABEL version="Fedora 44"
LABEL org.opencontainers.image.authors="Tiozão do Linux <jarbas.junior@gmail.com>"

RUN <<EOF
dnf -y upgrade --refresh
dnf install -y samba samba-dc samba-client krb5-workstation
dnf install -y net-tools htop ccze duf nmap
rm -rf /etc/samba/smb.conf /var/run/samba/* /var/lib/samba/* /var/log/samba/*log* /etc/krb5.conf
EOF

COPY ../entrypoint.sh /entrypoint.sh
COPY /post-provision.sh /post-provision.sh

VOLUME /etc/samba /var/lib/samba /var/log/samba /root/provision

EXPOSE 53/udp 53/tcp 88/tcp 88/udp 135/tcp 139/tcp 389/tcp 389/udp 445/tcp 464/tcp 464/udp 636/tcp 3268/tcp 3269/tcp

ENTRYPOINT ["/entrypoint.sh"]
