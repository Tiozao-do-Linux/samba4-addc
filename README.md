# Samba4 como Active Directory Domain Controller (AD DC).

Tá em dúvida se utilizo como base uma imagem do Ubuntu ou do Debian ou do Fedora 42

Para criar uma imagem Docker com Samba4 atuando como um Active Directory Domain Controller (AD DC), a escolha da imagem base influencia diretamente na facilidade de instalação, suporte da comunidade e manutenção da imagem.

Vamos analisar algumas das suas opções:

## ✅ 1. Debian
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

## ✅ 3. Fedora 42  (recomendado)
* Prós:
    * Costuma estar mais atualizado (mais próximo do upstream). Hoje, 18/Jun/2025 a versão do samba instalada é 4.22.2 que corresponde com a última release oficial.
    * Bom para testes ou ambientes onde se quer explorar funcionalidades recentes.
* Contras:
    * Fedora não é tão comum em servidores de produção.
    * Atualizações frequentes (ciclo de vida mais curto), embora possa ser atualizado entre versões facilmente
    * Pode ser mais difícil encontrar tutoriais ou exemplos prontos focados nesse uso.
    * Imagem maior e mais “pesada” para builds.

## 🎯 Conclusão:
* Se o objetivo é estabilidade, compatibilidade com documentação e menor dor de cabeça, `Debian` é a melhor escolha.
* Se você já está mais confortável com `Ubuntu`, especialmente em servidores, ele também é uma ótima base.
* Use `Fedora` apenas se você precisa testar recursos muito recentes do Samba.

## 🚀 Como rodar?

### Clonar o repositório
```
git clone git@github.com:Tiozao-do-Linux/samba4-addc.git

# entrar no diretório
cd samba4-addc
```

### Configurar o seu domínio e senha do Active Directory

* Por default, o arquivo .env contém algumas variáveis básicas que podem ser alteradas de acordo com suas necessidades.
* Personalize suas informações de acordo com a Wiki abaixo
	* https://wiki.tiozaodolinux.com/Guide-for-Linux/Active-Directory-With-Samba-4#primeiro-dc-dc01
```
_REALM="SEUDOMINIO.COM.BR"
_SYSVOL="seudominio.com.br"
_DOMAIN="SEUDOMINIO"
_PASSWORD="SuperSecretPassword@2024"
_NETBIOS="dc01"
_TEMP_PASSWORD="TempSuperSecretPassword@2024"
```

### Executar o container (deploy) fedora ( Recomendado por ser mais atualizado )
```
docker compose up -d
```

### Ver logs
```
docker compose logs -f
```

### Listar os containers em execução
```
docker ps
CONTAINER ID   IMAGE                          COMMAND            CREATED         STATUS                PORTS      NAMES
13b91ad25746   jarbelix/samba4-addc-fedora    "/entrypoint.sh"   5 minutes ago   Up 5 minutes                     samba4-ad
```

### Listar os volumes
```
docker volume ls | grep samba
```

### Entrar no container (note que o prompt muda para [root@dc1 /])
```
docker exec -it samba4-ad bash

[root@dc1 /]# cat /etc/samba/smb.conf
# Global parameters
[global]
	ad dc functional level = 2016
	dns forwarder = 1.1.1.1 8.8.8.8
	netbios name = DC1
	realm = SEUDOMINIO.COM.BR
	server role = active directory domain controller
	template shell = /bin/bash
	workgroup = SEUDOMINIO
	idmap_ldb:use rfc2307 = yes

[sysvol]
	path = /var/lib/samba/sysvol
	read only = No

[netlogon]
	path = /var/lib/samba/sysvol/seudominio.com.br/scripts
	read only = No

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

## Hub do Jarbelix
* https://hub.docker.com/u/jarbelix

## Se quiser criar imagens locais (buildar)
```
docker build -t samba-dc-fedora --no-cache fedora
docker build -t samba-dc-debian --no-cache debian
docker build -t samba-dc-ubuntu --no-cache ubuntu
```

## Listar imagens criadas localmente
```
docker images
REPOSITORY              TAG             IMAGE ID       CREATED          SIZE
samba-dc-ubuntu         latest          085b45ae4f5c   2 minutes ago    319MB
samba-dc-debian         latest          3bdfb72696e3   3 minutes ago    364MB
samba-dc-fedora         latest          b0bf28b7c145   11 minutes ago   564MB
```
