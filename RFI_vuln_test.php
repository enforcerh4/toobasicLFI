<?php
// Affichage d'un message pour tester l'inclusion
echo "Test de l'inclusion de fichier distant - Ceci n'est pas un fichier malicieux.<br>";

// Affichage des informations sur le serveur (utile pour voir ce que le serveur inclut)
echo "Serveur : " . $_SERVER['SERVER_NAME'] . "<br>";
echo "Fichier inclus depuis : " . $_SERVER['REQUEST_URI'] . "<br>";

// Affichage d'une variable PHP pour vérifier si le fichier a bien été inclus
$test_variable = "Ce fichier a été inclus avec succès !";
echo "Message : " . $test_variable . "<br>";

// Vous pouvez également afficher d'autres informations utiles pour tester le comportement du serveur
phpinfo();  // Affiche les informations PHP du serveur
?>
