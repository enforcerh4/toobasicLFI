#This is supposed to be a file template to craft your own wordlist and use it with ToobasicLFI

files_indicators["/etc/passwd"]="root:"  #example : just replace /etc/passwd by the path of the file you wanna find

#root is called a file_indicator and will be used by curl to check if the file was found, you need to put a word that is ALWAYS present in the searched file. 
#Choosing a good file indicator isn't the easiest thing but I guess it's child's play for you. 
