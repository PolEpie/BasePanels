# Memo pour les panels en LUA

Pour commencer, voir partie Instalation

## Instalation du Serveur de dev

- Télécharger [SteamCMD][stmcmd] 
- Créer un fichier ```steamcmd``` dans un répertoire facilement accesible
- Y déposer le fichier puis dans la barre de navigation ecrire ```cmd``` [(Voir la barre de navigation)][navBar]
- Une fois la console ouverte, y écrire ```steamcmd```
- Une fois les ficher téléchargés / installé, ecrire ```login anonymous```
- Ensuite nous allons indiquer le chemin d'accès pour y installer le serveur GMod ```force_install_dir C:/my_gmod_server```
- Ensuite nous allons installer gmod ```app_update 4020```
- Maintenant on va aller dans le dossier du serveur gmod entré à l'étape 6
- Puis déplacer le fichier ```startup.sh``` du repo vers la racine du dossier
- Il faut ensuite déplacer le dosser 
- Pour démarrer le serveur il suffit de cliquer sur ```startup.sh``` et le serveur se démarre automatiquement !

## Les Bases des panels

Les panels sont fait du coté client en LUA, c'est a dire que leur fichier 
doit toujours commencer par ```cl_```.


[stmcmd]: <https://developer.valvesoftware.com/wiki/SteamCMD#Windows>
[navbar]: <https://winaero.com/blog/wp-content/uploads/2019/09/Windows-10-File-Explorer-Address-Bar-Location-Icon.png>
