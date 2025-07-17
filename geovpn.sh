#!/bin/bash

domain=$(cat /etc/xray/domain)

grenbo="\e[92;1m"
NC='\e[0m'
Light_Red='\e[1;91m'
Light_Green='\e[1;92m'
White_Bold='\e[1;97m'
Blue='\033[0;36m'

apt update && apt upgrade -y
apt install python3 python3-pip git -y

cd /usr/bin
wget -O bot.zip https://raw.githubusercontent.com/jaka2m/vip/main/bot/bot.zip
unzip bot.zip
mv bot/* /usr/bin/
chmod +x /usr/bin/*
rm -rf bot.zip bot/

wget -O geovpn.zip https://raw.githubusercontent.com/jaka2m/vip/main/bot/geovpn.zip
unzip geovpn.zip -d /usr/bin/
pip3 install -r /usr/bin/geovpn/requirements.txt
rm -rf geovpn.zip

clear

echo -e "${Blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e " ${White_Bold}\e[101m           TAMBAH BOT PANEL           ${NC}"
echo -e "${Blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${grenbo}Tutorial Membuat Bot dan ID Telegram:${NC}"
echo -e "${grenbo}[*] Buat Bot dan Dapatkan Token Bot dari: @BotFather${NC}"
echo -e "${grenbo}[*] Dapatkan ID Telegram Anda dari: @MissRose_bot, gunakan perintah /info${NC}"
echo -e "${Blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

read -e -p "[*] Masukkan Token Bot Anda : " bottoken
read -e -p "[*] Masukkan ID Telegram Admin Anda : " admin

echo -e "BOT_TOKEN=\"$bottoken\"" > /usr/bin/geovpn/var.txt
echo -e "ADMIN=\"$admin\"" >> /usr/bin/geovpn/var.txt
echo -e "DOMAIN=\"$domain\"" >> /usr/bin/geovpn/var.txt

clear

cat > /etc/systemd/system/geovpn.service << EOF
[Unit]
Description=Simple geovpn - @geovpn
After=network.target

[Service]
WorkingDirectory=/usr/bin
ExecStart=/usr/bin/python3 -m geovpn
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable geovpn
systemctl start geovpn
systemctl restart geovpn

cd /root
echo "Selesai!"
echo ""
echo -e "${Light_Green}Data Bot Anda:${NC}"
echo -e "==============================="
echo "Token Bot     : ${bottoken}"
echo "Admin ID      : ${admin}"
echo "Domain        : ${domain}"
echo -e "==============================="
echo "Pengaturan selesai."
echo ""
echo "Instalasi selesai, ketik /menu di bot Anda."

# Cleanup temporary files (assuming geovpn.sh is the current script)
rm -f geovpn.sh
