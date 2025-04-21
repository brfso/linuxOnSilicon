#!/bin/bash
# Script to configure ntp and timezone for brasil
# Fernando Oliveira 
# Created at: 2025-05-20

echo "*****************************************"
echo " Starting script: ${0}"
echo " Configuring NTP and Brasil timezone"
echo " Executing commands in: ${HOME}\n"
echo "*****************************************"



#
# Configure timezone Amerciaa/Sao_Paulo
#
timedatectl set-timezone America/Sao_Paulo

#
# Configuring NTP with chrony and NTP.BR servers
#
sudo apt-get update -y > /dev/null 2>&1
echo "Installing Chrony" 
sudo apt-get install chrony -y > /dev/null 2>&1

cat > /etc/chrony/chrony.conf << EOF
# servidores publicos do NTP.br com NTS disponível
server a.st1.ntp.br iburst nts
server b.st1.ntp.br iburst nts
server c.st1.ntp.br iburst nts
server d.st1.ntp.br iburst nts
server gps.ntp.br iburst nts

# caso deseje pode configurar servidores adicionais com NTS, como os da cloudflare e netnod
# nesse caso basta descomentar as linhas a seguir
# server time.cloudflare.com iburst nts
# server nts.netnod.se iburst nts

# arquivo usado para manter a informação do atraso do seu relógio local
driftfile /var/lib/chrony/chrony.drift

# local para as chaves e cookies NTS
ntsdumpdir /var/lib/chrony

# se quiser um log detalhado descomente as linhas a seguir
#log tracking measurements statistics
#logdir /var/log/chrony

# erro máximo tolerado em ppm em relação aos servidores
maxupdateskew 100.0

# habilita a sincronização via kernel do real-time clock a cada 11 minutos
rtcsync

# ajusta a hora do sistema com um "salto", de uma só vez, ao invés de
# ajustá-la aos poucos corrigindo a frequência, mas isso apenas se o erro
# for maior do que 1 segundo e somente para os 3 primeiros ajustes
makestep 1 3

# diretiva que indica que o offset UTC e leapseconds devem ser lidos
# da base tz (de time zone) do sistema
leapsectz right/UTC
EOF

echo "Configuring Chrony Services"
sudo systemctl enable chrony 
sudo systemctl stop chrony
sudo systemctl daemon-reload
sudo systemctl start chrony

echo "Show Chrony tracking and servers"
sudo chronyc tracking
sudo chronyc sources
sudo chronyc -N authdata
