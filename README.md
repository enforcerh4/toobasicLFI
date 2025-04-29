# TOO  BASIC  LFI  TOOL  DOCUMENTATION

Too Basic LFI tool is another stupid shell script to automate some boring repetitive commands. 

I'm not responsible for its use. Use it at your own risks. 

Trying to compromise systems you haven't been expressely authorized to is forbidden and may result in legal consequences.

## Main Features

I just noticed that there were no simple tool to discover relatively simple LFI without testing them one by one. 

This software is able to detect local file inclusions, using path traversal violation. 

Basic wordlist : 


```
/etc/passwd : Contient la liste des utilisateurs système (sans mots de passe)
/etc/shadow : Contient les mots de passe chiffrés (souvent inaccessible)
/etc/group : Informations sur les groupes d'utilisateurs
/etc/hostname : Nom d’hôte du système
/etc/issue : Message d'accueil affiché avant authentification
/etc/fstab : Points de montage des systèmes de fichiers
/etc/hosts : Résolution locale des noms d’hôtes
/etc/resolv.conf : Configuration des serveurs DNS
/etc/os-release : Informations sur la version du système d’exploitation
/proc/version : Version du noyau Linux
/proc/cpuinfo : Informations sur le processeur
/proc/meminfo : Informations sur la mémoire physique
/proc/self/environ : Variables d’environnement du processus en cours

/var/log/syslog : Logs système principaux (Debian/Ubuntu)
/var/log/messages : Logs système principaux (Red Hat/CentOS)
/var/log/dmesg : Logs du démarrage du noyau
/var/log/auth.log : Logs d’authentification (Debian/Ubuntu)
/var/log/secure : Logs d’authentification (Red Hat/CentOS)
/var/log/lastlog : Historique des dernières connexions
/var/log/wtmp : Historique des connexions réussies au système
/var/log/btmp : Logs des tentatives de connexion échouées

/var/log/apache2/access.log : Logs d’accès Apache
/var/log/apache2/error.log : Logs d’erreur Apache
/var/log/nginx/access.log : Logs d’accès Nginx
/var/log/nginx/error.log : Logs d’erreur Nginx

/etc/apache2/apache2.conf : Configuration principale d’Apache
/etc/nginx/nginx.conf : Configuration principale de Nginx
/etc/php/php.ini : Configuration principale de PHP
/etc/ssh/sshd_config : Configuration du service SSH
/etc/cron.d : Tâches planifiées spécifiques
/etc/crontab : Tâches planifiées globales
/var/spool/cron/crontabs : Tâches Cron personnalisées des utilisateurs

/var/www/html/index.php : Fichier PHP principal d'une application web
/var/www/html/wp-config.php : Configuration WordPress avec les identifiants MySQL
/var/www/html/.env : Contient souvent des configurations sensibles (bases de données, API)
/var/www/html/config.php : Configurations d’applications diverses (frameworks, CMS)
/var/www/html/.htaccess : Règles de réécriture pour Apache

/proc/net/tcp : Informations sur les connexions TCP ouvertes
/proc/net/udp : Informations sur les connexions UDP ouvertes
/proc/net/arp : Tableau ARP (adresses IP et MAC)
/proc/net/route : Table de routage réseau
/proc/net/dev : Statistiques des interfaces réseau

/root/.bash_history : Historique des commandes exécutées en tant que root
/home/*/.bash_history : Historique des commandes des utilisateurs normaux
/home/*/.ssh/id_rsa : Clé SSH privée d’un utilisateur
/home/*/.ssh/authorized_keys : Clés SSH autorisées
/tmp/sess_* : Sessions PHP temporaires (souvent exploitables)
/var/log/httpd/access_log : Logs d’accès Apache (autre format)

```

Supported files are automatically tested and displayed if found. 

It will soon be possible to use your own wordlist. 

LEVEL OF RECURSION 

You can control how deep will the software dive. Just remember that the deeper you're diving, less chances are to find what you're searching for.

## How to use it ? 

Specify the target : 

```- u <url>, -- url <url> ```

Choose the recursion level : 

```- r <number>, -- recursion <number>```

This parameter takes exactly one argument

Try to bypass rules :

```- a, -- advanced```

This parameter doesn't take any argument

Verbose mode : 

```- v, -- verbose```

This parameter doesn't take any argument it's just to chill, man. 

```- d , -- display```

You can choose how many lines you wanna display for the files found. Oc, it takes a number as an argument. 

Soon to be released :

```- w, -- wordlist```

Because who wants to use a payload he didn't even crafted, defo no fun + less chances to hit.


### What are the most common rules used to protect URLs against LFI ? 

1. % Inclusion
2. // method 

## Error messages you can possibly encounter in the jungle : 

``` Maybe you should think about having an actual connection lmao (check your fucking interfaces man)```

You receive this message when the curl output a 0 or 408/greatest error code. 
This can happen for several reason, I let you investigate by trying a curl on the target ip. 

Most of the time this message is triggered when you have no connection.
A ping never killed anyone. 


``` Server set in no sniffing mode```

When you're asking a server which methods are allowed it can sometimes tell you to fuck off. This is called no sniffing mode. 

How dare you try to spy on me ? 

``` Gotta dive deeper my friend ```

You can't drown in a cup of water. The precedent step of recursion was a failure.  Maybe the sea will be deeper. 

Also take a look at your soul while diving into the depths. 

``` You can't even find your own files in your computer and you wanna find some on a server xd ```

It basically means that the file you're trying to use isn't found. Verify the path.


