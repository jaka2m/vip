#!/bin/bash
NS=$( cat /etc/xray/dns )
PUB=$( cat /etc/slowdns/server.pub )
domain=$(cat /etc/xray/domain)
#color
grenbo="\e[92;1m"
NC='\e[0m'
#install
apt update && apt upgrade
apt install python3 python3-pip git
cd /usr/bin
wget https://raw.githubusercontent.com/ALVIICELL/vip/main/bot/bot.zip
unzip bot.zip
mv bot/* /usr/bin
chmod +x /usr/bin/*
clear
wget https://raw.githubusercontent.com/jaka2m/vip/main/bot/geovpn.zip
unzip geovpn.zip
pip3 install -r geovpn/requirements.txt

#isi data
echo ""
echo -e "\033[1;36mâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\033[0m"
echo -e " \e[1;97;101m          ADD BOT PANEL          \e[0m"
echo -e "\033[1;36mâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\033[0m"
echo -e "${grenbo}Tutorial Creat Bot and ID Telegram${NC}"
echo -e "${grenbo}[*] Creat Bot and Token Bot : @BotFather${NC}"
echo -e "${grenbo}[*] Info Id Telegram : @MissRose_bot , perintah /info${NC}"
echo -e "\033[1;36mâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\033[0m"
read -e -p "[*] Input your Bot Token : " bottoken
read -e -p "[*] Input Your Id Telegram :" admin
echo -e BOT_TOKEN='"'$bottoken'"' >> /usr/bin/geovpn/var.txt
echo -e ADMIN='"'$admin'"' >> /usr/bin/geovpn/var.txt
echo -e DOMAIN='"'$domain'"' >> /usr/bin/geovpn/var.txt
echo -e PUB='"'$PUB'"' >> /usr/bin/geovpn/var.txt
echo -e HOST='"'$NS'"' >> /usr/bin/geovpn/var.txt
clear

cat > /etc/systemd/system/geovpn.service << END
[Unit]
Description=Simple geovpn - @geovpn
After=network.target

[Service]
WorkingDirectory=/usr/bin
ExecStart=/usr/bin/python3 -m geovpn
Restart=always

[Install]
WantedBy=multi-user.target
END

systemctl start geovpn 
systemctl enable geovpn
systemctl restart geovpn
cd /root
echo "Done"
echo "Your Data Bot"
echo -e "==============================="
echo "Token Bot         : $bottoken"
echo "Admin          : $admin"
echo "Domain        : $domain"
echo "Pub            : $PUB"
echo "Host           : $NS"
echo -e "==============================="
echo "Setting done"
clear

echo " Installations complete, type /menu on your bot"
rm -rf geovpn.sh
rm -rf bot.zip
