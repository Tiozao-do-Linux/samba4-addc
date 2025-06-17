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
* Se o objetivo é estabilidade, compatibilidade com documentação e menor dor de cabeça, Debian é a melhor escolha.
* Se você já está mais confortável com Ubuntu, especialmente em servidores, ele também é uma ótima base.
* Use Fedora apenas se você precisa testar recursos muito recentes do Samba.

## 🚀 Para rodar:
```
git clone git@github.com:Tiozao-do-Linux/samba4-dc.git

cd samba4-dc

docker build -t samba-dc-fedora -f Dockerfile.fedora .
docker build -t samba-dc-debian -f Dockerfile.debian .
docker build -t samba-dc-ubuntu -f Dockerfile.ubuntu .

docker images
REPOSITORY              TAG             IMAGE ID       CREATED          SIZE
samba-dc-ubuntu         latest          1933157a0174   4 minutes ago    296MB
samba-dc-fedora         latest          1b15d154761b   15 minutes ago   536MB
samba-dc-debian         latest          c8799c7b739c   16 minutes ago   340MB

docker compose up -d samba-dc-fedora
docker compose up -d samba-dc-debian
docker compose up -d samba-dc-ubuntu

```
