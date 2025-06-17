# Samba4 como Active Directory Domain Controller (AD DC).

Tô em dúvida se utilizo como base uma imagem do Ubuntu ou do Debian ou do Fedora 42

Para criar uma imagem Docker com Samba4 atuando como um Active Directory Domain Controller (AD DC), a escolha da imagem base influencia diretamente na facilidade de instalação, suporte da comunidade e manutenção da imagem.

Vamos analisar suas opções:


## ✅ 1. Debian (recomendado)
* Prós:
    * Samba é bem suportado no Debian, com pacotes atualizados.
    * Documentação da comunidade Samba costuma ter exemplos com Debian.
    * Estável, previsível e amplamente utilizado em ambientes de produção.
    * Tamanho da imagem debian:bullseye-slim ou bookworm-slim é relativamente enxuto.
* Contras:
    * Alguns pacotes podem estar um pouco desatualizados em relação ao upstream (embora normalmente estáveis para uso em produção).

## ✅ 2. Ubuntu
* Prós:
    * Baseado no Debian, com pacotes mais recentes em versões LTS.
    * Boa documentação e comunidade ativa.
    * Versão ubuntu:20.04 ou 22.04 LTS é uma excelente base estável.
* Contras:
    * A imagem é um pouco maior que a do Debian.
    * Pode ter mais camadas de complexidade em relação ao systemd, dependendo do que você precisa rodar.

## ⚠️ 3. Fedora 42
* Prós:
    * Samba costuma estar mais atualizado (mais próximo do upstream).
    * Bom para testes ou ambientes onde se quer explorar funcionalidades recentes.
* Contras:
    * Fedora não é tão comum em servidores de produção.
    * Atualizações frequentes (ciclo de vida mais curto).
    * Pode ser mais difícil encontrar tutoriais ou exemplos prontos focados nesse uso.
    * Imagem maior e mais “pesada” para builds.

## 🎯 Conclusão:
* Se o objetivo é estabilidade, compatibilidade com documentação e menor dor de cabeça, `Debian` é a melhor escolha.
* Se você já está mais confortável com `Ubuntu`, especialmente em servidores, ele também é uma ótima base.
* Use `Fedora` apenas se você precisa testar recursos muito recentes do Samba.

## 🚀 Para rodar:
Levando em consideração as três fontes, façamos as três imagens
```
git clone git@github.com:Tiozao-do-Linux/samba4-dc.git

cd samba4-dc

# Criar imagens (buildar)
docker build -t samba-dc-fedora -f Dockerfile.fedora .
docker build -t samba-dc-debian -f Dockerfile.debian .
docker build -t samba-dc-ubuntu -f Dockerfile.ubuntu .

# Listar imagens
docker images
REPOSITORY              TAG             IMAGE ID       CREATED          SIZE
samba-dc-ubuntu         latest          1933157a0174   4 minutes ago    296MB
samba-dc-fedora         latest          1b15d154761b   15 minutes ago   536MB
samba-dc-debian         latest          c8799c7b739c   16 minutes ago   340MB

# A escolha é sua:
##################

# Executar o container (deploy) fedora
docker compose -f docker-compose.fedora.yml up -d

# Executar o container (deploy) debian
docker compose -f docker-compose.debian.yml up -d

# Executar o container (deploy) ubuntu
docker compose -f docker-compose.ubuntu.yml up -d


# Entrar no container
docker exec -it samba4-ad bash

[root@dc1 /]# cat /etc/os-release 
NAME="Fedora Linux"
VERSION="42 (Container Image)"
RELEASE_TYPE=stable
ID=fedora
VERSION_ID=42
VERSION_CODENAME=""
PLATFORM_ID="platform:f42"
PRETTY_NAME="Fedora Linux 42 (Container Image)"
ANSI_COLOR="0;38;2;60;110;180"
LOGO=fedora-logo-icon
CPE_NAME="cpe:/o:fedoraproject:fedora:42"
DEFAULT_HOSTNAME="fedora"
HOME_URL="https://fedoraproject.org/"
DOCUMENTATION_URL="https://docs.fedoraproject.org/en-US/fedora/f42/system-administrators-guide/"
SUPPORT_URL="https://ask.fedoraproject.org/"
BUG_REPORT_URL="https://bugzilla.redhat.com/"
REDHAT_BUGZILLA_PRODUCT="Fedora"
REDHAT_BUGZILLA_PRODUCT_VERSION=42
REDHAT_SUPPORT_PRODUCT="Fedora"
REDHAT_SUPPORT_PRODUCT_VERSION=42
SUPPORT_END=2026-05-13
VARIANT="Container Image"
VARIANT_ID=container

[root@dc1 /]# nmap localhost
Starting Nmap 7.92 ( https://nmap.org ) at 2025-06-17 17:40 UTC
Nmap scan report for localhost (127.0.0.1)
Host is up (0.0000050s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 981 closed tcp ports (reset)
PORT      STATE SERVICE
22/tcp    open  ssh
53/tcp    open  domain
88/tcp    open  kerberos-sec
135/tcp   open  msrpc
139/tcp   open  netbios-ssn
389/tcp   open  ldap
445/tcp   open  microsoft-ds
464/tcp   open  kpasswd5
631/tcp   open  ipp
636/tcp   open  ldapssl
3268/tcp  open  globalcatLDAP
3269/tcp  open  globalcatLDAPssl
3389/tcp  open  ms-wbt-server
7070/tcp  open  realserver
9090/tcp  open  zeus-admin
32769/tcp open  filenet-rpc
49152/tcp open  unknown
49153/tcp open  unknown
49154/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 0.21 seconds
```
